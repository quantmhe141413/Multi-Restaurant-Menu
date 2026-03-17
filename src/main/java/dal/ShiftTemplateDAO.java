package dal;

import models.ShiftTemplate;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class ShiftTemplateDAO extends DBContext {

    /**
     * Map ResultSet to ShiftTemplate object
     */
    public ShiftTemplate getFromResultSet(ResultSet rs) throws SQLException {
        ShiftTemplate template = new ShiftTemplate();
        template.setTemplateId(rs.getInt("TemplateID"));
        template.setRestaurantId(rs.getInt("RestaurantID"));
        template.setShiftName(rs.getString("ShiftName"));
        template.setPosition(rs.getString("Position"));
        template.setStartTime(rs.getTime("StartTime"));
        template.setEndTime(rs.getTime("EndTime"));
        template.setIsActive(rs.getBoolean("IsActive"));
        return template;
    }

    /**
     * Get ALL shift templates from all restaurants (for SuperAdmin)
     */
    public List<ShiftTemplate> findAll() {
        List<ShiftTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM ShiftTemplates ORDER BY RestaurantID, StartTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                templates.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all shift templates: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return templates;
    }

    /**
     * Get all shift templates for a restaurant
     */
    public List<ShiftTemplate> findByRestaurantId(Integer restaurantId) {
        List<ShiftTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM ShiftTemplates WHERE RestaurantID = ? ORDER BY StartTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                templates.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shift templates: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return templates;
    }

    /**
     * Get active shift templates for a restaurant
     */
    public List<ShiftTemplate> findActiveByRestaurantId(Integer restaurantId) {
        List<ShiftTemplate> templates = new ArrayList<>();
        String sql = "SELECT * FROM ShiftTemplates WHERE RestaurantID = ? AND IsActive = 1 ORDER BY StartTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                templates.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding active shift templates: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return templates;
    }

    /**
     * Insert new shift template
     */
    public int insert(ShiftTemplate template) {
        String sql = "INSERT INTO ShiftTemplates (RestaurantID, ShiftName, Position, StartTime, EndTime, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, template.getRestaurantId());
            statement.setString(2, template.getShiftName());
            statement.setString(3, template.getPosition());
            statement.setTime(4, template.getStartTime());
            statement.setTime(5, template.getEndTime());
            statement.setBoolean(6, template.getIsActive());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating shift template failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating shift template failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting shift template: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Update shift template
     */
    public boolean update(ShiftTemplate template) {
        String sql = "UPDATE ShiftTemplates SET ShiftName = ?, Position = ?, " +
                     "StartTime = ?, EndTime = ?, IsActive = ? WHERE TemplateID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, template.getShiftName());
            statement.setString(2, template.getPosition());
            statement.setTime(3, template.getStartTime());
            statement.setTime(4, template.getEndTime());
            statement.setBoolean(5, template.getIsActive());
            statement.setInt(6, template.getTemplateId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating shift template: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Toggle active status
     */
    public boolean toggleStatus(Integer templateId) {
        String sql = "UPDATE ShiftTemplates SET IsActive = ~IsActive WHERE TemplateID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, templateId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error toggling template status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Find by ID
     */
    public ShiftTemplate findById(Integer templateId) {
        String sql = "SELECT * FROM ShiftTemplates WHERE TemplateID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, templateId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding template by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}
