package com.mrm.dal;

import com.mrm.model.Restaurant;
import com.mrm.model.RestaurantDeliveryZone;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class RestaurantDeliveryZoneDAO extends DBContext {

    public RestaurantDeliveryZone getFromResultSet(ResultSet rs) throws SQLException {
        RestaurantDeliveryZone zone = new RestaurantDeliveryZone();
        zone.setZoneId(rs.getInt("ZoneID"));
        zone.setRestaurantId(rs.getInt("RestaurantID"));
        zone.setZoneName(rs.getString("ZoneName"));
        zone.setZoneDefinition(rs.getString("ZoneDefinition"));
        zone.setIsActive(rs.getBoolean("IsActive"));
        zone.setCreatedAt(rs.getDate("CreatedAt"));
        
        // Try to get restaurant name if available from JOIN
        try {
            String restaurantName = rs.getString("RestaurantName");
            zone.setRestaurantName(restaurantName);
        } catch (SQLException e) {
            // RestaurantName column not available (not in JOIN query)
            zone.setRestaurantName(null);
        }
        
        return zone;
    }

    public List<RestaurantDeliveryZone> findZonesWithFilters(Integer restaurantId, String status, 
                                                              String search, int page, int pageSize) {
        List<RestaurantDeliveryZone> zones = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT rdz.*, r.Name AS RestaurantName ")
           .append("FROM RestaurantDeliveryZones rdz ")
           .append("LEFT JOIN Restaurants r ON rdz.RestaurantID = r.RestaurantID ")
           .append("WHERE 1=1 ");

        // Only filter by restaurant if restaurantId is provided
        if (restaurantId != null) {
            sql.append("AND rdz.RestaurantID = ? ");
        }

        if (status != null && !status.isEmpty()) {
            if (status.equalsIgnoreCase("active")) {
                sql.append("AND rdz.IsActive = 1 ");
            } else if (status.equalsIgnoreCase("inactive")) {
                sql.append("AND rdz.IsActive = 0 ");
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND rdz.ZoneName LIKE ? ");
        }

        sql.append("ORDER BY rdz.CreatedAt DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Only set restaurant parameter if provided
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (search != null && !search.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + search.trim() + "%");
            }
            
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex++, pageSize);

            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                zones.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding zones: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return zones;
    }

    public int getTotalFilteredZones(Integer restaurantId, String status, String search) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM RestaurantDeliveryZones WHERE 1=1 ");

        // Only filter by restaurant if restaurantId is provided
        if (restaurantId != null) {
            sql.append("AND RestaurantID = ? ");
        }

        if (status != null && !status.isEmpty()) {
            if (status.equalsIgnoreCase("active")) {
                sql.append("AND IsActive = 1 ");
            } else if (status.equalsIgnoreCase("inactive")) {
                sql.append("AND IsActive = 0 ");
            }
        }

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND ZoneName LIKE ? ");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Only set restaurant parameter if provided
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (search != null && !search.trim().isEmpty()) {
                statement.setString(paramIndex++, "%" + search.trim() + "%");
            }

            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting zones: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int insert(RestaurantDeliveryZone zone) {
        String sql = "INSERT INTO RestaurantDeliveryZones (RestaurantID, ZoneName, ZoneDefinition, IsActive) " +
                     "VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, zone.getRestaurantId());
            statement.setString(2, zone.getZoneName());
            statement.setString(3, zone.getZoneDefinition());
            statement.setBoolean(4, zone.getIsActive());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating zone failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating zone failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting zone: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public boolean update(RestaurantDeliveryZone zone) {
        String sql = "UPDATE RestaurantDeliveryZones SET ZoneName = ?, ZoneDefinition = ?, IsActive = ? " +
                     "WHERE ZoneID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, zone.getZoneName());
            statement.setString(2, zone.getZoneDefinition());
            statement.setBoolean(3, zone.getIsActive());
            statement.setInt(4, zone.getZoneId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating zone: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public RestaurantDeliveryZone findById(Integer zoneId) {
        String sql = "SELECT * FROM RestaurantDeliveryZones WHERE ZoneID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, zoneId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding zone by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean delete(Integer zoneId) {
        // Check if zone is associated with any active delivery fees
        String checkSql = "SELECT COUNT(*) FROM DeliveryFees WHERE ZoneID = ? AND IsActive = 1";
        String deleteSql = "DELETE FROM RestaurantDeliveryZones WHERE ZoneID = ?";

        try {
            connection = getConnection();
            
            // Check for active delivery fees
            statement = connection.prepareStatement(checkSql);
            statement.setInt(1, zoneId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next() && resultSet.getInt(1) > 0) {
                System.out.println("Cannot delete zone: associated with active delivery fees");
                return false;
            }
            
            // Proceed with deletion
            statement = connection.prepareStatement(deleteSql);
            statement.setInt(1, zoneId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting zone: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean toggleStatus(Integer zoneId) {
        String sql = "UPDATE RestaurantDeliveryZones SET IsActive = ~IsActive WHERE ZoneID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, zoneId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error toggling zone status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public List<RestaurantDeliveryZone> findAllByRestaurantId(Integer restaurantId) {
        List<RestaurantDeliveryZone> zones = new ArrayList<>();
        String sql = "SELECT * FROM RestaurantDeliveryZones WHERE RestaurantID = ? ORDER BY ZoneName";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                zones.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding zones by restaurant: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return zones;
    }

    /**
     * Get the first available restaurant ID from the database
     * Used when restaurantId is not in session
     * @return First restaurant ID or null if no restaurant exists
     */
    public Integer getFirstAvailableRestaurantId() {
        String sql = "SELECT TOP 1 RestaurantID FROM Restaurants WHERE Status = 'Approved' ORDER BY RestaurantID";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("RestaurantID");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting first restaurant ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Check if zone name already exists for a restaurant
     * @param restaurantId Restaurant ID
     * @param zoneName Zone name to check
     * @param excludeZoneId Zone ID to exclude (for edit scenario), can be null
     * @return true if zone name exists, false otherwise
     */
    public boolean isZoneNameExists(Integer restaurantId, String zoneName, Integer excludeZoneId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM RestaurantDeliveryZones ");
        sql.append("WHERE RestaurantID = ? AND LOWER(ZoneName) = LOWER(?)");
        
        if (excludeZoneId != null) {
            sql.append(" AND ZoneID != ?");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            statement.setInt(1, restaurantId);
            statement.setString(2, zoneName.trim());
            
            if (excludeZoneId != null) {
                statement.setInt(3, excludeZoneId);
            }

            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking zone name existence: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Get all active zones for delivery fee selection
     * @return List of all active zones
     */
    public List<RestaurantDeliveryZone> getAllActiveZones() {
        List<RestaurantDeliveryZone> zones = new ArrayList<>();
        String sql = "SELECT rdz.*, r.Name AS RestaurantName " +
                     "FROM RestaurantDeliveryZones rdz " +
                     "LEFT JOIN Restaurants r ON rdz.RestaurantID = r.RestaurantID " +
                     "WHERE rdz.IsActive = 1 " +
                     "ORDER BY r.Name, rdz.ZoneName";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                zones.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all active zones: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return zones;
    }

    /**
     * Get all approved restaurants for selection dropdown
     * @return List of all approved restaurants
     */
    public List<Restaurant> getAllApprovedRestaurants() {
        List<Restaurant> restaurants = new ArrayList<>();
        String sql = "SELECT RestaurantID, OwnerID, Name, Address, LicenseNumber, LogoUrl, " +
                     "ThemeColor, IsOpen, DeliveryFee, CommissionRate, Status, CreatedAt " +
                     "FROM Restaurants WHERE Status = 'Approved' ORDER BY Name";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                Restaurant restaurant = new Restaurant();
                restaurant.setRestaurantId(resultSet.getInt("RestaurantID"));
                restaurant.setOwnerId(resultSet.getInt("OwnerID"));
                restaurant.setName(resultSet.getString("Name"));
                restaurant.setAddress(resultSet.getString("Address"));
                restaurant.setLicenseNumber(resultSet.getString("LicenseNumber"));
                restaurant.setLogoUrl(resultSet.getString("LogoUrl"));
                restaurant.setThemeColor(resultSet.getString("ThemeColor"));
                restaurant.setIsOpen(resultSet.getBoolean("IsOpen"));
                restaurant.setDeliveryFee(resultSet.getDouble("DeliveryFee"));
                restaurant.setCommissionRate(resultSet.getDouble("CommissionRate"));
                restaurant.setStatus(resultSet.getString("Status"));
                restaurant.setCreatedAt(resultSet.getDate("CreatedAt"));
                restaurants.add(restaurant);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting all restaurants: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return restaurants;
    }
}
