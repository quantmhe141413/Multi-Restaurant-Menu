package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.RestaurantAnalytics;

public class RestaurantAnalyticsDAO extends DBContext {

    public List<RestaurantAnalytics> getTopRestaurantsByRevenue(int topN) {
        List<RestaurantAnalytics> list = new ArrayList<>();
        String sql = "SELECT TOP (?) RestaurantID, RestaurantName, TotalOrders, TotalRevenue "
                + "FROM vw_RestaurantAnalytics "
                + "ORDER BY TotalRevenue DESC, TotalOrders DESC";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, topN);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                RestaurantAnalytics ra = new RestaurantAnalytics();
                ra.setRestaurantId(rs.getInt("RestaurantID"));
                ra.setRestaurantName(rs.getString("RestaurantName"));
                ra.setTotalOrders(rs.getInt("TotalOrders"));
                BigDecimal revenue = rs.getBigDecimal("TotalRevenue");
                ra.setTotalRevenue(revenue == null ? BigDecimal.ZERO : revenue);
                list.add(ra);
            }
        } catch (SQLException ex) {
            System.out.println("Error getTopRestaurantsByRevenue: " + ex.getMessage());
        } 

        return list;
    }

    public BigDecimal getTotalRevenueAllRestaurants() {
        String sql = "SELECT SUM(TotalRevenue) FROM vw_RestaurantAnalytics";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                BigDecimal total = rs.getBigDecimal(1);
                return total == null ? BigDecimal.ZERO : total;
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalRevenueAllRestaurants: " + ex.getMessage());
        } 
        return BigDecimal.ZERO;
    }

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

    public int countRestaurantsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Restaurants WHERE Status = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
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
