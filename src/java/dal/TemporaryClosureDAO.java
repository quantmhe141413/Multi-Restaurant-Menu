package dal;

import models.TemporaryClosure;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class TemporaryClosureDAO extends DBContext {

    /**
     * Map ResultSet to TemporaryClosure object
     */
    public TemporaryClosure getFromResultSet(ResultSet rs) throws SQLException {
        TemporaryClosure closure = new TemporaryClosure();
        closure.setClosureId(rs.getInt("ClosureID"));
        closure.setRestaurantId(rs.getInt("RestaurantID"));
        closure.setStartDateTime(rs.getTimestamp("StartDateTime"));
        closure.setEndDateTime(rs.getTimestamp("EndDateTime"));
        closure.setReason(rs.getString("Reason"));
        closure.setIsActive(rs.getBoolean("IsActive"));
        closure.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return closure;
    }

    /**
     * Get ALL temporary closures from all restaurants (for SuperAdmin)
     */
    public List<TemporaryClosure> findAll() {
        List<TemporaryClosure> closures = new ArrayList<>();
        String sql = "SELECT * FROM TemporaryClosures ORDER BY RestaurantID, StartDateTime DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                closures.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all temporary closures: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return closures;
    }

    /**
     * Get all temporary closures for a restaurant
     */
    public List<TemporaryClosure> findByRestaurantId(Integer restaurantId) {
        List<TemporaryClosure> closures = new ArrayList<>();
        String sql = "SELECT * FROM TemporaryClosures WHERE RestaurantID = ? ORDER BY StartDateTime DESC";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                closures.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding temporary closures: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return closures;
    }

    /**
     * Get active temporary closure for a restaurant (if any)
     */
    public TemporaryClosure getActiveClosure(Integer restaurantId) {
        String sql = "SELECT * FROM TemporaryClosures WHERE RestaurantID = ? AND IsActive = 1 " +
                     "AND GETDATE() BETWEEN StartDateTime AND EndDateTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting active closure: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Insert new temporary closure
     */
    public int insert(TemporaryClosure closure) {
        String sql = "INSERT INTO TemporaryClosures (RestaurantID, StartDateTime, EndDateTime, Reason, IsActive) " +
                     "VALUES (?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, closure.getRestaurantId());
            statement.setTimestamp(2, closure.getStartDateTime());
            statement.setTimestamp(3, closure.getEndDateTime());
            statement.setString(4, closure.getReason());
            statement.setBoolean(5, closure.getIsActive());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating temporary closure failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating temporary closure failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting temporary closure: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Update temporary closure
     */
    public boolean update(TemporaryClosure closure) {
        String sql = "UPDATE TemporaryClosures SET StartDateTime = ?, EndDateTime = ?, " +
                     "Reason = ?, IsActive = ? WHERE ClosureID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setTimestamp(1, closure.getStartDateTime());
            statement.setTimestamp(2, closure.getEndDateTime());
            statement.setString(3, closure.getReason());
            statement.setBoolean(4, closure.getIsActive());
            statement.setInt(5, closure.getClosureId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating temporary closure: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Toggle active status
     */
    public boolean toggleStatus(Integer closureId) {
        String sql = "UPDATE TemporaryClosures SET IsActive = ~IsActive WHERE ClosureID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, closureId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error toggling closure status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Find by ID
     */
    public TemporaryClosure findById(Integer closureId) {
        String sql = "SELECT * FROM TemporaryClosures WHERE ClosureID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, closureId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding closure by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}
