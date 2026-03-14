package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Discount;

public class DiscountDAO extends DBContext {

    /**
     * Looks up an active, non-expired discount by code.
     * A discount with RestaurantID = NULL is platform-wide (valid for any restaurant).
     * A discount with a specific RestaurantID is only valid for that restaurant.
     *
     * @param code         the discount code entered by the customer
     * @param restaurantId the restaurant id of the current order
     * @return the matching Discount, or null if not found / invalid
     */
    public Discount findValidDiscount(String code, int restaurantId) {
        String sql = "SELECT * FROM Discounts "
                + "WHERE Code = ? AND IsActive = 1 "
                + "AND (ExpiryDate IS NULL OR ExpiryDate >= GETDATE()) "
                + "AND (RestaurantID IS NULL OR RestaurantID = ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, code.trim().toUpperCase());
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapDiscount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DiscountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    public Discount findDiscountById(int discountId) {
        String sql = "SELECT * FROM Discounts WHERE DiscountID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discountId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapDiscount(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DiscountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Returns all active, non-expired discounts that are applicable
     * for a given restaurant (platform-wide or restaurant-specific).
     */
    public List<Discount> getAvailableDiscountsForRestaurant(int restaurantId) {
        List<Discount> list = new ArrayList<>();
        String sql = "SELECT * FROM Discounts "
                + "WHERE IsActive = 1 "
                + "AND (ExpiryDate IS NULL OR ExpiryDate >= GETDATE()) "
                + "AND (RestaurantID IS NULL OR RestaurantID = ?) "
                + "ORDER BY CASE WHEN RestaurantID IS NULL THEN 0 ELSE 1 END, CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapDiscount(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(DiscountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Count how many times a given user has successfully used a given discount.
     */
    public int countUserUsage(int discountId, int customerId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE DiscountID = ? AND CustomerID = ? AND OrderStatus != 'Cancelled'";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discountId);
            st.setInt(2, customerId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(DiscountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Decrease the available quantity of a discount by 1.
     */
    public boolean decreaseQuantity(int discountId) {
        String sql = "UPDATE Discounts SET Quantity = Quantity - 1 WHERE DiscountID = ? AND Quantity > 0";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, discountId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(DiscountDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return false;
    }

    private Discount mapDiscount(ResultSet rs) throws SQLException {
        Discount d = new Discount();
        d.setDiscountID(rs.getInt("DiscountID"));
        int restaurantID = rs.getInt("RestaurantID");
        if (!rs.wasNull()) {
            d.setRestaurantID(restaurantID);
        }
        d.setCode(rs.getString("Code"));
        d.setDiscountType(rs.getString("DiscountType"));
        d.setDiscountValue(rs.getDouble("DiscountValue"));
        d.setQuantity(rs.getInt("Quantity"));
        d.setMinOrderAmount(rs.getDouble("MinOrderAmount"));
        double maxDiscount = rs.getDouble("MaxDiscountAmount");
        if (!rs.wasNull()) {
            d.setMaxDiscountAmount(maxDiscount);
        }
        d.setUsageLimitPerUser(rs.getInt("UsageLimitPerUser"));
        d.setIsActive(rs.getBoolean("IsActive"));
        d.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return d;
    }
}

