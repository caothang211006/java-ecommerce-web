package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Logger;

public class ConnectDB {

    private static final Logger LOGGER = Logger.getLogger(ConnectDB.class.getName());

    private static final String DEFAULT_HOST = "localhost";
    private static final String DEFAULT_PORT = "3306";
    private static final String DEFAULT_DATABASE = "ProductIntro_WS2_ThangNDC_SE203709";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "";
    private static final String MYSQL_DRIVER = "com.mysql.cj.jdbc.Driver";

    private final String host;
    private final String port;
    private final String dbName;
    private final String user;
    private final String password;

    public ConnectDB() {
        this.host = firstNonBlank("DB_HOST", "MYSQLHOST", DEFAULT_HOST);
        this.port = firstNonBlank("DB_PORT", "MYSQLPORT", DEFAULT_PORT);
        this.dbName = firstNonBlank("DB_NAME", "MYSQLDATABASE", DEFAULT_DATABASE);
        this.user = firstNonBlank("DB_USER", "MYSQLUSER", DEFAULT_USER);
        this.password = firstNonBlank("DB_PASSWORD", "MYSQLPASSWORD", DEFAULT_PASSWORD);
    }

    public ConnectDB(String host, String port, String dbName, String user, String password) {
        this.host = host;
        this.port = port;
        this.dbName = dbName;
        this.user = user;
        this.password = password;
    }

    public String getHost() {
        return host;
    }

    public String getPort() {
        return port;
    }

    public String getDbName() {
        return dbName;
    }

    public String getUser() {
        return user;
    }

    public String getPassword() {
        return password;
    }

    public String getURLString() {
        return String.format(
                "jdbc:mysql://%s:%s/%s?useUnicode=true&characterEncoding=UTF-8&serverTimezone=UTC&allowPublicKeyRetrieval=true&useSSL=false",
                this.host,
                this.port,
                this.dbName
        );
    }

    public Connection getConnection() {
        try {
            Class.forName(MYSQL_DRIVER);
            return DriverManager.getConnection(getURLString(), user, password);
        } catch (ClassNotFoundException ex) {
            LOGGER.severe("MySQL JDBC driver was not found. Add mysql-connector-j to WEB-INF/lib.");
        } catch (SQLException ex) {
            LOGGER.severe("Cannot connect to MySQL database: " + ex.getMessage());
        }
        return null;
    }

    private static String firstNonBlank(String primaryEnv, String railwayEnv, String defaultValue) {
        String value = System.getenv(primaryEnv);
        if (value == null || value.trim().isEmpty()) {
            value = System.getenv(railwayEnv);
        }
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        return value.trim();
    }
}
