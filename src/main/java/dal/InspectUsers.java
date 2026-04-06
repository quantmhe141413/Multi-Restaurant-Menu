package dal;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;

public class InspectUsers {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try {
            Connection conn = db.connection;
            Statement stmt = conn.createStatement();
            
            System.out.println("--- Users Table Schema ---");
            ResultSet rs = stmt.executeQuery("SELECT TOP 0 * FROM Users");
            ResultSetMetaData meta = rs.getMetaData();
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                System.out.println(meta.getColumnName(i) + " - " + meta.getColumnTypeName(i) + " - Nullable: " + (meta.isNullable(i) != 0));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
