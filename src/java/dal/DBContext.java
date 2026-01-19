package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class DBContext {
    // Update database name to LibraryDB
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=LibraryDB;encrypt=false";
    private static final String USER = "sa";
    private static final String PASS = "12345";

    public static Connection getConnection() {
        Connection conn = null;
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            e.printStackTrace();
        }
        return conn;
    }

    public static void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }

    public static void closePreparedStatement(PreparedStatement ps) {
        if (ps != null) {
            try {
                ps.close();
            } catch (SQLException e) {
                System.out.println("Error closing PreparedStatement: " + e.getMessage());
            }
        }
    }

    public static void closeResultSet(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.out.println("Error closing ResultSet: " + e.getMessage());
            }
        }
    }
}
