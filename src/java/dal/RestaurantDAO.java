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
        if (zone != null && !zone.trim().isEmpty()) {
            sql.append("INNER JOIN RestaurantDeliveryZones dz ON r.RestaurantID = dz.RestaurantID ");
        }
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
        // Note: The Cuisine column does not exist in the Restaurants table schema
        // Returning empty list until the column is added to the database
        List<String> cuisines = new ArrayList<>();

        // Original query commented out as Cuisine column doesn't exist:
        // String sql = "SELECT DISTINCT Cuisine FROM Restaurants WHERE Status =
        // 'Approved' AND Cuisine IS NOT NULL ORDER BY Cuisine";
        // try {
        // PreparedStatement st = connection.prepareStatement(sql);
        // ResultSet rs = st.executeQuery();
        // while (rs.next()) {
        // String cuisine = rs.getString("Cuisine");
        // if (cuisine != null && !cuisine.trim().isEmpty()) {
        // cuisines.add(cuisine);
        // }
        // }
        // } catch (SQLException ex) {
        // Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        // }
        return cuisines;
    }

    public Restaurant getRestaurantById(int restaurantId) {
        String sql = "SELECT * FROM Restaurants WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
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

    // --- Restaurant Tables Management ---
    public java.util.List<models.RestaurantTable> getTablesByRestaurant(int restaurantId) {
        java.util.List<models.RestaurantTable> list = new java.util.ArrayList<>();
        String sql = "SELECT * FROM RestaurantTables WHERE RestaurantID = ? ORDER BY TableNumber";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                models.RestaurantTable t = new models.RestaurantTable();
                t.setTableID(rs.getInt("TableID"));
                t.setRestaurantID(rs.getInt("RestaurantID"));
                t.setTableNumber(rs.getString("TableNumber"));
                t.setCapacity(rs.getInt("Capacity"));
                t.setTableStatus(rs.getString("TableStatus"));
                try {
                    t.setCreatedAt(rs.getTimestamp("CreatedAt"));
                } catch (Exception ignored) {
                }
                list.add(t);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public boolean insertRestaurantTable(models.RestaurantTable table) {
        String sql = "INSERT INTO RestaurantTables (RestaurantID, TableNumber, Capacity, TableStatus, IsActive) VALUES (?, ?, ?, ?, 1)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, table.getRestaurantID());
            st.setString(2, table.getTableNumber());
            st.setInt(3, table.getCapacity());
            st.setString(4, table.getTableStatus());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateRestaurantTable(models.RestaurantTable table) {
        String sql = "UPDATE RestaurantTables SET TableNumber = ?, Capacity = ?, TableStatus = ?, IsActive = ? WHERE TableID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, table.getTableNumber());
            st.setInt(2, table.getCapacity());
            st.setString(3, table.getTableStatus());
            st.setBoolean(4, true);
            st.setInt(5, table.getTableID());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean setTableActive(int tableId, boolean active) {
        String sql = "UPDATE RestaurantTables SET IsActive = ? WHERE TableID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBoolean(1, active);
            st.setInt(2, tableId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public void insertRestaurant(models.Restaurant restaurant) {
        String sql = "INSERT INTO Restaurants (OwnerID, Name, Address, Phone, Description, IsOpen, Status, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getName());
            ps.setString(3, restaurant.getAddress());
            ps.setString(4, restaurant.getPhone());
            ps.setString(5, restaurant.getDescription());
            ps.setBoolean(6, restaurant.getIsOpen() != null ? restaurant.getIsOpen() : true);
            ps.setString(7, restaurant.getStatus() != null ? restaurant.getStatus() : "Approved");
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
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
        try {
            r.setPhone(rs.getString("Phone"));
        } catch (Exception ignored) {
        }
        try {
            r.setDescription(rs.getString("Description"));
        } catch (Exception ignored) {
        }
        try {
            r.setLicenseFileUrl(rs.getString("LicenseFileUrl"));
        } catch (Exception ignored) {
        }

        return r;
    }

    public void updateLicenseFile(int restaurantId, String licenseFileUrl) {
        String sql = "UPDATE Restaurants SET LicenseFileUrl = ? WHERE RestaurantID = ?";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, licenseFileUrl);
            ps.setInt(2, restaurantId);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLogoAndTheme(int restaurantId, String logoUrl, String themeColor) {
        String sql = "UPDATE Restaurants SET LogoUrl = ?, ThemeColor = ? WHERE RestaurantID = ?";
        try (java.sql.PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, logoUrl);
            ps.setString(2, themeColor);
            ps.setInt(3, restaurantId);
            ps.executeUpdate();
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
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
