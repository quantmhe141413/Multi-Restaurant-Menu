package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.RestaurantTable;

public class RestaurantTableDAO extends DBContext {

    /**
     * Get all tables for a restaurant
     */
    public List<RestaurantTable> getTablesByRestaurant(int restaurantId) {
        List<RestaurantTable> tables = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantTables WHERE RestaurantID = ? AND IsActive = 1 ORDER BY TableNumber";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                RestaurantTable table = mapResultSetToTable(rs);
                tables.add(table);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantTableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return tables;
    }

    /**
     * Get table by ID with restaurant validation
     */
    public RestaurantTable getTableById(int tableId, int restaurantId) {
        String sql = "SELECT * FROM RestaurantTables WHERE TableID = ? AND RestaurantID = ? AND IsActive = 1";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, tableId);
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToTable(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantTableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }

    /**
     * Update table status
     */
    public boolean updateTableStatus(int tableId, String newStatus) {
        String sql = "UPDATE RestaurantTables SET TableStatus = ? WHERE TableID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setInt(2, tableId);
            
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantTableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }

    /**
     * Check if table has unpaid orders
     */
    public boolean hasUnpaidOrders(int tableId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE TableID = ? AND PaymentStatus != 'Success' AND IsClosed = 0";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, tableId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantTableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }

    /**
     * Close table (set status to Available and close all orders)
     */
    public boolean closeTable(int tableId) {
        String updateTableSql = "UPDATE RestaurantTables SET TableStatus = 'Available' WHERE TableID = ?";
        String updateOrdersSql = "UPDATE Orders SET IsClosed = 1 WHERE TableID = ? AND IsClosed = 0";
        
        try {
            // Update table status
            PreparedStatement st1 = connection.prepareStatement(updateTableSql);
            st1.setInt(1, tableId);
            st1.executeUpdate();
            
            // Close all orders for this table
            PreparedStatement st2 = connection.prepareStatement(updateOrdersSql);
            st2.setInt(1, tableId);
            st2.executeUpdate();
            
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantTableDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return false;
    }

    /**
     * Map ResultSet to RestaurantTable object
     */
    private RestaurantTable mapResultSetToTable(ResultSet rs) throws SQLException {
        RestaurantTable table = new RestaurantTable();
        table.setTableID(rs.getInt("TableID"));
        table.setRestaurantID(rs.getInt("RestaurantID"));
        table.setTableNumber(rs.getString("TableNumber"));
        table.setCapacity(rs.getInt("Capacity"));
        table.setTableStatus(rs.getString("TableStatus"));
        return table;
    }
}
