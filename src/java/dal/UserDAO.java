package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
                u.setCreatedAt(rs.getTimestamp("CreatedAt"));
                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean register(User user) {
        String sql = "INSERT INTO [dbo].[Users] ([FullName], [Email], [PasswordHash], [Phone], [RoleID], [IsActive], [CreatedAt]) "
                + "VALUES (?, ?, ?, ?, ?, 1, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, user.getFullName());
            st.setString(2, user.getEmail());
            st.setString(3, user.getPasswordHash());
            st.setString(4, user.getPhone());
            st.setInt(5, user.getRoleID());
            st.executeUpdate();
            return true;
        } catch (SQLException ex) {
            Logger.getLogger(UserDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
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
