package dal;

import models.BusinessHours;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BusinessHoursDAO extends DBContext {

    /**
     * Map ResultSet to BusinessHours object
     */
    public BusinessHours getFromResultSet(ResultSet rs) throws SQLException {
        BusinessHours hours = new BusinessHours();
        hours.setHoursId(rs.getInt("HoursID"));
        hours.setRestaurantId(rs.getInt("RestaurantID"));
        hours.setDayOfWeek(rs.getString("DayOfWeek"));
        hours.setOpeningTime(rs.getTime("OpeningTime"));
        hours.setClosingTime(rs.getTime("ClosingTime"));
        hours.setIsOpen(rs.getBoolean("IsOpen"));
        return hours;
    }

    /**
     * Get ALL business hours from all restaurants (for SuperAdmin)
     */
    public List<BusinessHours> findAll() {
        List<BusinessHours> hoursList = new ArrayList<>();
        String sql = "SELECT * FROM BusinessHours ORDER BY RestaurantID, " +
                     "CASE DayOfWeek " +
                     "WHEN 'Monday' THEN 1 " +
                     "WHEN 'Tuesday' THEN 2 " +
                     "WHEN 'Wednesday' THEN 3 " +
                     "WHEN 'Thursday' THEN 4 " +
                     "WHEN 'Friday' THEN 5 " +
                     "WHEN 'Saturday' THEN 6 " +
                     "WHEN 'Sunday' THEN 7 END";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                hoursList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all business hours: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return hoursList;
    }

    /**
     * Get all business hours for a restaurant (all 7 days)
     */
    public List<BusinessHours> findByRestaurantId(Integer restaurantId) {
        List<BusinessHours> hoursList = new ArrayList<>();
        String sql = "SELECT * FROM BusinessHours WHERE RestaurantID = ? ORDER BY " +
                     "CASE DayOfWeek " +
                     "WHEN 'Monday' THEN 1 " +
                     "WHEN 'Tuesday' THEN 2 " +
                     "WHEN 'Wednesday' THEN 3 " +
                     "WHEN 'Thursday' THEN 4 " +
                     "WHEN 'Friday' THEN 5 " +
                     "WHEN 'Saturday' THEN 6 " +
                     "WHEN 'Sunday' THEN 7 END";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                hoursList.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding business hours: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return hoursList;
    }

    /**
     * Update or insert business hours for a specific day
     */
    public boolean upsert(BusinessHours hours) {
        // Check if record exists
        String checkSql = "SELECT COUNT(*) FROM BusinessHours WHERE RestaurantID = ? AND DayOfWeek = ?";
        String updateSql = "UPDATE BusinessHours SET OpeningTime = ?, ClosingTime = ?, IsOpen = ? " +
                          "WHERE RestaurantID = ? AND DayOfWeek = ?";
        String insertSql = "INSERT INTO BusinessHours (RestaurantID, DayOfWeek, OpeningTime, ClosingTime, IsOpen) " +
                          "VALUES (?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            
            // Check if exists
            statement = connection.prepareStatement(checkSql);
            statement.setInt(1, hours.getRestaurantId());
            statement.setString(2, hours.getDayOfWeek());
            resultSet = statement.executeQuery();
            
            boolean exists = false;
            if (resultSet.next()) {
                exists = resultSet.getInt(1) > 0;
            }
            
            if (exists) {
                // Update
                statement = connection.prepareStatement(updateSql);
                statement.setTime(1, hours.getOpeningTime());
                statement.setTime(2, hours.getClosingTime());
                statement.setBoolean(3, hours.getIsOpen());
                statement.setInt(4, hours.getRestaurantId());
                statement.setString(5, hours.getDayOfWeek());
            } else {
                // Insert
                statement = connection.prepareStatement(insertSql);
                statement.setInt(1, hours.getRestaurantId());
                statement.setString(2, hours.getDayOfWeek());
                statement.setTime(3, hours.getOpeningTime());
                statement.setTime(4, hours.getClosingTime());
                statement.setBoolean(5, hours.getIsOpen());
            }
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error upserting business hours: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Initialize default business hours for a restaurant
     */
    public void initializeDefaultHours(Integer restaurantId) {
        String[] daysOfWeek = {"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"};
        
        for (String day : daysOfWeek) {
            BusinessHours hours = new BusinessHours();
            hours.setRestaurantId(restaurantId);
            hours.setDayOfWeek(day);
            hours.setOpeningTime(java.sql.Time.valueOf("09:00:00"));
            hours.setClosingTime(java.sql.Time.valueOf("22:00:00"));
            hours.setIsOpen(true);
            upsert(hours);
        }
    }
}
