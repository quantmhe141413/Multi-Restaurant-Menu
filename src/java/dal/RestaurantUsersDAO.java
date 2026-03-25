package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object (DAO) for RestaurantUsers table
 * This class handles all database operations related to user-restaurant relationships
 */
public class RestaurantUsersDAO extends DBContext {

    /**
     * Retrieve the RestaurantID associated with a given UserID
     * 
     * Business logic:
     * - A user may belong to a restaurant (e.g., Owner, Staff, Manager)
     * - Some users (e.g., SuperAdmin, Customer) may not belong to any restaurant
     * 
     * @param userId ID of the user
     * @return RestaurantID if found, otherwise null
     */
    public Integer getRestaurantIdByUserId(int userId) {

        // SQL query to get the first active restaurant assigned to the user
        String sql = "SELECT TOP 1 RestaurantID FROM RestaurantUsers " +
                     "WHERE UserID = ? AND IsActive = 1";

        try {
            // Prepare SQL statement
            PreparedStatement st = connection.prepareStatement(sql);

            // Set parameter value
            st.setInt(1, userId);

            // Execute query
            ResultSet rs = st.executeQuery();

            // If a record exists, return the RestaurantID
            if (rs.next()) {
                return rs.getInt("RestaurantID");
            }

        } catch (SQLException ex) {
            // Log error for debugging and monitoring
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Return null if no restaurant is found
        return null;
    }

    /**
     * Check whether a specific user belongs to a given restaurant
     * 
     * Business logic:
     * - Used for authorization (e.g., restrict access to restaurant data)
     * - Only active relationships are considered valid
     * 
     * @param userId ID of the user
     * @param restaurantId ID of the restaurant
     * @return true if user belongs to the restaurant, otherwise false
     */
    public boolean userBelongsToRestaurant(int userId, int restaurantId) {

        // SQL query to count matching records
        String sql = "SELECT COUNT(*) as count FROM RestaurantUsers " +
                     "WHERE UserID = ? AND RestaurantID = ? AND IsActive = 1";

        try {
            // Prepare statement
            PreparedStatement st = connection.prepareStatement(sql);

            // Set parameters
            st.setInt(1, userId);
            st.setInt(2, restaurantId);

            // Execute query
            ResultSet rs = st.executeQuery();

            // If count > 0, user belongs to restaurant
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }

        } catch (SQLException ex) {
            // Log exception details
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Default return false if no record found or error occurs
        return false;
    }

    /**
     * Get the role of a user within a specific restaurant
     * 
     * Possible roles:
     * - Owner
     * - Manager
     * - Staff
     * 
     * Business usage:
     * - Role-based authorization
     * - UI display logic
     * 
     * @param userId ID of the user
     * @param restaurantId ID of the restaurant
     * @return role as String if found, otherwise null
     */
    public String getRestaurantRole(int userId, int restaurantId) {

        // SQL query to get role of user in restaurant
        String sql = "SELECT RestaurantRole FROM RestaurantUsers " +
                     "WHERE UserID = ? AND RestaurantID = ? AND IsActive = 1";

        try {
            // Prepare statement
            PreparedStatement st = connection.prepareStatement(sql);

            // Set parameters
            st.setInt(1, userId);
            st.setInt(2, restaurantId);

            // Execute query
            ResultSet rs = st.executeQuery();

            // Return role if exists
            if (rs.next()) {
                return rs.getString("RestaurantRole");
            }

        } catch (SQLException ex) {
            // Log error
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        // Return null if role not found
        return null;
    }
}