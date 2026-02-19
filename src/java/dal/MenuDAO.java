package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.MenuCategory;
import models.MenuItem;
import models.Restaurant;

public class MenuDAO extends DBContext {

    public Restaurant getRestaurantById(int restaurantId) {
        String sql = "SELECT * FROM Restaurants WHERE RestaurantID = ? AND Status = 'Approved'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapRestaurant(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public List<MenuCategory> getCategoriesByRestaurant(int restaurantId) {
        List<MenuCategory> list = new ArrayList<>();
        String sql = "SELECT * FROM MenuCategories WHERE RestaurantID = ? AND (IsActive IS NULL OR IsActive = 1) ORDER BY CategoryName";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT * FROM MenuItems WHERE RestaurantID = ? AND IsAvailable = 1 ORDER BY CategoryID, ItemName";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapMenuItem(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<MenuItem> getMenuItemsByCategory(int categoryId) {
        List<MenuItem> list = new ArrayList<>();
        String sql = "SELECT * FROM MenuItems WHERE CategoryID = ? AND IsAvailable = 1 ORDER BY ItemName";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapMenuItem(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public MenuItem getMenuItemById(int itemId) {
        String sql = "SELECT * FROM MenuItems WHERE ItemID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, itemId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapMenuItem(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    private Restaurant mapRestaurant(ResultSet rs) throws SQLException {
        Restaurant r = new Restaurant();
        r.setRestaurantId(rs.getInt("RestaurantID"));
        r.setOwnerId(rs.getInt("OwnerID"));
        r.setName(rs.getString("Name"));
        r.setAddress(rs.getString("Address"));
        r.setLicenseNumber(rs.getString("LicenseNumber"));
        r.setLogoUrl(rs.getString("LogoUrl"));
        r.setThemeColor(rs.getString("ThemeColor"));
        r.setIsOpen(rs.getBoolean("IsOpen"));
        r.setDeliveryFee(rs.getDouble("DeliveryFee"));
        r.setCommissionRate(rs.getDouble("CommissionRate"));
        r.setStatus(rs.getString("Status"));
        r.setCreatedAt(rs.getDate("CreatedAt"));
        return r;
    }

    private MenuCategory mapCategory(ResultSet rs) throws SQLException {
        MenuCategory c = new MenuCategory();
        c.setCategoryID(rs.getInt("CategoryID"));
        c.setRestaurantID(rs.getInt("RestaurantID"));
        c.setCategoryName(rs.getString("CategoryName"));
        // Cột Description và CreatedAt không có trong database
        return c;
    }

    private MenuItem mapMenuItem(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setItemID(rs.getInt("ItemID"));
        item.setRestaurantID(rs.getInt("RestaurantID"));
        item.setCategoryID(rs.getInt("CategoryID"));
        item.setItemName(rs.getString("ItemName"));
        item.setDescription(rs.getString("Description"));
        item.setPrice(rs.getDouble("Price"));
        // Cột ImageUrl không có trong database
        item.setIsAvailable(rs.getBoolean("IsAvailable"));
        item.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return item;
    }

    public static void main(String[] args) {
        MenuDAO dao = new MenuDAO();
        if (dao.connection != null) {
            System.out.println("Connection successful!");
            System.out.println("\nTesting getMenuItemsByRestaurant(1)...");
            List<MenuItem> items = dao.getMenuItemsByRestaurant(1);
            System.out.println("Found " + items.size() + " menu items.");
            for (MenuItem item : items) {
                System.out.println("- " + item.getItemName() + " - " + item.getPrice() + " VND");
            }
        } else {
            System.out.println("Connection failed!");
        }
    }

    // --- Category Management Methods ---

    public MenuCategory getCategoryById(int categoryId) {
        String sql = "SELECT * FROM MenuCategories WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapCategory(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public boolean insertCategory(MenuCategory category) {
        String sql = "INSERT INTO MenuCategories (RestaurantID, CategoryName, Description) VALUES (?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, category.getRestaurantID());
            st.setString(2, category.getCategoryName());
            st.setString(3, category.getDescription());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateCategory(MenuCategory category) {
        String sql = "UPDATE MenuCategories SET CategoryName = ?, Description = ? WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, category.getCategoryName());
            st.setString(2, category.getDescription());
            st.setInt(3, category.getCategoryID());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteCategory(int categoryId) {
        // Note: You might want to check for dependencies (MenuItems) before deleting
        // or set up CASCADE DELETE in the database.
        String sql = "DELETE FROM MenuCategories WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, categoryId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    // --- MenuItem Management Methods ---

    public boolean insertMenuItem(MenuItem item) {
        String sql = "INSERT INTO MenuItems (RestaurantID, CategoryID, ItemName, Description, Price, IsAvailable) VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, item.getRestaurantID());
            st.setInt(2, item.getCategoryID());
            st.setString(3, item.getItemName());
            st.setString(4, item.getDescription());
            st.setDouble(5, item.getPrice());
            st.setBoolean(6, item.isIsAvailable());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateMenuItem(MenuItem item) {
        String sql = "UPDATE MenuItems SET CategoryID = ?, ItemName = ?, Description = ?, Price = ?, IsAvailable = ? WHERE ItemID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, item.getCategoryID());
            st.setString(2, item.getItemName());
            st.setString(3, item.getDescription());
            st.setDouble(4, item.getPrice());
            st.setBoolean(5, item.isIsAvailable());
            st.setInt(6, item.getItemID());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean deleteMenuItem(int itemId) {
        String sql = "DELETE FROM MenuItems WHERE ItemID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, itemId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }
}
