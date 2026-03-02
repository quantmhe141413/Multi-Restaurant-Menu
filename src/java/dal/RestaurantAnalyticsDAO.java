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
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, topN);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                RestaurantAnalytics ra = new RestaurantAnalytics();
                ra.setRestaurantId(resultSet.getInt("RestaurantID"));
                ra.setRestaurantName(resultSet.getString("RestaurantName"));
                ra.setTotalOrders(resultSet.getInt("TotalOrders"));
                BigDecimal revenue = resultSet.getBigDecimal("TotalRevenue");
                ra.setTotalRevenue(revenue == null ? BigDecimal.ZERO : revenue);
                list.add(ra);
            }
        } catch (SQLException ex) {
            System.out.println("Error getTopRestaurantsByRevenue: " + ex.getMessage());
        } finally {
            closeResources();
        }

        return list;
    }

    public BigDecimal getTotalRevenueAllRestaurants() {
        String sql = "SELECT SUM(TotalRevenue) FROM vw_RestaurantAnalytics";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                BigDecimal total = resultSet.getBigDecimal(1);
                return total == null ? BigDecimal.ZERO : total;
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalRevenueAllRestaurants: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return BigDecimal.ZERO;
    }

    public int getTotalOrdersAllRestaurants() {
        String sql = "SELECT SUM(TotalOrders) FROM vw_RestaurantAnalytics";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalOrdersAllRestaurants: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countRestaurantsByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM Restaurants WHERE Status = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error countRestaurantsByStatus: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int countAllRestaurants() {
        String sql = "SELECT COUNT(*) FROM Restaurants";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error countAllRestaurants: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }
}
