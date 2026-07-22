package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.tomcat.jdbc.pool.DataSource;
import org.apache.tomcat.jdbc.pool.PoolProperties;

/**
 * Supplies JDBC connections to the MySQL database from a shared pool.
 *
 * Every request used to open its own connection and throw it away. Against a
 * local database that was merely wasteful; against a managed host it is the
 * dominant cost, because each connection pays a TCP round trip plus a full TLS
 * handshake before a single row is read. The pool opens a handful of
 * connections once and hands them out, so that cost is paid at startup instead
 * of on every page view.
 *
 * The pool implementation ships inside Tomcat (tomcat-jdbc.jar), so no extra
 * jar has to be downloaded or committed.
 *
 * Configuration comes from environment variables so the same WAR runs unchanged
 * locally, in Docker Compose, and on a PaaS host:
 *
 *   DB_HOST      (default: localhost)
 *   DB_PORT      (default: 3306)
 *   DB_NAME      (default: ProductIntro_WS2_ThangNDC_SE203709)
 *   DB_USER      (default: root)
 *   DB_PASSWORD  (default: empty)
 *   DB_SSL_MODE  (default: PREFERRED)
 *   DB_POOL_MAX  (default: 10)
 *
 * Hosts that expose a single connection string instead are supported through
 * DATABASE_URL / JDBC_DATABASE_URL / MYSQL_URL, which take precedence.
 */
public class ConnectDB {

    private static final Logger LOGGER = Logger.getLogger(ConnectDB.class.getName());

    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DATABASE = "ProductIntro_WS2_ThangNDC_SE203709";
    private static final String DEFAULT_USER = "root";

    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";

    /**
     * TLS mode passed to Connector/J.
     *
     * PREFERRED encrypts when the server offers TLS and falls back when it does
     * not, so the same default works against the local Docker MySQL and against
     * managed hosts like Aiven that require encryption. Neither PREFERRED nor
     * REQUIRED validates the server certificate, so a self-signed cert is fine.
     * Override with DB_SSL_MODE (DISABLED / PREFERRED / REQUIRED / VERIFY_CA).
     */
    private static final String DEFAULT_SSL_MODE = "PREFERRED";

    /**
     * Upper bound on pooled connections.
     *
     * Deliberately small: Aiven's free MySQL plan runs on 1 GB of RAM and
     * allows a limited number of client connections, and the free Render
     * instance this talks to is single-user in practice. Ten is far more than
     * this traffic needs and stays well clear of the server's limit.
     */
    private static final int DEFAULT_MAX_ACTIVE = 10;

    private static volatile DataSource dataSource;
    private static volatile String lastErrorMessage;

    private final String url;
    private final String user;
    private final String password;
    /** True when this instance was built with explicit, non-environment settings. */
    private final boolean bypassPool;

    public ConnectDB() {
        String hostUrl = firstNonBlank("DATABASE_URL", "JDBC_DATABASE_URL", "MYSQL_URL", "");
        if (!hostUrl.isEmpty()) {
            ParsedUrl parsed = ParsedUrl.of(hostUrl);
            this.url = parsed.url;
            this.user = parsed.user;
            this.password = parsed.password;
        } else {
            String host = firstNonBlank("DB_HOST", "MYSQL_HOST", DEFAULT_HOST);
            String port = firstNonBlank("DB_PORT", "MYSQL_PORT", DEFAULT_PORT);
            String dbName = firstNonBlank("DB_NAME", "MYSQL_DATABASE", DEFAULT_DATABASE);
            this.url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + urlOptions();
            this.user = firstNonBlank("DB_USER", "MYSQL_USER", DEFAULT_USER);
            this.password = firstNonBlank("DB_PASSWORD", "MYSQL_PASSWORD", "");
        }
        this.bypassPool = false;
    }

    /**
     * Connects to an explicitly named database, outside the shared pool.
     *
     * Kept for callers that need a one-off connection to somewhere other than
     * the configured application database.
     */
    public ConnectDB(String host, String port, String dbName, String user, String password) {
        this.url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + urlOptions();
        this.user = user;
        this.password = password;
        this.bypassPool = true;
    }

    public String getURLString() {
        return url;
    }

    public String getUser() {
        return user;
    }

    /**
     * Borrows a connection from the pool.
     *
     * The returned object is a proxy: calling close() on it, which every DAO
     * does through try-with-resources, returns it to the pool rather than
     * shutting the socket. No DAO had to change.
     */
    public Connection getConnection() throws SQLException {
        if (bypassPool) {
            return DriverManager.getConnection(url, user, password);
        }

        try {
            Connection connection = pool().getConnection();
            // Clear the sticky error. Without this, one transient failure leaves
            // the banner on the home page for the lifetime of the JVM, long
            // after the database has recovered.
            lastErrorMessage = null;
            return connection;
        } catch (SQLException ex) {
            String message = "Cannot connect to MySQL at " + safeUrl()
                    + " as user '" + user + "': " + ex.getMessage();
            lastErrorMessage = message;
            LOGGER.severe(message);
            throw new SQLException(message, ex.getSQLState(), ex.getErrorCode(), ex);
        }
    }

    /** Last connection failure, surfaced on the home page for diagnostics. */
    public static String getLastErrorMessage() {
        return lastErrorMessage;
    }

    /** Builds the pool on first use. */
    private DataSource pool() {
        DataSource existing = dataSource;
        if (existing != null) {
            return existing;
        }
        synchronized (ConnectDB.class) {
            if (dataSource == null) {
                dataSource = buildPool();
                LOGGER.info("Initialised JDBC connection pool for " + safeUrl()
                        + " (max " + maxActive() + " connections)");
            }
            return dataSource;
        }
    }

