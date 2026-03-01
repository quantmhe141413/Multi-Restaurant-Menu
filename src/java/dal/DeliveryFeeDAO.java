package dal;

import models.DeliveryFee;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DeliveryFeeDAO extends DBContext {

    public DeliveryFee getFromResultSet(ResultSet rs) throws SQLException {
        DeliveryFee fee = new DeliveryFee();
        fee.setFeeId(rs.getInt("FeeID"));
        fee.setZoneId(rs.getInt("ZoneID"));
        fee.setFeeType(rs.getString("FeeType"));
        fee.setFeeValue(rs.getBigDecimal("FeeValue"));
        fee.setMinOrderAmount(rs.getBigDecimal("MinOrderAmount"));
        fee.setMaxOrderAmount(rs.getBigDecimal("MaxOrderAmount"));
        fee.setIsActive(rs.getBoolean("IsActive"));
        fee.setCreatedAt(rs.getDate("CreatedAt"));
        return fee;
    }

    public List<DeliveryFee> findFeesWithFilters(Integer restaurantId, String feeType, 
                                                  Integer zoneId, int page, int pageSize) {
        List<DeliveryFee> fees = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT df.* FROM DeliveryFees df ");
        sql.append("INNER JOIN RestaurantDeliveryZones rdz ON df.ZoneID = rdz.ZoneID ");
        sql.append("WHERE 1=1 ");

        // Only filter by restaurant if restaurantId is provided
        if (restaurantId != null) {
            sql.append("AND rdz.RestaurantID = ? ");
        }

        if (feeType != null && !feeType.isEmpty()) {
            sql.append("AND df.FeeType = ? ");
        }

        if (zoneId != null && zoneId > 0) {
            sql.append("AND df.ZoneID = ? ");
        }

        sql.append("ORDER BY df.CreatedAt DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Only set restaurant parameter if provided
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (feeType != null && !feeType.isEmpty()) {
                statement.setString(paramIndex++, feeType);
            }
            
            if (zoneId != null && zoneId > 0) {
                statement.setInt(paramIndex++, zoneId);
            }
            
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex++, pageSize);

            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                fees.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding fees: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return fees;
    }

    public int getTotalFilteredFees(Integer restaurantId, String feeType, Integer zoneId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM DeliveryFees df ");
        sql.append("INNER JOIN RestaurantDeliveryZones rdz ON df.ZoneID = rdz.ZoneID ");
        sql.append("WHERE 1=1 ");

        // Only filter by restaurant if restaurantId is provided
        if (restaurantId != null) {
            sql.append("AND rdz.RestaurantID = ? ");
        }

        if (feeType != null && !feeType.isEmpty()) {
            sql.append("AND df.FeeType = ? ");
        }

        if (zoneId != null && zoneId > 0) {
            sql.append("AND df.ZoneID = ? ");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            
            // Only set restaurant parameter if provided
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (feeType != null && !feeType.isEmpty()) {
                statement.setString(paramIndex++, feeType);
            }
            
            if (zoneId != null && zoneId > 0) {
                statement.setInt(paramIndex++, zoneId);
            }

            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting fees: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public int insert(DeliveryFee fee) {
        String sql = "INSERT INTO DeliveryFees (ZoneID, FeeType, FeeValue, MinOrderAmount, " +
                     "MaxOrderAmount, IsActive) VALUES (?, ?, ?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, fee.getZoneId());
            statement.setString(2, fee.getFeeType());
            statement.setBigDecimal(3, fee.getFeeValue());
            
            if (fee.getMinOrderAmount() != null) {
                statement.setBigDecimal(4, fee.getMinOrderAmount());
            } else {
                statement.setNull(4, java.sql.Types.DECIMAL);
            }
            
            if (fee.getMaxOrderAmount() != null) {
                statement.setBigDecimal(5, fee.getMaxOrderAmount());
            } else {
                statement.setNull(5, java.sql.Types.DECIMAL);
            }
            
            statement.setBoolean(6, fee.getIsActive());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating delivery fee failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating delivery fee failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting delivery fee: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    public boolean update(DeliveryFee fee) {
        String sql = "UPDATE DeliveryFees SET ZoneID = ?, FeeType = ?, FeeValue = ?, " +
                     "MinOrderAmount = ?, MaxOrderAmount = ?, IsActive = ? WHERE FeeID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, fee.getZoneId());
            statement.setString(2, fee.getFeeType());
            statement.setBigDecimal(3, fee.getFeeValue());
            
            if (fee.getMinOrderAmount() != null) {
                statement.setBigDecimal(4, fee.getMinOrderAmount());
            } else {
                statement.setNull(4, java.sql.Types.DECIMAL);
            }
            
            if (fee.getMaxOrderAmount() != null) {
                statement.setBigDecimal(5, fee.getMaxOrderAmount());
            } else {
                statement.setNull(5, java.sql.Types.DECIMAL);
            }
            
            statement.setBoolean(6, fee.getIsActive());
            statement.setInt(7, fee.getFeeId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating delivery fee: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public DeliveryFee findById(Integer feeId) {
        String sql = "SELECT * FROM DeliveryFees WHERE FeeID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, feeId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding delivery fee by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public boolean delete(Integer feeId) {
        // Check if fee is applied to any ongoing orders
        String checkSql = "SELECT COUNT(*) FROM Orders o " +
                         "INNER JOIN DeliveryInfo di ON o.OrderID = di.OrderID " +
                         "WHERE o.OrderStatus IN ('Preparing', 'Delivering') " +
                         "AND EXISTS (SELECT 1 FROM DeliveryFees WHERE FeeID = ?)";
        
        String deleteSql = "DELETE FROM DeliveryFees WHERE FeeID = ?";

        try {
            connection = getConnection();
            
            // Check for ongoing orders
            statement = connection.prepareStatement(checkSql);
            statement.setInt(1, feeId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next() && resultSet.getInt(1) > 0) {
                System.out.println("Cannot delete fee: applied to ongoing orders");
                return false;
            }
            
            // Proceed with deletion
            statement = connection.prepareStatement(deleteSql);
            statement.setInt(1, feeId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting delivery fee: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public boolean toggleStatus(Integer feeId) {
        String sql = "UPDATE DeliveryFees SET IsActive = ~IsActive WHERE FeeID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, feeId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error toggling fee status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Check if a similar delivery fee already exists for the zone
     * Prevents duplicate fees with same type and overlapping conditions
     * @param zoneId Zone ID
     * @param feeType Fee type (Flat, PercentageOfOrder, FreeAboveAmount)
     * @param minOrderAmount Minimum order amount (can be null)
     * @param maxOrderAmount Maximum order amount (can be null)
     * @param excludeFeeId Fee ID to exclude (for edit scenario), can be null
     * @return true if conflict exists, false otherwise
     */
    public boolean hasFeeConflict(Integer zoneId, String feeType, 
                                   java.math.BigDecimal minOrderAmount, 
                                   java.math.BigDecimal maxOrderAmount, 
                                   Integer excludeFeeId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM DeliveryFees ");
        sql.append("WHERE ZoneID = ? AND FeeType = ? AND IsActive = 1 ");
        
        // Check for overlapping or conflicting conditions
        // Case 1: Both new and existing have no min/max (direct conflict)
        // Case 2: Ranges overlap
        if (minOrderAmount == null && maxOrderAmount == null) {
            // New fee has no range - check if any active fee exists with same type
            sql.append("AND (MinOrderAmount IS NULL AND MaxOrderAmount IS NULL)");
        } else {
            // New fee has range - check for overlaps
            sql.append("AND (");
            sql.append("  (MinOrderAmount IS NULL AND MaxOrderAmount IS NULL) "); // Existing has no range
            sql.append("  OR ("); // Or ranges overlap
            
            if (minOrderAmount != null && maxOrderAmount != null) {
                // Both min and max specified
                sql.append("    (MinOrderAmount <= ? AND (MaxOrderAmount >= ? OR MaxOrderAmount IS NULL))");
                sql.append("    OR (MaxOrderAmount >= ? AND (MinOrderAmount <= ? OR MinOrderAmount IS NULL))");
            } else if (minOrderAmount != null) {
                // Only min specified
                sql.append("    (MaxOrderAmount >= ? OR MaxOrderAmount IS NULL)");
            } else {
                // Only max specified
                sql.append("    (MinOrderAmount <= ? OR MinOrderAmount IS NULL)");
            }
            sql.append("  )");
            sql.append(")");
        }
        
        if (excludeFeeId != null) {
            sql.append(" AND FeeID != ?");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            statement.setInt(paramIndex++, zoneId);
            statement.setString(paramIndex++, feeType);
            
            // Set parameters for range checks
            if (minOrderAmount != null || maxOrderAmount != null) {
                if (minOrderAmount != null && maxOrderAmount != null) {
                    statement.setBigDecimal(paramIndex++, maxOrderAmount);
                    statement.setBigDecimal(paramIndex++, minOrderAmount);
                    statement.setBigDecimal(paramIndex++, minOrderAmount);
                    statement.setBigDecimal(paramIndex++, maxOrderAmount);
                } else if (minOrderAmount != null) {
                    statement.setBigDecimal(paramIndex++, minOrderAmount);
                } else {
                    statement.setBigDecimal(paramIndex++, maxOrderAmount);
                }
            }
            
            if (excludeFeeId != null) {
                statement.setInt(paramIndex++, excludeFeeId);
            }

            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking fee conflict: " + ex.getMessage());
            ex.printStackTrace();
        } finally {
            closeResources();
        }
        return false;
    }
}
