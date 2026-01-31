package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {

    protected Connection connection;
    protected ResultSet resultSet;
    protected PreparedStatement statement;

    public DBContext() {
        try {
<<<<<<< HEAD
            // Edit your connection details here
            String user = "sa";
            String pass = "123";
            String url = "jdbc:sqlserver://localhost:1433;databaseName=MultiRestaurantOrderingDB;encrypt=true;trustServerCertificate=true";
=======
            // Change the username password and url to connect your own database
            String username = "sa";
            String password = "555"; // s
            String url = "jdbc:sqlserver://localhost:1433;databaseName=MultiRestaurantOrderingDB2;encrypt=false;trustServerCertificate=true";
>>>>>>> 0aad6e27f51f6d74006f3bfab0b19f6752935075
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }
    
    public void closeResources() {
        try {
            if (resultSet != null && !resultSet.isClosed()) {
                resultSet.close();
            }
            if (statement != null && !statement.isClosed()) {
                statement.close();
            }
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException ex) {
            Logger.getLogger(DBContext.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    public Connection getConnection() {
        return new DBContext().connection;
    }
    
    public static void main(String[] args) {
        System.out.println(new DBContext().connection);
    }
}
