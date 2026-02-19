package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Restaurant;

public class RestaurantDAO extends DBContext {

    public List<Restaurant> getAllApprovedRestaurants() {
        return getApprovedRestaurants(null, null, null);
    }

    public List<Restaurant> searchRestaurants(String query) {
        return getApprovedRestaurants(query, null, null);
    }

    public List<Restaurant> getApprovedRestaurants(String search, String zone, String cuisine) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT DISTINCT r.* FROM Restaurants r ");
        sql.append("LEFT JOIN RestaurantDeliveryZones dz ON r.RestaurantID = dz.RestaurantID ");
        sql.append("WHERE r.Status = 'Approved'");
        List<String> params = new ArrayList<>();

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND r.Name LIKE ?");
            params.add("%" + search.trim() + "%");
        }

        if (zone != null && !zone.trim().isEmpty()) {
            sql.append(" AND dz.ZoneName = ?");
            params.add(zone.trim());
        }

        if (cuisine != null && !cuisine.trim().isEmpty()) {
            sql.append(" AND r.Cuisine = ?");
            params.add(cuisine.trim());
        }

        sql.append(" ORDER BY r.Name");
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setString(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<String> getActiveZoneNames() {
        List<String> zones = new ArrayList<>();
        String sql = "SELECT DISTINCT ZoneName FROM RestaurantDeliveryZones WHERE IsActive = 1 ORDER BY ZoneName";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                zones.add(rs.getString("ZoneName"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return zones;
    }

    public List<String> getAvailableCuisines() {
        List<String> cuisines = new ArrayList<>();
        String sql = "SELECT DISTINCT Cuisine FROM Restaurants WHERE Status = 'Approved' AND Cuisine IS NOT NULL ORDER BY Cuisine";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                String cuisine = rs.getString("Cuisine");
                if (cuisine != null && !cuisine.trim().isEmpty()) {
                    cuisines.add(cuisine);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return cuisines;
    }

    public Restaurant getRestaurantByOwnerId(int ownerId) {
        String sql = "SELECT * FROM Restaurants WHERE OwnerID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getInt("RestaurantID"));
        r.setOwnerId(rs.getInt("OwnerID"));
        r.setName(rs.getString("Name"));
        r.setAddress(rs.getString("Address"));
        r.setLicenseNumber(rs.getString("LicenseNumber"));
        r.setLogoUrl(rs.getString("LogoUrl"));
        r.setThemeColor(rs.getString("ThemeColor"));
        r.setIsOpen(rs.getBoolean("IsOpen"));
        r.setDeliveryFee(rs.getDouble("DeliveryFee"));
        r.setCommissionRate(rs.getDouble("CommissionRate"));
        r.setStatus(rs.getString("Status"));
        r.setCreatedAt(rs.getDate("CreatedAt"));

        return r;
    }

    public static void main(String[] args) {
        RestaurantDAO dao = new RestaurantDAO();
        if (dao.connection != null) {
            System.out.println("Connection successful!");
            System.out.println("Testing getAllApprovedRestaurants()...");
            List<Restaurant> restaurants = dao.getAllApprovedRestaurants();
            System.out.println("Found " + restaurants.size() + " approved restaurants.");
            for (Restaurant r : restaurants) {
                System.out.println("- " + r.getName() + " (ID: " + r.getRestaurantId() + ")");
            }
        } else {
            System.out.println("Connection failed!");
        }
    }
}
