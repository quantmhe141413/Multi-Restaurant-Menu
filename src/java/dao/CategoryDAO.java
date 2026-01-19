package dao;

import dal.DBContext;
import models.Category;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {
    
    public List<Category> getAllCategories() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM Categories ORDER BY category_name";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                categories.add(mapResultSetToCategory(rs));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all categories: " + e.getMessage());
        }
        return categories;
    }
    
    public Category getCategoryById(int categoryId) {
        String sql = "SELECT * FROM Categories WHERE category_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCategory(rs);
                }
            }
        } catch (SQLException e) {
            System.out.println("Error getting category by ID: " + e.getMessage());
        }
        return null;
    }
    
    public boolean createCategory(Category category) {
        String sql = "INSERT INTO Categories (category_name, description) VALUES (?, ?)";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error creating category: " + e.getMessage());
            return false;
        }
    }
    
    public boolean updateCategory(Category category) {
        String sql = "UPDATE Categories SET category_name = ?, description = ? WHERE category_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating category: " + e.getMessage());
            return false;
        }
    }
    
    public boolean deleteCategory(int categoryId) {
        String sql = "DELETE FROM Categories WHERE category_id = ?";
        
        try (Connection conn = DBContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, categoryId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting category: " + e.getMessage());
            return false;
        }
    }
    
    private Category mapResultSetToCategory(ResultSet rs) throws SQLException {
        Category category = new Category();
        category.setCategoryId(rs.getInt("category_id"));
        category.setCategoryName(rs.getString("category_name"));
        category.setDescription(rs.getString("description"));
        return category;
    }
}
