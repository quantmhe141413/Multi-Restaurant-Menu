package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.CommissionHistory;

/**
 * Data Access Object (DAO) for handling commission change history
 * This class manages CRUD-like operations related to RestaurantCommissionHistory table
 */
public class CommissionHistoryDAO extends DBContext {

    /**
     * Check if the history table exists in the database
     * This is useful to avoid runtime errors if the table has not been created yet
     * 
     * @return true if table exists, otherwise false
     */
    public boolean historyTableExists() {
        String sql = "SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'RestaurantCommissionHistory'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            // If at least one row exists, table is present
            return rs.next();

        } catch (SQLException ex) {
            System.out.println("Error historyTableExists: " + ex.getMessage());
        }
        return false;
    }

    /**
     * Insert a new commission change history record
     * 
     * Business purpose:
     * - Track changes in commission rates for auditing
     * - Store old and new values along with who made the change
     * 
     * @param restaurantId ID of the restaurant
     * @param oldRate previous commission rate
     * @param newRate new commission rate
     * @param changedBy user ID who made the change
     * @param reason reason for the change
     * @return true if insert successful, otherwise false
     */
    public boolean insertHistory(int restaurantId, BigDecimal oldRate, BigDecimal newRate, int changedBy, String reason) {

        // Ensure table exists before inserting
        if (!historyTableExists()) {
            return false;
        }

        String sql = "INSERT INTO RestaurantCommissionHistory (RestaurantID, OldRate, NewRate, ChangedBy, Reason, ChangedAt) "
                + "VALUES (?, ?, ?, ?, ?, SYSUTCDATETIME())";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            // Set parameters
            st.setInt(1, restaurantId);
            st.setBigDecimal(2, oldRate);
            st.setBigDecimal(3, newRate);
            st.setInt(4, changedBy);
            st.setString(5, reason);

            // Execute insert
            return st.executeUpdate() > 0;

        } catch (SQLException ex) {
            System.out.println("Error insertHistory: " + ex.getMessage());
        }

        return false;
    }

    /**
     * Retrieve commission history records with optional filters and pagination
     * 
     * Filters:
     * - restaurantId: filter by specific restaurant
     * - search: search by restaurant name, user name, or email
     * 
     * @param restaurantId optional restaurant ID
     * @param search keyword for searching
     * @param page current page number
     * @param pageSize number of records per page
     * @return list of CommissionHistory objects
     */
    public List<CommissionHistory> findHistoryWithFilters(Integer restaurantId, String search, int page, int pageSize) {
        List<CommissionHistory> list = new ArrayList<>();

        // Return empty list if table does not exist
        if (!historyTableExists()) {
            return list;
        }

        StringBuilder sql = new StringBuilder();

        // Build query with JOIN to get related data
        sql.append("SELECT h.HistoryID, h.RestaurantID, r.Name AS RestaurantName, h.OldRate, h.NewRate, h.ChangedBy, ")
           .append("u.FullName AS ChangedByName, h.Reason, h.ChangedAt ")
           .append("FROM RestaurantCommissionHistory h ")
           .append("LEFT JOIN Restaurants r ON h.RestaurantID = r.RestaurantID ")
           .append("LEFT JOIN Users u ON h.ChangedBy = u.UserID ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filter by restaurant
        if (restaurantId != null) {
            sql.append("AND h.RestaurantID = ? ");
            params.add(restaurantId);
        }

        // Search filter (multiple fields)
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.Name LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ?) ");
            String q = "%" + search.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        // Sorting and pagination
        sql.append("ORDER BY h.ChangedAt DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        int offset = (page - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());

            // Dynamically set parameters
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }

            ResultSet rs = st.executeQuery();

            // Map each row to CommissionHistory object
            while (rs.next()) {
                CommissionHistory h = new CommissionHistory();
                h.setHistoryId(rs.getInt("HistoryID"));
                h.setRestaurantId(rs.getInt("RestaurantID"));
                h.setRestaurantName(rs.getString("RestaurantName"));
                h.setOldRate(rs.getBigDecimal("OldRate"));
                h.setNewRate(rs.getBigDecimal("NewRate"));
                h.setChangedBy(rs.getInt("ChangedBy"));
                h.setChangedByName(rs.getString("ChangedByName"));
                h.setReason(rs.getString("Reason"));
                h.setChangedAt(rs.getTimestamp("ChangedAt"));
                list.add(h);
            }

        } catch (SQLException ex) {
            System.out.println("Error findHistoryWithFilters: " + ex.getMessage());
        }

        return list;
    }

    /**
     * Count total commission history records with filters
     * Used for pagination (total pages calculation)
     * 
     * @param restaurantId optional restaurant filter
     * @param search search keyword
     * @return total number of matching records
     */
    public int getTotalFilteredHistory(Integer restaurantId, String search) {

        if (!historyTableExists()) {
            return 0;
        }

        StringBuilder sql = new StringBuilder();

        sql.append("SELECT COUNT(*) ")
           .append("FROM RestaurantCommissionHistory h ")
           .append("LEFT JOIN Restaurants r ON h.RestaurantID = r.RestaurantID ")
           .append("LEFT JOIN Users u ON h.ChangedBy = u.UserID ")
           .append("WHERE 1=1 ");

        List<Object> params = new ArrayList<>();

        // Filter by restaurant
        if (restaurantId != null) {
            sql.append("AND h.RestaurantID = ? ");
            params.add(restaurantId);
        }

        // Search filter
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (r.Name LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ?) ");
            String q = "%" + search.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());

            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (SQLException ex) {
            System.out.println("Error getTotalFilteredHistory: " + ex.getMessage());
        }

        return 0;
    }
}