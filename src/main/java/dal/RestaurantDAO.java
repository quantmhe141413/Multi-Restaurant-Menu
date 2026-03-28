package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.math.BigDecimal;
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

        // Note: Cuisine column does not exist in the database schema
        // Removed cuisine filter as the Restaurants table does not have a Cuisine column
        // if (cuisine != null && !cuisine.trim().isEmpty()) {
        //     sql.append(" AND r.Cuisine = ?");
        //     params.add(cuisine.trim());
        // }

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
        // String sql = "SELECT DISTINCT Cuisine FROM Restaurants WHERE Status = 'Approved' AND Cuisine IS NOT NULL ORDER BY Cuisine";
        // try {
        //     PreparedStatement st = connection.prepareStatement(sql);
        //     ResultSet rs = st.executeQuery();
        //     while (rs.next()) {
        //         String cuisine = rs.getString("Cuisine");
        //         if (cuisine != null && !cuisine.trim().isEmpty()) {
        //             cuisines.add(cuisine);
        //         }
        //     }
        // } catch (SQLException ex) {
        //     Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
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

    /**
     * Get all restaurants owned by a specific owner.
     */
    public List<Restaurant> getRestaurantsByOwnerId(int ownerId) {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT RestaurantID, OwnerID, Name, Status FROM Restaurants WHERE OwnerID = ? ORDER BY Name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, ownerId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Restaurant r = new Restaurant();
                r.setRestaurantId(rs.getInt("RestaurantID"));
                r.setOwnerId(rs.getInt("OwnerID"));
                r.setName(rs.getString("Name"));
                r.setStatus(rs.getString("Status"));
                list.add(r);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Restaurant> getAllRestaurantsForDropdown() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT RestaurantID, Name, Status FROM Restaurants ORDER BY Name";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Restaurant r = new Restaurant();
                r.setRestaurantId(rs.getInt("RestaurantID"));
                r.setName(rs.getString("Name"));
                r.setStatus(rs.getString("Status"));
                list.add(r);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<Restaurant> findRestaurantsForCommissionConfig(String status, String search, int page, int pageSize) {
        return findRestaurantsWithFilters(status, search, page, pageSize);
    }

    public List<Restaurant> findRestaurantsWithFilters(String status, String search, int page, int pageSize) {
        List<Restaurant> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, u.FullName AS OwnerName, u.Email AS OwnerEmail ");
        sql.append("FROM Restaurants r ");
        sql.append("LEFT JOIN Users u ON r.OwnerID = u.UserID ");
        sql.append("WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ?");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (r.Name LIKE ? OR r.LicenseNumber LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ?)");
            String q = "%" + search.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        sql.append(" ORDER BY r.CreatedAt DESC");
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        int offset = (page - 1) * pageSize;
        params.add(offset);
        params.add(pageSize);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Restaurant r = mapRestaurant(rs);
                r.setOwnerName(rs.getString("OwnerName"));
                r.setOwnerEmail(rs.getString("OwnerEmail"));
                list.add(r);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public int getTotalFilteredRestaurants(String status, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ");
        sql.append("FROM Restaurants r ");
        sql.append("LEFT JOIN Users u ON r.OwnerID = u.UserID ");
        sql.append("WHERE 1=1");

        List<Object> params = new ArrayList<>();
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND r.Status = ?");
            params.add(status.trim());
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (r.Name LIKE ? OR r.LicenseNumber LIKE ? OR u.FullName LIKE ? OR u.Email LIKE ?)");
            String q = "%" + search.trim() + "%";
            params.add(q);
            params.add(q);
            params.add(q);
            params.add(q);
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                st.setObject(i + 1, params.get(i));
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    public boolean updateRestaurantStatus(int restaurantId, String newStatus) {
        String sql = "UPDATE Restaurants SET Status = ? WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setInt(2, restaurantId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateCommissionRate(int restaurantId, BigDecimal newRate) {
        String sql = "UPDATE Restaurants SET CommissionRate = ? WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setBigDecimal(1, newRate);
            st.setInt(2, restaurantId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public Restaurant findByIdWithOwner(int restaurantId) {
        String sql = "SELECT r.*, u.FullName AS OwnerName, u.Email AS OwnerEmail "
                + "FROM Restaurants r LEFT JOIN Users u ON r.OwnerID = u.UserID "
                + "WHERE r.RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                Restaurant r = mapRestaurant(rs);
                r.setOwnerName(rs.getString("OwnerName"));
                r.setOwnerEmail(rs.getString("OwnerEmail"));
                return r;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean updateRestaurantStatus(int restaurantId, String newStatus, String reason) {
        String reasonTrimmed = reason == null ? null : reason.trim();
        if (reasonTrimmed == null || reasonTrimmed.isEmpty()) {
            return updateRestaurantStatus(restaurantId, newStatus);
        }

        String reasonColumn = null;
        if ("Approved".equalsIgnoreCase(newStatus) && columnExists("ApprovalReason")) {
            reasonColumn = "ApprovalReason";
        } else if ("Rejected".equalsIgnoreCase(newStatus) && columnExists("RejectionReason")) {
            reasonColumn = "RejectionReason";
        } else if (columnExists("StatusReason")) {
            reasonColumn = "StatusReason";
        } else if (columnExists("AdminNote")) {
            reasonColumn = "AdminNote";
        } else if (columnExists("Note")) {
            reasonColumn = "Note";
        }

        if (reasonColumn == null) {
            return updateRestaurantStatus(restaurantId, newStatus);
        }

        String sql = "UPDATE Restaurants SET Status = ?, " + reasonColumn + " = ? WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setString(2, reasonTrimmed);
            st.setInt(3, restaurantId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    private boolean columnExists(String columnName) {
        String sql = "SELECT 1 FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'Restaurants' AND COLUMN_NAME = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, columnName);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public void insertRestaurant(Restaurant restaurant) {
        String sql = "INSERT INTO Restaurants (OwnerID, Name, Address, Status, CreatedAt) " +
                     "VALUES (?, ?, ?, 'Pending', GETDATE())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, restaurant.getOwnerId());
            ps.setString(2, restaurant.getName());
            ps.setString(3, restaurant.getAddress());
            ps.executeUpdate();
        } catch (SQLException e) {
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

    public void updateRestaurantCoreInfo(Restaurant restaurant) {
        String sql = "UPDATE Restaurants SET Name = ?, Address = ?, Phone = ?, Description = ? WHERE RestaurantID = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getAddress());
            ps.setString(3, restaurant.getPhone());
            ps.setString(4, restaurant.getDescription());
            ps.setInt(5, restaurant.getRestaurantId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLicenseFile(int restaurantId, String licenseFileUrl) {
        String sql = "UPDATE Restaurants SET LicenseFileUrl = ? WHERE RestaurantID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, licenseFileUrl);
            ps.setInt(2, restaurantId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLogoAndTheme(int restaurantId, String logoUrl, String themeColor) {
        String sql = "UPDATE Restaurants SET LogoUrl = ?, ThemeColor = ? WHERE RestaurantID = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, logoUrl);
            ps.setString(2, themeColor);
            ps.setInt(3, restaurantId);
            ps.executeUpdate();
        } catch (SQLException e) {
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
    
    // Pagination methods
    public List<Restaurant> getApprovedRestaurants(String search, String zone, String cuisine, int page, int pageSize) {
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

        sql.append(" ORDER BY r.Name ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            for (String param : params) {
                st.setString(idx++, param);
            }
            st.setInt(idx++, (page - 1) * pageSize);
            st.setInt(idx++, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapRestaurant(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }
    
    public int countApprovedRestaurants(String search, String zone, String cuisine) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(DISTINCT r.RestaurantID) FROM Restaurants r ");
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

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            for (String param : params) {
                st.setString(idx++, param);
            }
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RestaurantDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }
}
