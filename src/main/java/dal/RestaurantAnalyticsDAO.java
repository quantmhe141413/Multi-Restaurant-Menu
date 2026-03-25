package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.RestaurantAnalytics;

/**
 * DAO class for handling restaurant analytics queries
 */
public class RestaurantAnalyticsDAO extends DBContext {

    /**
     * Retrieve top N restaurants by total revenue
     *
     * @param topN number of top restaurants to retrieve
     * @return list of RestaurantAnalytics objects
     */
    public List<RestaurantAnalytics> getTopRestaurantsByRevenue(int topN) {
        List<RestaurantAnalytics> list = new ArrayList<>();

        // SQL query to get top N restaurants ordered by revenue and number of orders
        String sql = "SELECT TOP (?) RestaurantID, RestaurantName, TotalOrders, TotalRevenue "
                + "FROM vw_RestaurantAnalytics "
                + "ORDER BY TotalRevenue DESC, TotalOrders DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            // Set the value for TOP (?)
            st.setInt(1, topN);

            ResultSet rs = st.executeQuery();

            // Iterate through the result set
            while (rs.next()) {
                RestaurantAnalytics ra = new RestaurantAnalytics();

                // Map database columns to object fields
                ra.setRestaurantId(rs.getInt("RestaurantID"));
                ra.setRestaurantName(rs.getString("RestaurantName"));
                ra.setTotalOrders(rs.getInt("TotalOrders"));

                // Retrieve revenue (can be null)
                BigDecimal revenue = rs.getBigDecimal("TotalRevenue");

                // Handle null value by assigning ZERO
                ra.setTotalRevenue(revenue == null ? BigDecimal.ZERO : revenue);

                list.add(ra);
            }
        } catch (SQLException ex) {
            // Print error message
            System.out.println("Error getTopRestaurantsByRevenue: " + ex.getMessage());
        }

        return list;
    }

    /**
     * Calculate total revenue of all restaurants
     *
     * @return total revenue as BigDecimal
     */
    public BigDecimal getTotalRevenueAllRestaurants() {
        String sql = "SELECT SUM(TotalRevenue) FROM vw_RestaurantAnalytics";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);

                // Return ZERO if result is null
                return total == null ? BigDecimal.ZERO : total;
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalRevenueAllRestaurants: " + ex.getMessage());
        }

        return BigDecimal.ZERO;
    }

    /**
     * Calculate total number of orders across all restaurants
     *
     * @return total number of orders
     */
    public int getTotalOrdersAllRestaurants() {
        String sql = "SELECT SUM(TotalOrders) FROM vw_RestaurantAnalytics";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalOrdersAllRestaurants: " + ex.getMessage());
        }

        return 0;
    }

    /**
     * Count restaurants by status (e.g., Active, Inactive)
     *
     * @param status restaurant status
     * @return number of restaurants with the given status
     */
    public int countRestaurantsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Restaurants WHERE Status = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);

            // Set status parameter
            st.setString(1, status);

            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error countRestaurantsByStatus: " + ex.getMessage());
        }

        return 0;
    }

    /**
     * Count total number of restaurants in the system
     *
     * @return total number of restaurants
     */
    public int countAllRestaurants() {
        String sql = "SELECT COUNT(*) FROM Restaurants";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error countAllRestaurants: " + ex.getMessage());
        }

        return 0;
    }
}