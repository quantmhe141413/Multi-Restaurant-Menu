package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Review;

public class ReviewDAO extends DBContext {

    /**
     * Insert a new review with OrderID.
     */
    public boolean insertReview(int restaurantId, int customerId, int orderId, int rating, String comment) {
        String sql = "INSERT INTO Reviews (RestaurantID, CustomerID, OrderID, Rating, Comment, CreatedAt) VALUES (?, ?, ?, ?, ?, GETDATE())";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            st.setInt(2, customerId);
            st.setInt(3, orderId);
            st.setInt(4, rating);
            if (comment != null && !comment.trim().isEmpty()) {
                st.setString(5, comment.trim());
            } else {
                st.setNull(5, java.sql.Types.NVARCHAR);
            }
            int result = st.executeUpdate();
            System.out.println("Insert review with OrderID - rows affected: " + result);
            return result > 0;
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, "Error inserting review", ex);
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Check if a specific order has been reviewed.
     */
    public boolean hasOrderBeenReviewed(int orderId) {
        String sql = "SELECT COUNT(*) AS cnt FROM Reviews WHERE OrderID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("cnt") > 0;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, "Error checking if order has been reviewed", ex);
            ex.printStackTrace();
        }
        return false;
    }

    /**
     * Get all reviews for a restaurant, joined with User to get customer name.
     * Sorted by newest first.
     */
    public List<Review> getReviewsByRestaurantId(int restaurantId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT * FROM Reviews WHERE RestaurantID = ? ORDER BY CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Review review = new Review();
                review.setReviewID(rs.getInt("ReviewID"));
                review.setRestaurantID(rs.getInt("RestaurantID"));
                review.setCustomerID(rs.getInt("CustomerID"));
                review.setRating(rs.getInt("Rating"));
                review.setComment(rs.getString("Comment"));
                review.setCreatedAt(rs.getTimestamp("CreatedAt"));
                reviews.add(review);
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return reviews;
    }

    /**
     * Get customer names for a list of reviews.
     * Returns Map of customerId -> customerName.
     */
    public Map<Integer, String> getCustomerNamesForReviews(List<Review> reviews) {
        Map<Integer, String> customerNames = new HashMap<>();
        if (reviews == null || reviews.isEmpty()) {
            return customerNames;
        }

        // Collect unique customer IDs
        StringBuilder ids = new StringBuilder();
        for (Review r : reviews) {
            if (ids.length() > 0)
                ids.append(",");
            ids.append(r.getCustomerID());
        }

        String sql = "SELECT UserID, FullName FROM Users WHERE UserID IN (" + ids.toString() + ")";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                customerNames.put(rs.getInt("UserID"), rs.getString("FullName"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return customerNames;
    }

    /**
     * Get average rating for a single restaurant.
     * Returns null if no reviews.
     */
    public Double getAverageRating(int restaurantId) {
        String sql = "SELECT AVG(CAST(Rating AS FLOAT)) AS AvgRating FROM Reviews WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                double avg = rs.getDouble("AvgRating");
                if (rs.wasNull())
                    return null;
                return avg;
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Get review count for a single restaurant.
     */
    public int getReviewCount(int restaurantId) {
        String sql = "SELECT COUNT(*) AS ReviewCount FROM Reviews WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("ReviewCount");
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Get average ratings and review counts for all restaurants in one query.
     * Returns a Map of restaurantId -> double[]{avgRating, reviewCount}
     */
    public Map<Integer, double[]> getRatingSummaryForAllRestaurants() {
        Map<Integer, double[]> map = new HashMap<>();
        String sql = "SELECT RestaurantID, AVG(CAST(Rating AS FLOAT)) AS AvgRating, COUNT(*) AS ReviewCount "
                + "FROM Reviews GROUP BY RestaurantID";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                int restaurantId = rs.getInt("RestaurantID");
                double avgRating = rs.getDouble("AvgRating");
                int reviewCount = rs.getInt("ReviewCount");
                map.put(restaurantId, new double[] { avgRating, reviewCount });
            }
        } catch (SQLException ex) {
            Logger.getLogger(ReviewDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return map;
    }
}
