package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ConnectDB {

    private String ip;
    private String port;
    private String dbName;
    private String user;
    private String password;

    public ConnectDB() {
        this.ip = "localhost";
        this.port = "1433";
        this.dbName = "ProductIntro_WS2_ThangNDC_SE203709";
        this.user = "SA";
        this.password = "12345";
    }

    public ConnectDB(String ip, String port, String dbName, String user, String password) {
        this.ip = ip;
        this.port = port;
        this.dbName = dbName;
        this.user = user;
        this.password = password;
    }

    public String getIp() {
        return ip;
    }

    public void setIp(String ip) {
        this.ip = ip;
    }

    public String getPort() {
        return port;
    }

    public void setPort(String port) {
        this.port = port;
    }

    public String getDbName() {
        return dbName;
    }

    public void setDbName(String dbName) {
        this.dbName = dbName;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getURLString() {
        return String.format("jdbc:sqlserver://%s:%s;DatabaseName=%s;User=%s;Password=%s", this.ip, this.port, this.dbName, this.user, this.password);
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            con = DriverManager.getConnection(getURLString());
            System.out.println("Da ket noi");
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ConnectDB.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ConnectDB.class.getName()).log(Level.SEVERE, null, ex);
        }
        return con;
    }
}