package dal;

import models.Restaurant;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSetMetaData;

public class TestInsert {
    public static void main(String[] args) {
        DBContext db = new DBContext();
        try {
            Connection conn = db.getConnection();
            Statement stmt = conn.createStatement();
            
            System.out.println("--- Restaurants Schema ---");
            ResultSet rs = stmt.executeQuery("SELECT TOP 0 * FROM Restaurants");
            ResultSetMetaData meta = rs.getMetaData();
            for (int i = 1; i <= meta.getColumnCount(); i++) {
                System.out.println(meta.getColumnName(i) + " - " + meta.getColumnTypeName(i) + " - Nullable: " + meta.isNullable(i));
            }
            
            System.out.println("\n--- Unique Constraints ---");
            ResultSet rs2 = stmt.executeQuery("SELECT KU.table_name, KU.column_name FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS AS TC INNER JOIN INFORMATION_SCHEMA.KEY_COLUMN_USAGE AS KU ON TC.CONSTRAINT_TYPE = 'UNIQUE' AND TC.CONSTRAINT_NAME = KU.CONSTRAINT_NAME WHERE KU.table_name = 'Restaurants'");
            while(rs2.next()) {
                System.out.println(rs2.getString(2) + " must be unique");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
