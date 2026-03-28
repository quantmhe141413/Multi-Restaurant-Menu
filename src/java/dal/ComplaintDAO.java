package dal;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import models.ComplaintView;

public class ComplaintDAO extends DBContext {

    private ComplaintView fromResultSet(ResultSet rs) throws SQLException {
        ComplaintView c = new ComplaintView();
        c.setComplaintID(rs.getInt("ComplaintID"));
        c.setOrderID((Integer) rs.getObject("OrderID"));
        c.setCustomerID(rs.getInt("CustomerID"));
        c.setDescription(rs.getString("Description"));
        c.setStatus(rs.getString("Status"));
        c.setCreatedAt(rs.getTimestamp("CreatedAt"));

        c.setCustomerName(rs.getString("CustomerName"));
        c.setCustomerEmail(rs.getString("CustomerEmail"));

        c.setRestaurantID((Integer) rs.getObject("RestaurantID"));
        c.setRestaurantName(rs.getString("RestaurantName"));
        c.setRestaurantOwnerName(rs.getString("RestaurantOwnerName"));
        c.setRestaurantOwnerEmail(rs.getString("RestaurantOwnerEmail"));

        c.setOrderStatus(rs.getString("OrderStatus"));
        BigDecimal finalAmount = rs.getBigDecimal("FinalAmount");
        c.setFinalAmount(finalAmount == null ? null : finalAmount.doubleValue());

        return c;
    }

    private static final String BASE_SELECT =
            "SELECT c.ComplaintID, c.OrderID, c.CustomerID, c.Description, c.Status, c.CreatedAt, "
            + "u.FullName AS CustomerName, u.Email AS CustomerEmail, "
            + "o.RestaurantID, r.Name AS RestaurantName, o.OrderStatus, o.FinalAmount, "
            + "owner.FullName AS RestaurantOwnerName, owner.Email AS RestaurantOwnerEmail ";

    private static final String BASE_FROM =
            "FROM Complaints c "
            + "LEFT JOIN Orders o ON c.OrderID = o.OrderID "
            + "LEFT JOIN Restaurants r ON o.RestaurantID = r.RestaurantID "
            + "LEFT JOIN Users u ON c.CustomerID = u.UserID "
            + "LEFT JOIN Users owner ON r.OwnerID = owner.UserID ";

    private void appendFilters(StringBuilder sql, List<Object> params,
            String status, String search, Timestamp fromTs, Timestamp toExclusive) {
        sql.append("WHERE 1=1 ");

        if (status != null && !status.trim().isEmpty()) {
            sql.append("AND c.Status = ? ");
            params.add(status.trim());
        }
        if (fromTs != null) {
            sql.append("AND c.CreatedAt >= ? ");
            params.add(fromTs);
        }
        if (toExclusive != null) {
            sql.append("AND c.CreatedAt < ? ");
            params.add(toExclusive);
        }
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (");
            sql.append("c.Description LIKE ? OR ");
            sql.append("u.FullName LIKE ? OR u.Email LIKE ? OR ");
            sql.append("r.Name LIKE ? OR ");
            sql.append("CAST(c.ComplaintID AS VARCHAR(20)) LIKE ? OR CAST(c.OrderID AS VARCHAR(20)) LIKE ?");
            sql.append(") ");

            String like = "%" + search.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
    }

    private void setParams(PreparedStatement st, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            Object p = params.get(i);
            if (p instanceof Timestamp) {
                st.setTimestamp(i + 1, (Timestamp) p);
            } else {
                st.setObject(i + 1, p);
            }
        }
    }

    public List<ComplaintView> findComplaintsWithFilters(String status, String search,
            Timestamp fromTs, Timestamp toExclusive, int page, int pageSize) {
        List<ComplaintView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append(BASE_SELECT);
        sql.append(BASE_FROM);

        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, status, search, fromTs, toExclusive);

        sql.append("ORDER BY c.CreatedAt DESC, c.ComplaintID DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            setParams(st, params);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(fromResultSet(rs));
            }
        } catch (SQLException ex) {
            System.out.println("Error findComplaintsWithFilters: " + ex.getMessage());
        } 
        return list;
    }

    public int getTotalComplaints(String status, String search,
            Timestamp fromTs, Timestamp toExclusive) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) ");
        sql.append(BASE_FROM);

        List<Object> params = new ArrayList<>();
        appendFilters(sql, params, status, search, fromTs, toExclusive);

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            setParams(st, params);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error getTotalComplaints: " + ex.getMessage());
        } 
        return 0;
    }

    public ComplaintView findById(int complaintId) {
        String sql = BASE_SELECT + BASE_FROM + "WHERE c.ComplaintID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, complaintId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return fromResultSet(rs);
            }
        } catch (SQLException ex) {
            System.out.println("Error findById: " + ex.getMessage());
        } 
        return null;
    }

    public boolean updateComplaintStatus(int complaintId, String status) {
        if (status == null || status.trim().isEmpty()) {
            return false;
        }
        String sql = "UPDATE Complaints SET Status = ? WHERE ComplaintID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, status.trim());
            st.setInt(2, complaintId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            System.out.println("Error updateComplaintStatus: " + ex.getMessage());
            return false;
        } 
    }
}
