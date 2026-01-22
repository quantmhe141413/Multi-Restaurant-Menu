package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * DBContext class for managing SQL Server connection
 * Using local setup for MultiRestaurantOrderingDB
 */
public class DBContext {
    protected Connection connection;

    public DBContext() {
        try {
            // Edit your connection details here
            String user = "sa";
            String pass = "Passw0rd@123";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=MultiRestaurantOrderingDB;encrypt=true;trustServerCertificate=true";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public static void main(String[] args) {
        DBContext db = new DBContext();
        if (db.connection != null) {
            System.out.println("Connection successful!");
        } else {
            System.out.println("Connection failed!");
        }
    }
}