    private DataSource buildPool() {
        PoolProperties props = new PoolProperties();
        props.setUrl(url);
        props.setUsername(user);
        props.setPassword(password);
        props.setDriverClassName(MYSQL_DRIVER);

        props.setInitialSize(2);
        props.setMaxActive(maxActive());
        props.setMaxIdle(maxActive());
        props.setMinIdle(2);

        // Wait rather than fail instantly if every connection is busy.
        props.setMaxWait(10000);

        // Managed databases drop idle connections, and Aiven's free plan powers
        // the server down entirely when unused. Without validation the pool
        // would hand out a dead socket and the request would fail with a
        // confusing "Communications link failure".
        props.setValidationQuery("SELECT 1");
        props.setTestOnBorrow(true);
        props.setValidationInterval(30000);
        props.setTestWhileIdle(true);
        props.setTimeBetweenEvictionRunsMillis(30000);
        props.setMinEvictableIdleTimeMillis(60000);

        // Reclaim connections a buggy code path forgot to close.
        props.setRemoveAbandoned(true);
        props.setRemoveAbandonedTimeout(60);
        props.setLogAbandoned(true);

        DataSource ds = new DataSource();
        ds.setPoolProperties(props);
        return ds;
    }

    /** Closes the pool. Called when the web application shuts down. */
    public static synchronized void shutdown() {
        if (dataSource != null) {
            try {
                dataSource.close();
                LOGGER.info("JDBC connection pool closed.");
            } catch (RuntimeException ex) {
                LOGGER.log(Level.WARNING, "Error while closing the JDBC connection pool", ex);
            } finally {
                dataSource = null;
            }
        }
    }

    private static int maxActive() {
        String configured = firstNonBlank("DB_POOL_MAX", "MYSQL_POOL_MAX", "");
        if (configured.isEmpty()) {
            return DEFAULT_MAX_ACTIVE;
        }
        try {
            int value = Integer.parseInt(configured);
            return value > 0 ? value : DEFAULT_MAX_ACTIVE;
        } catch (NumberFormatException ex) {
            LOGGER.warning("DB_POOL_MAX is not a number: '" + configured
                    + "'. Falling back to " + DEFAULT_MAX_ACTIVE + ".");
            return DEFAULT_MAX_ACTIVE;
        }
    }

    /** Connection options appended to every JDBC URL. */
    private static String urlOptions() {
        return "?useUnicode=true"
                + "&characterEncoding=UTF-8"
                + "&sslMode=" + firstNonBlank("DB_SSL_MODE", "MYSQL_SSL_MODE", DEFAULT_SSL_MODE)
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC"
                + "&connectTimeout=10000"
                + "&socketTimeout=30000";
    }

    /** Strips query options so error messages stay readable. */
    private String safeUrl() {
        int optionsAt = url.indexOf('?');
        return optionsAt < 0 ? url : url.substring(0, optionsAt);
    }

    private static String firstNonBlank(String primaryEnv, String alternateEnv, String defaultValue) {
        String value = readEnv(primaryEnv);
        if (value.isEmpty()) {
            value = readEnv(alternateEnv);
        }
        return value.isEmpty() ? defaultValue : value;
    }

    private static String firstNonBlank(String a, String b, String c, String defaultValue) {
        String value = readEnv(a);
        if (value.isEmpty()) {
            value = readEnv(b);
        }
        if (value.isEmpty()) {
            value = readEnv(c);
        }
        return value.isEmpty() ? defaultValue : value;
    }

    private static String readEnv(String key) {
        String value = System.getenv(key);
        if (value == null || value.trim().isEmpty()) {
            value = System.getProperty(key);
        }
        return value == null ? "" : value.trim();
    }

    /**
     * Understands both a plain JDBC URL and the mysql://user:pass@host:port/db
     * form that PaaS providers hand out.
     */
    private static final class ParsedUrl {

        private final String url;
        private final String user;
        private final String password;

        private ParsedUrl(String url, String user, String password) {
            this.url = url;
            this.user = user;
            this.password = password;
        }

        static ParsedUrl of(String raw) {
            String value = raw.trim();

            if (value.startsWith("jdbc:")) {
                return new ParsedUrl(
                        withOptions(value),
                        firstNonBlank("DB_USER", "MYSQL_USER", DEFAULT_USER),
                        firstNonBlank("DB_PASSWORD", "MYSQL_PASSWORD", ""));
            }

            String stripped = value;
            int schemeAt = stripped.indexOf("://");
            if (schemeAt >= 0) {
                stripped = stripped.substring(schemeAt + 3);
            }

            String credentials = "";
            int atSign = stripped.lastIndexOf('@');
            if (atSign >= 0) {
                credentials = stripped.substring(0, atSign);
                stripped = stripped.substring(atSign + 1);
            }

            String parsedUser = DEFAULT_USER;
            String parsedPassword = "";
            if (!credentials.isEmpty()) {
                int colon = credentials.indexOf(':');
                if (colon >= 0) {
                    parsedUser = credentials.substring(0, colon);
                    parsedPassword = credentials.substring(colon + 1);
                } else {
                    parsedUser = credentials;
                }
            }

            return new ParsedUrl(withOptions("jdbc:mysql://" + stripped), parsedUser, parsedPassword);
        }

        private static String withOptions(String base) {
            return base.indexOf('?') >= 0 ? base : base + urlOptions();
        }
    }
}
