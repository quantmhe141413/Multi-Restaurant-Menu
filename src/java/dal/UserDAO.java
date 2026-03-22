package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.User;

public class UserDAO extends DBContext {

    public User login(String email, String password) {
        String sql = "SELECT * FROM Users WHERE Email = ? AND PasswordHash = ? AND IsActive = 1";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            st.setString(2, password);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setUserID(rs.getInt("UserID"));
                u.setFullName(rs.getString("FullName"));
                u.setEmail(rs.getString("Email"));
                u.setRoleID(rs.getInt("RoleID"));
                u.setIsActive(rs.getBoolean("IsActive"));
                u.setPhone(rs.getString("Phone"));
                u.setPasswordHash(rs.getString("PasswordHash"));
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Get all RestaurantIDs assigned to a user (Owner/Staff can belong to multiple restaurants).
     * Returns empty list for SuperAdmin (RoleID = 1) or Customer (RoleID = 4).
     */
    public List<Integer> getRestaurantIdsByUserId(int userId) {
        List<Integer> ids = new ArrayList<>();
        String sql = "SELECT RestaurantID FROM RestaurantUsers WHERE UserID = ? AND IsActive = 1 ORDER BY RestaurantID";
        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                ids.add(rs.getInt("RestaurantID"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return ids;
    }

    /**
     * Get primary RestaurantID for a user - prefers 'Owner' role, falls back to first assigned.
     * Returns null if user has no restaurant assignment.
     */
    public Integer getRestaurantIdByUserId(int userId) {
        String sql = "SELECT RestaurantID FROM Restaurants WHERE OwnerID = ? " +
                     "UNION " +
                     "SELECT RestaurantID FROM RestaurantUsers WHERE UserID = ? AND IsActive = 1";
        try {
            connection = getConnection();
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, userId);
            st.setInt(2, userId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("RestaurantID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeResources();
        }
        return null;
    }

    public int register(User user) {
        String sql = "INSERT INTO [dbo].[Users] ([FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, 1, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql, java.sql.Statement.RETURN_GENERATED_KEYS);
            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPasswordHash());
            st.setString(4, user.getPhone());
            st.setInt(5, user.getRoleID());
            int affectedRows = st.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = st.getGeneratedKeys();
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public boolean checkEmailExists(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, email);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return true;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Save reset token for password recovery
    public boolean saveResetToken(String email, String token) {
        String sql = "UPDATE Users SET ResetToken = ?, ResetTokenExpiry = DATEADD(HOUR, 1, GETDATE()) WHERE Email = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            st.setString(2, email);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Check if reset token is valid and not expired
    public boolean isResetTokenValid(String token) {
        String sql = "SELECT * FROM Users WHERE ResetToken = ? AND ResetTokenExpiry > GETDATE()";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, token);
            ResultSet rs = st.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Reset password using token
    public boolean resetPassword(String token, String newPassword) {
        String sql = "UPDATE Users SET PasswordHash = ?, ResetToken = NULL, ResetTokenExpiry = NULL " +
                "WHERE ResetToken = ? AND ResetTokenExpiry > GETDATE()";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPassword);
            st.setString(2, token);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // Update password for a user by userId (used for change-password flow)
    public boolean updatePassword(int userId, String newPasswordHash) {
        String sql = "UPDATE Users SET PasswordHash = ? WHERE UserID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newPasswordHash);
            st.setInt(2, userId);
            int rowsAffected = st.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public static void main(String[] args) {
        UserDAO dao = new UserDAO();
        if (dao.connection != null) {
            System.out.println("Connection successful!");
            System.out.println("Testing checkEmailExists()...");
            boolean exists = dao.checkEmailExists("test@example.com");
            System.out.println("Email 'test@example.com' exists: " + exists);
        } else {
            System.out.println("Connection failed!");
        }
    }
}
