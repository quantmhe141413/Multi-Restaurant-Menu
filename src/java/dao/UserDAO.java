package dao;

import dal.DBContext;
import models.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {
    
    public User validateLogin(String username, String password) {
        String sql = "SELECT * FROM Users WHERE username = ? AND password = ? AND status = 1";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            ps.setString(2, password);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error validating login: " + e.getMessage());
        }
        return null;
    }
    
    public User getUserById(int userId) {
        String sql = "SELECT * FROM Users WHERE user_id = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by ID: " + e.getMessage());
        }
        return null;
    }
    
    public User getUserByUsername(String username) {
        String sql = "SELECT * FROM Users WHERE username = ?";
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, username);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting user by username: " + e.getMessage());
        }
        return null;
    }
    
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users ORDER BY user_id";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all users: " + e.getMessage());
        }
        return users;
    }
    
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users WHERE role = ? ORDER BY full_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, role);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    users.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting users by role: " + e.getMessage());
        }
        return users;
    }
    
    public boolean createUser(User user) {
        String sql = "INSERT INTO Users (username, password, role, full_name, email, phone, status) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getPhone());
            ps.setBoolean(7, user.isStatus());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating user: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateUser(User user) {
        String sql = "UPDATE Users SET username = ?, password = ?, role = ?, full_name = ?, " +
                     "email = ?, phone = ?, status = ? WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getFullName());
            ps.setString(5, user.getEmail());
            ps.setString(6, user.getPhone());
            ps.setBoolean(7, user.isStatus());
            ps.setInt(8, user.getUserId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating user: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM Users WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting user: " + e.getMessage());
            return false;
        }
    }
    
    public boolean toggleUserStatus(int userId) {
        String sql = "UPDATE Users SET status = CASE WHEN status = 1 THEN 0 ELSE 1 END WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error toggling user status: " + e.getMessage());
            return false;
        }
    }
    
    public boolean changeStatus(int userId, boolean status) {
        String sql = "UPDATE Users SET status = ? WHERE user_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setBoolean(1, status);
            ps.setInt(2, userId);
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error changing user status: " + e.getMessage());
            return false;
        }
    }
    
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setPassword(rs.getString("password"));
        user.setRole(rs.getString("role"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPhone(rs.getString("phone"));
        user.setStatus(rs.getBoolean("status"));
        user.setCreatedDate(rs.getTimestamp("created_date"));
        return user;
    }
}
