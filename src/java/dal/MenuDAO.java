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

    public List<MenuCategory> getCategoriesByRestaurant(int restaurantId, String search, Boolean isActive,
            String sortBy, String sortOrder) {
        List<MenuCategory> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM MenuCategories WHERE RestaurantID = ?");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND CategoryName LIKE ?");
        }
        if (isActive != null) {
            sql.append(" AND IsActive = ?");
        }

        // Sorting
        String validSortBy = "DisplayOrder";
        if ("name".equals(sortBy))
            validSortBy = "CategoryName";
        else if ("status".equals(sortBy))
            validSortBy = "IsActive";

        String validSortOrder = "ASC";
        if ("DESC".equalsIgnoreCase(sortOrder))
            validSortOrder = "DESC";

        sql.append(" ORDER BY ").append(validSortBy).append(" ").append(validSortOrder);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            st.setInt(paramIndex++, restaurantId);

            if (search != null && !search.trim().isEmpty()) {
                st.setString(paramIndex++, "%" + search.trim() + "%");
            }
            if (isActive != null) {
                st.setBoolean(paramIndex++, isActive);
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapCategory(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<MenuCategory> getCategoriesByRestaurant(int restaurantId, String search) {
        return getCategoriesByRestaurant(restaurantId, search, null, "DisplayOrder", "ASC");
    }

    public List<MenuCategory> getCategoriesByRestaurant(int restaurantId) {
        return getCategoriesByRestaurant(restaurantId, null, null, "DisplayOrder", "ASC");
    }

    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId, String search, Integer categoryId,
            Boolean isAvailable, Double minPrice, Double maxPrice, String sortBy, String sortOrder) {
        List<MenuItem> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM MenuItems WHERE RestaurantID = ?");

        if (search != null && !search.trim().isEmpty()) {
            sql.append(" AND (ItemName LIKE ? OR SKU LIKE ?)");
        }
        if (categoryId != null && categoryId > 0) {
            sql.append(" AND CategoryID = ?");
        }
        if (isAvailable != null) {
            sql.append(" AND IsAvailable = ?");
        }
        if (minPrice != null) {
            sql.append(" AND Price >= ?");
        }
        if (maxPrice != null) {
            sql.append(" AND Price <= ?");
        }

        // Sorting
        String validSortBy = "ItemName";
        if ("price".equals(sortBy))
            validSortBy = "Price";
        else if ("date".equals(sortBy))
            validSortBy = "CreatedAt";
        else if ("sku".equals(sortBy))
            validSortBy = "SKU";

        String validSortOrder = "ASC";
        if ("DESC".equalsIgnoreCase(sortOrder))
            validSortOrder = "DESC";

        sql.append(" ORDER BY ").append(validSortBy).append(" ").append(validSortOrder);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int paramIndex = 1;
            st.setInt(paramIndex++, restaurantId);

            if (search != null && !search.trim().isEmpty()) {
                String searchPattern = "%" + search.trim() + "%";
                st.setString(paramIndex++, searchPattern);
                st.setString(paramIndex++, searchPattern);
            }
            if (categoryId != null && categoryId > 0) {
                st.setInt(paramIndex++, categoryId);
            }
            if (isAvailable != null) {
                st.setBoolean(paramIndex++, isAvailable);
            }
            if (minPrice != null) {
                st.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                st.setDouble(paramIndex++, maxPrice);
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapMenuItem(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId, String search, Integer categoryId) {
        return getMenuItemsByRestaurant(restaurantId, search, categoryId, null, null, null, "ItemName", "ASC");
    }

    public List<MenuItem> getMenuItemsByRestaurant(int restaurantId) {
        return getMenuItemsByRestaurant(restaurantId, null, null, null, null, null, "ItemName", "ASC");
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
        c.setDisplayOrder((Integer) rs.getObject("DisplayOrder"));
        c.setIsActive(rs.getBoolean("IsActive"));
        return c;
    }

    private MenuItem mapMenuItem(ResultSet rs) throws SQLException {
        MenuItem item = new MenuItem();
        item.setItemID(rs.getInt("ItemID"));
        item.setRestaurantID(rs.getInt("RestaurantID"));
        item.setCategoryID(rs.getInt("CategoryID"));
        item.setSku(rs.getString("SKU"));
        item.setItemName(rs.getString("ItemName"));
        item.setDescription(rs.getString("Description"));
        item.setPrice(rs.getDouble("Price"));
        item.setIsAvailable(rs.getBoolean("IsAvailable"));
        item.setAverageRating((Double) rs.getObject("AverageRating"));
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
        String sql = "INSERT INTO MenuCategories (RestaurantID, CategoryName, DisplayOrder, IsActive) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, category.getRestaurantID());
            st.setString(2, category.getCategoryName());
            if (category.getDisplayOrder() != null) {
                st.setInt(3, category.getDisplayOrder());
            } else {
                st.setNull(3, java.sql.Types.INTEGER);
            }
            st.setBoolean(4, category.isIsActive());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateCategory(MenuCategory category) {
        String sql = "UPDATE MenuCategories SET CategoryName = ?, DisplayOrder = ?, IsActive = ? WHERE CategoryID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, category.getCategoryName());
            if (category.getDisplayOrder() != null) {
                st.setInt(2, category.getDisplayOrder());
            } else {
                st.setNull(2, java.sql.Types.INTEGER);
            }
            st.setBoolean(3, category.isIsActive());
            st.setInt(4, category.getCategoryID());
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
        String sql = "INSERT INTO MenuItems (RestaurantID, CategoryID, SKU, ItemName, Description, Price, IsAvailable) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, item.getRestaurantID());
            st.setInt(2, item.getCategoryID());
            st.setString(3, item.getSku());
            st.setString(4, item.getItemName());
            st.setString(5, item.getDescription());
            st.setDouble(6, item.getPrice());
            st.setBoolean(7, item.isIsAvailable());
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(MenuDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    public boolean updateMenuItem(MenuItem item) {
        String sql = "UPDATE MenuItems SET CategoryID = ?, SKU = ?, ItemName = ?, Description = ?, Price = ?, IsAvailable = ? WHERE ItemID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, item.getCategoryID());
            st.setString(2, item.getSku());
            st.setString(3, item.getItemName());
            st.setString(4, item.getDescription());
            st.setDouble(5, item.getPrice());
            st.setBoolean(6, item.isIsAvailable());
            st.setInt(7, item.getItemID());
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
