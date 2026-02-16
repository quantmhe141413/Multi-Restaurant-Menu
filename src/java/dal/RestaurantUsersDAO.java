package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class RestaurantUsersDAO extends DBContext {

    /**
     * Get RestaurantID for a user based on their UserID
     * Returns null if user is not assigned to any restaurant (e.g., SuperAdmin, Customer)
     */
    public Integer getRestaurantIdByUserId(int userId) {
        String sql = "SELECT TOP 1 RestaurantID FROM RestaurantUsers " +
                     "WHERE UserID = ? AND IsActive = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("RestaurantID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Check if a user belongs to a specific restaurant
     */
    public boolean userBelongsToRestaurant(int userId, int restaurantId) {
        String sql = "SELECT COUNT(*) as count FROM RestaurantUsers " +
                     "WHERE UserID = ? AND RestaurantID = ? AND IsActive = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("count") > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    /**
     * Get restaurant role for a user (Owner, Staff, Manager)
     */
    public String getRestaurantRole(int userId, int restaurantId) {
        String sql = "SELECT RestaurantRole FROM RestaurantUsers " +
                     "WHERE UserID = ? AND RestaurantID = ? AND IsActive = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getString("RestaurantRole");
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantUsersDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }
}
