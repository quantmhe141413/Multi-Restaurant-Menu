package dal;

import models.EmployeeShift;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class EmployeeShiftDAO extends DBContext {

    /**
     * Map ResultSet to EmployeeShift object
     */
    public EmployeeShift getFromResultSet(ResultSet rs) throws SQLException {
        EmployeeShift shift = new EmployeeShift();
        shift.setShiftId(rs.getInt("ShiftID"));
        shift.setRestaurantId(rs.getInt("RestaurantID"));
        shift.setStaffId(rs.getInt("StaffID"));
        shift.setTemplateId(rs.getInt("TemplateID"));
        shift.setShiftDate(rs.getDate("ShiftDate"));
        shift.setCreatedAt(rs.getTimestamp("CreatedAt"));
        
        // Try to get staff name if available from JOIN
        try {
            String staffName = rs.getString("StaffName");
            shift.setStaffName(staffName);
        } catch (SQLException e) {
            // StaffName column not available
            shift.setStaffName(null);
        }

        // Try to get shift template details if available from JOIN
        try {
            shift.setShiftName(rs.getString("ShiftName"));
            shift.setStartTime(rs.getTime("StartTime"));
            shift.setEndTime(rs.getTime("EndTime"));
            shift.setPosition(rs.getString("Position"));
        } catch (SQLException e) {
            // Template details not available
        }

        // Try to get attendance fields (nullable)
        try {
            shift.setAttendanceStatus(rs.getString("AttendanceStatus"));
            shift.setCheckedInAt(rs.getTimestamp("CheckedInAt"));
            shift.setCheckedOutAt(rs.getTimestamp("CheckedOutAt"));
            shift.setMarkedBy(rs.getObject("MarkedBy") != null ? rs.getInt("MarkedBy") : null);
            shift.setMarkedAt(rs.getTimestamp("MarkedAt"));
            shift.setNote(rs.getString("Note"));
        } catch (SQLException e) {
            // Attendance columns not available in this query
        }

        // Try to get marker name from JOIN (optional)
        try {
            shift.setMarkedByName(rs.getString("MarkedByName"));
        } catch (SQLException e) {
            // Not joined
        }

        return shift;
    }

    /**
     * Get all shifts for a restaurant (with optional date filter)
     * If shiftDate is null, returns all shifts
     * If shiftDate is provided, returns shifts for that specific date
     */
    public List<EmployeeShift> findByRestaurantAndDate(Integer restaurantId, Date shiftDate) {
        List<EmployeeShift> shifts = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT es.*, u.FullName AS StaffName, ")
           .append("st.ShiftName, st.StartTime, st.EndTime, st.Position ")
           .append("FROM EmployeeShifts es ")
           .append("JOIN Users u ON es.StaffID = u.UserID ")
           .append("JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID ")
           .append("WHERE es.RestaurantID = ? ");
        
        // Only filter by date if shiftDate is provided
        if (shiftDate != null) {
            sql.append("AND es.ShiftDate = ? ");
        }
        
        sql.append("ORDER BY es.ShiftDate DESC, st.StartTime, u.FullName");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            statement.setInt(1, restaurantId);
            
            if (shiftDate != null) {
                statement.setDate(2, shiftDate);
            }
            
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shifts by restaurant and date: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }
    
    /**
     * Get all shifts for a restaurant (no date filter)
     */
    public List<EmployeeShift> findAllByRestaurant(Integer restaurantId) {
        return findByRestaurantAndDate(restaurantId, null);
    }

    /**
     * Get ALL shifts from all restaurants (for SuperAdmin)
     */
    public List<EmployeeShift> findAll() {
        List<EmployeeShift> shifts = new ArrayList<>();
        String sql = "SELECT es.*, u.FullName AS StaffName, " +
                     "st.ShiftName, st.StartTime, st.EndTime, st.Position " +
                     "FROM EmployeeShifts es " +
                     "JOIN Users u ON es.StaffID = u.UserID " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "ORDER BY es.ShiftDate DESC, es.RestaurantID, st.StartTime, u.FullName";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all shifts: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }

    /**
     * Get all shifts for a specific date from all restaurants (for SuperAdmin)
     */
    public List<EmployeeShift> findByDate(Date shiftDate) {
        List<EmployeeShift> shifts = new ArrayList<>();
        String sql = "SELECT es.*, u.FullName AS StaffName, " +
                     "st.ShiftName, st.StartTime, st.EndTime, st.Position " +
                     "FROM EmployeeShifts es " +
                     "JOIN Users u ON es.StaffID = u.UserID " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "WHERE es.ShiftDate = ? " +
                     "ORDER BY es.RestaurantID, st.StartTime, u.FullName";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setDate(1, shiftDate);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shifts by date: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }

    /**
     * Get all shifts for a restaurant in a date range
     */
    public List<EmployeeShift> findByRestaurantAndDateRange(Integer restaurantId, Date startDate, Date endDate) {
        List<EmployeeShift> shifts = new ArrayList<>();
        String sql = "SELECT es.*, u.FullName AS StaffName, " +
                     "st.ShiftName, st.StartTime, st.EndTime, st.Position " +
                     "FROM EmployeeShifts es " +
                     "JOIN Users u ON es.StaffID = u.UserID " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "WHERE es.RestaurantID = ? AND es.ShiftDate BETWEEN ? AND ? " +
                     "ORDER BY es.ShiftDate, st.StartTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            statement.setDate(2, startDate);
            statement.setDate(3, endDate);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shifts by date range: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }

    /**
     * Get shifts for a specific staff member
     */
    public List<EmployeeShift> findByStaffId(Integer staffId) {
        List<EmployeeShift> shifts = new ArrayList<>();
        String sql = "SELECT es.*, st.ShiftName, st.StartTime, st.EndTime, st.Position " +
                     "FROM EmployeeShifts es " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "WHERE es.StaffID = ? " +
                     "ORDER BY es.ShiftDate DESC, st.StartTime";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, staffId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shifts by staff: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }

    /**
     * Check if staff has overlapping shift on the same date
     * Now uses TemplateID to get shift times
     */
    public boolean hasOverlappingShift(Integer staffId, Date shiftDate, 
                                       Integer templateId, Integer excludeShiftId) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM EmployeeShifts es ")
           .append("JOIN ShiftTemplates st1 ON es.TemplateID = st1.TemplateID ")
           .append("JOIN ShiftTemplates st2 ON st2.TemplateID = ? ")
           .append("WHERE es.StaffID = ? AND es.ShiftDate = ? ")
           .append("AND ((st1.StartTime < st2.EndTime AND st1.EndTime > st2.StartTime) OR ")
           .append("(st1.StartTime < st2.EndTime AND st1.EndTime > st2.StartTime) OR ")
           .append("(st1.StartTime >= st2.StartTime AND st1.EndTime <= st2.EndTime))");
        
        if (excludeShiftId != null) {
            sql.append(" AND es.ShiftID != ?");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());
            statement.setInt(1, templateId);
            statement.setInt(2, staffId);
            statement.setDate(3, shiftDate);
            
            if (excludeShiftId != null) {
                statement.setInt(4, excludeShiftId);
            }

            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException ex) {
            System.out.println("Error checking overlapping shift: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return false;
    }

    /**
     * Insert new employee shift assignment
     * Now only needs RestaurantID, StaffID, ShiftDate, and TemplateID
     */
    public int insert(EmployeeShift shift) {
        String sql = "INSERT INTO EmployeeShifts (RestaurantID, StaffID, ShiftDate, TemplateID) " +
                     "VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, shift.getRestaurantId());
            statement.setInt(2, shift.getStaffId());
            statement.setDate(3, shift.getShiftDate());
            statement.setInt(4, shift.getTemplateId());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating shift assignment failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating shift assignment failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting shift assignment: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    /**
     * Update employee shift assignment
     * Now only updates StaffID, ShiftDate, and TemplateID
     */
    public boolean update(EmployeeShift shift) {
        String sql = "UPDATE EmployeeShifts SET StaffID = ?, ShiftDate = ?, " +
                     "TemplateID = ? WHERE ShiftID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, shift.getStaffId());
            statement.setDate(2, shift.getShiftDate());
            statement.setInt(3, shift.getTemplateId());
            statement.setInt(4, shift.getShiftId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating shift assignment: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Delete shift assignment
     */
    public boolean delete(Integer shiftId) {
        String sql = "DELETE FROM EmployeeShifts WHERE ShiftID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, shiftId);

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting shift assignment: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Find by ID
     */
    public EmployeeShift findById(Integer shiftId) {
        String sql = "SELECT es.*, u.FullName AS StaffName, " +
                     "st.ShiftName, st.StartTime, st.EndTime, st.Position " +
                     "FROM EmployeeShifts es " +
                     "JOIN Users u ON es.StaffID = u.UserID " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "WHERE es.ShiftID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, shiftId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding shift by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Get available staff for a restaurant (only staff members - RoleID = 3)
     * Excludes Admin (RoleID = 1), Owner (RoleID = 2), and Customer (RoleID = 4)
     */
    public List<models.User> getAvailableStaff(Integer restaurantId) {
        List<models.User> staffList = new ArrayList<>();
        String sql = "SELECT u.UserID, u.FullName, u.Email, u.Phone, u.RoleID " +
                     "FROM Users u " +
                     "JOIN RestaurantUsers ru ON u.UserID = ru.UserID " +
                     "WHERE ru.RestaurantID = ? AND ru.IsActive = 1 AND u.IsActive = 1 " +
                     "AND u.RoleID = 3 " +  // Only Staff (RoleID = 3)
                     "ORDER BY u.FullName";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, restaurantId);
            resultSet = statement.executeQuery();

            while (resultSet.next()) {
                models.User user = new models.User();
                user.setUserID(resultSet.getInt("UserID"));
                user.setFullName(resultSet.getString("FullName"));
                user.setEmail(resultSet.getString("Email"));
                user.setPhone(resultSet.getString("Phone"));
                user.setRoleID(resultSet.getInt("RoleID"));
                staffList.add(user);
            }
        } catch (SQLException ex) {
            System.out.println("Error getting available staff: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return staffList;
    }

    /**
     * Mark attendance for a shift (Owner action).
     * Updates AttendanceStatus, Note, MarkedBy, MarkedAt.
     */
    public boolean markAttendance(Integer shiftId, String status, String note, Integer markedBy) {
        String sql = "UPDATE EmployeeShifts SET AttendanceStatus = ?, Note = ?, " +
                     "MarkedBy = ?, MarkedAt = SYSUTCDATETIME() " +
                     "WHERE ShiftID = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setString(2, note);
            if (markedBy != null) {
                statement.setInt(3, markedBy);
            } else {
                statement.setNull(3, java.sql.Types.INTEGER);
            }
            statement.setInt(4, shiftId);
            return statement.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error marking attendance: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    /**
     * Get work history for a specific staff member with full attendance info.
     * Used by owner to view employee attendance history.
     */
    public List<EmployeeShift> findWorkHistoryByStaff(Integer staffId) {
        List<EmployeeShift> shifts = new ArrayList<>();
        String sql = "SELECT es.*, u.FullName AS StaffName, " +
                     "st.ShiftName, st.StartTime, st.EndTime, st.Position, " +
                     "m.FullName AS MarkedByName " +
                     "FROM EmployeeShifts es " +
                     "JOIN Users u ON es.StaffID = u.UserID " +
                     "JOIN ShiftTemplates st ON es.TemplateID = st.TemplateID " +
                     "LEFT JOIN Users m ON es.MarkedBy = m.UserID " +
                     "WHERE es.StaffID = ? " +
                     "ORDER BY es.ShiftDate DESC, st.StartTime";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, staffId);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                shifts.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error getting work history: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return shifts;
    }
}
