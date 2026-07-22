package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

/**
 * Creates JDBC connections to the MySQL database.
 *
 * Configuration comes from environment variables so the same WAR runs
 * unchanged locally, in Docker Compose, and on a PaaS host:
 *
 *   DB_HOST      (default: localhost)
 *   DB_PORT      (default: 3306)
 *   DB_NAME      (default: ProductIntro_WS2_ThangNDC_SE203709)
 *   DB_USER      (default: root)
 *   DB_PASSWORD  (default: empty)
 *
 * Some hosts (Railway, Render, Heroku) instead expose a single connection
 * string. DATABASE_URL / JDBC_DATABASE_URL / MYSQL_URL are honoured and take
 * precedence over the individual variables when present.
 */
public class ConnectDB {

    private static final Logger LOGGER = Logger.getLogger(ConnectDB.class.getName());

    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DATABASE = "ProductIntro_WS2_ThangNDC_SE203709";
    private static final String DEFAULT_USER = "root";

    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";
    private static final String LEGACY_MYSQL_DRIVER = "com.mysql.jdbc.Driver";

    private static final int LOGIN_TIMEOUT_SECONDS = 5;

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

    private static volatile boolean driverLoaded = false;
    private static volatile String lastErrorMessage;

    private final String url;
    private final String user;
    private final String password;

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
    }

    public ConnectDB(String host, String port, String dbName, String user, String password) {
        this.url = "jdbc:mysql://" + host + ":" + port + "/" + dbName + urlOptions();
        this.user = user;
        this.password = password;
    }

    public String getURLString() {
        return url;
    }

    public String getUser() {
        return user;
    }

    /**
     * Opens a new connection.
     *
     * Throws instead of returning null: a null connection previously surfaced
     * as a NullPointerException deep inside a DAO, which hid the real cause.
     * Every DAO already wraps this call in try/catch, so the error is caught
     * and logged at the point of use with a message that says what went wrong.
     */
    public Connection getConnection() throws SQLException {
        loadDriver();
        DriverManager.setLoginTimeout(LOGIN_TIMEOUT_SECONDS);
        try {
            return DriverManager.getConnection(url, user, password);
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

    private static void loadDriver() throws SQLException {
        if (driverLoaded) {
            return;
        }
        try {
            Class.forName(MYSQL_DRIVER);
        } catch (ClassNotFoundException ex) {
            try {
                Class.forName(LEGACY_MYSQL_DRIVER);
            } catch (ClassNotFoundException legacyEx) {
                String message = "MySQL JDBC driver not found. "
                        + "Add mysql-connector-j to WEB-INF/lib.";
                lastErrorMessage = message;
                LOGGER.severe(message);
                throw new SQLException(message, legacyEx);
            }
        }
        driverLoaded = true;
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
