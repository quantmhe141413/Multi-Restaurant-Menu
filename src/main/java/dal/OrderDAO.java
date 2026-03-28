package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Order;
import models.OrderItem;

public class OrderDAO extends DBContext {

    public int createOrder(Order order) {
        String sql = "INSERT INTO Orders (RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID, TotalAmount, DiscountAmount, DeliveryFee, FinalAmount, PaymentMethod, PaymentStatus, IsClosed, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setInt(1, order.getRestaurantID());
            st.setInt(2, order.getCustomerID());
            st.setString(3, order.getOrderType());
            if (order.getTableID() != null) {
                st.setInt(4, order.getTableID());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }
            st.setString(5, order.getOrderStatus());
            if (order.getDiscountID() != null) {
                st.setInt(6, order.getDiscountID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setDouble(7, order.getTotalAmount());
            st.setDouble(8, order.getDiscountAmount());
            st.setDouble(9, order.getDeliveryFee());
            st.setDouble(10, order.getFinalAmount());
            st.setString(11, order.getPaymentMethod());
            st.setString(12, order.getPaymentStatus() != null ? order.getPaymentStatus() : "Pending");
            st.setBoolean(13, false); // IsClosed = false khi mới tạo
            st.setTimestamp(14, new Timestamp(System.currentTimeMillis()));
            
            int affectedRows = st.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        return generatedKeys.getInt(1);
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    public boolean createOrderItem(OrderItem orderItem) {
        String sql = "INSERT INTO OrderItems (OrderID, ItemID, Quantity, UnitPrice, Note, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderItem.getOrderID());
            st.setInt(2, orderItem.getItemID());
            st.setInt(3, orderItem.getQuantity());
            st.setDouble(4, orderItem.getUnitPrice());
            if (orderItem.getNote() != null && !orderItem.getNote().trim().isEmpty()) {
                st.setString(5, orderItem.getNote());
            } else {
                st.setNull(5, java.sql.Types.NVARCHAR);
            }
            st.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    public List<Order> getOrdersByCustomer(int customerID) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE CustomerID = ? ORDER BY CreatedAt DESC";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, customerID);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return list;
    }

    public Order getOrderById(int orderID) {
        String sql = "SELECT o.*, u.FullName AS CustomerName FROM Orders o "
                + "JOIN Users u ON o.CustomerID = u.UserID WHERE o.OrderID = ?";

        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            ResultSet rs = st.executeQuery();

            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setCustomerName(rs.getString("CustomerName"));
                return order;
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }

        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderID) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT oi.*, mi.ItemName FROM OrderItems oi " +
                    "LEFT JOIN MenuItems mi ON oi.ItemID = mi.ItemID " +
                    "WHERE oi.OrderID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                OrderItem item = mapOrderItem(rs);
                // Set item name from MenuItems table
                item.setItemName(rs.getString("ItemName"));
                list.add(item);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return list;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setOrderID(rs.getInt("OrderID"));
        order.setRestaurantID(rs.getInt("RestaurantID"));
        order.setCustomerID(rs.getInt("CustomerID"));
        order.setOrderType(rs.getString("OrderType"));
        int tableID = rs.getInt("TableID");
        if (!rs.wasNull()) {
            order.setTableID(tableID);
        }
        order.setOrderStatus(rs.getString("OrderStatus"));
        int discountID = rs.getInt("DiscountID");
        if (!rs.wasNull()) {
            order.setDiscountID(discountID);
        }
        order.setTotalAmount(rs.getDouble("TotalAmount"));
        order.setDiscountAmount(rs.getDouble("DiscountAmount"));
        order.setDeliveryFee(rs.getDouble("DeliveryFee"));
        order.setFinalAmount(rs.getDouble("FinalAmount"));
        order.setPaymentMethod(rs.getString("PaymentMethod"));
        order.setPaymentStatus(rs.getString("PaymentStatus"));
        order.setPaidAt(rs.getTimestamp("PaidAt"));
        order.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return order;
    }

    private OrderItem mapOrderItem(ResultSet rs) throws SQLException {
        OrderItem item = new OrderItem();
        item.setOrderItemID(rs.getInt("OrderItemID"));
        item.setOrderID(rs.getInt("OrderID"));
        item.setItemID(rs.getInt("ItemID"));
        item.setQuantity(rs.getInt("Quantity"));
        item.setUnitPrice(rs.getDouble("UnitPrice"));
        String note = rs.getString("Note");
        if (note != null) {
            item.setNote(note);
        }
        item.setCreatedAt(rs.getTimestamp("CreatedAt"));
        return item;
    }

    // Payment Methods
    public boolean createPayment(int orderID, int customerID, String paymentType, String txnRef, long amount) throws SQLException {
        String sql = "INSERT INTO Payments (OrderID, CustomerID, PaymentType, TransactionRef, Amount, PaymentStatus, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, 'Pending', GETDATE())";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            st.setInt(2, customerID);
            st.setString(3, paymentType);
            st.setString(4, txnRef);
            st.setLong(5, amount);
            
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    public boolean updatePayment(String txnRef, String bankCode, String cardType, String payDate,
                                 String responseCode, String transactionNo, String transactionStatus,
                                 String secureHash, String paymentStatus) throws SQLException {
        String sql = "UPDATE Payments SET BankCode = ?, CardType = ?, PayDate = ?, ResponseCode = ?, "
                + "TransactionNo = ?, TransactionStatus = ?, SecureHash = ?, PaymentStatus = ?, UpdatedAt = GETDATE() "
                + "WHERE TransactionRef = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, bankCode);
            st.setString(2, cardType);
            st.setString(3, payDate);
            st.setString(4, responseCode);
            st.setString(5, transactionNo);
            st.setString(6, transactionStatus);
            st.setString(7, secureHash);
            st.setString(8, paymentStatus);
            st.setString(9, txnRef);
            
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    public boolean updateOrderPaymentStatus(int orderID, String paymentStatus, Timestamp paidAt) throws SQLException {
        String sql = "UPDATE Orders SET PaymentStatus = ?, PaidAt = ? WHERE OrderID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, paymentStatus);
            if (paidAt != null) {
                st.setTimestamp(2, paidAt);
            } else {
                st.setNull(2, java.sql.Types.TIMESTAMP);
            }
            st.setInt(3, orderID);
            
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
    }

    public int getOrderIdByTxnRef(String txnRef) throws SQLException {
        String sql = "SELECT OrderID FROM Payments WHERE TransactionRef = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, txnRef);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("OrderID");
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            throw ex;
        }
        
        return -1;
    }

    /**
     * Get all orders for a restaurant, newest first, with customer name.
     * Supports pagination.
     */
    public List<Order> getOrdersByRestaurant(int restaurantId, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT o.*, u.FullName AS CustomerName "
                + "FROM Orders o "
                + "LEFT JOIN Users u ON o.CustomerID = u.UserID "
                + "WHERE o.RestaurantID = ? "
                + "ORDER BY o.CreatedAt DESC "
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            st.setInt(2, (page - 1) * pageSize);
            st.setInt(3, pageSize);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setCustomerName(rs.getString("CustomerName"));
                list.add(order);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Count total orders for a restaurant (for pagination).
     */
    public int countOrdersByRestaurant(int restaurantId) {
        String sql = "SELECT COUNT(*) FROM Orders WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Build IN clause placeholder string for a list of IDs, e.g. "?,?,?"
     */
    private String buildInClause(int size) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < size; i++) {
            if (i > 0) sb.append(",");
            sb.append("?");
        }
        return sb.toString();
    }

    /**
     * Get orders with filters for owner.
     * If restaurantId is not null, filters by that restaurant.
     * Otherwise filters by the provided ownerRestaurantIds list.
     */
    public List<Order> getOrdersWithFilters(Integer restaurantId, List<Integer> ownerRestaurantIds,
                                            String fromDate, String toDate,
                                            String status, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, u.FullName AS CustomerName, r.Name AS RestaurantName ")
           .append("FROM Orders o ")
           .append("JOIN Users u ON o.CustomerID = u.UserID ")
           .append("JOIN Restaurants r ON o.RestaurantID = r.RestaurantID ")
           .append("WHERE 1=1 ");

        if (restaurantId != null) {
            sql.append("AND o.RestaurantID = ? ");
        } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
            sql.append("AND o.RestaurantID IN (").append(buildInClause(ownerRestaurantIds.size())).append(") ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(o.CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(o.CreatedAt AS DATE) <= ? ");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            sql.append("AND o.OrderStatus = ? ");
        }

        sql.append("ORDER BY o.CreatedAt DESC ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (restaurantId != null) {
                st.setInt(idx++, restaurantId);
            } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
                for (Integer id : ownerRestaurantIds) {
                    st.setInt(idx++, id);
                }
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
                st.setString(idx++, status);
            }
            st.setInt(idx++, (page - 1) * pageSize);
            st.setInt(idx++, pageSize);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setCustomerName(rs.getString("CustomerName"));
                order.setRestaurantName(rs.getString("RestaurantName"));
                list.add(order);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Count orders with filters.
     * If restaurantId is not null, filters by that restaurant.
     * Otherwise filters by the provided ownerRestaurantIds list.
     */
    public int countOrdersWithFilters(Integer restaurantId, List<Integer> ownerRestaurantIds,
                                      String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Orders WHERE 1=1 ");

        if (restaurantId != null) {
            sql.append("AND RestaurantID = ? ");
        } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
            sql.append("AND RestaurantID IN (").append(buildInClause(ownerRestaurantIds.size())).append(") ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) <= ? ");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            sql.append("AND OrderStatus = ? ");
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (restaurantId != null) {
                st.setInt(idx++, restaurantId);
            } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
                for (Integer id : ownerRestaurantIds) {
                    st.setInt(idx++, id);
                }
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
                st.setString(idx++, status);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Get revenue statistics for a date range.
     * If restaurantId is not null, filters by that restaurant.
     * Otherwise filters by the provided ownerRestaurantIds list.
     */
    public Map<String, Object> getRevenueStatistics(Integer restaurantId, List<Integer> ownerRestaurantIds,
                                                     String fromDate, String toDate) {
        Map<String, Object> stats = new HashMap<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
           .append("COUNT(*) AS TotalOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Completed' THEN FinalAmount ELSE 0 END) AS TotalRevenue, ")
           .append("AVG(CASE WHEN OrderStatus = 'Completed' THEN FinalAmount ELSE NULL END) AS AvgOrderValue ")
           .append("FROM Orders ")
           .append("WHERE 1=1 ");

        if (restaurantId != null) {
            sql.append("AND RestaurantID = ? ");
        } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
            sql.append("AND RestaurantID IN (").append(buildInClause(ownerRestaurantIds.size())).append(") ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) <= ? ");
        }

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            if (restaurantId != null) {
                st.setInt(idx++, restaurantId);
            } else if (ownerRestaurantIds != null && !ownerRestaurantIds.isEmpty()) {
                for (Integer id : ownerRestaurantIds) {
                    st.setInt(idx++, id);
                }
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("TotalOrders"));
                stats.put("completedOrders", rs.getInt("CompletedOrders"));
                stats.put("cancelledOrders", rs.getInt("CancelledOrders"));
                stats.put("totalRevenue", rs.getDouble("TotalRevenue"));
                stats.put("avgOrderValue", rs.getDouble("AvgOrderValue"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return stats;
    }

    /**
     * Get order with full details including customer info and delivery address.
     * Returns null if order doesn't belong to the restaurant.
     */
    public Order getOrderDetailForRestaurant(int orderId, int restaurantId) {
        String sql = "SELECT o.*, u.FullName AS CustomerName, u.Phone AS CustomerPhone, u.Email AS CustomerEmail, "
                + "di.Address AS DeliveryAddress "
                + "FROM Orders o "
                + "JOIN Users u ON o.CustomerID = u.UserID "
                + "LEFT JOIN DeliveryInfo di ON o.OrderID = di.OrderID "
                + "WHERE o.OrderID = ? AND o.RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                Order order = mapOrder(rs);
                order.setCustomerName(rs.getString("CustomerName"));
                return order;
            }
        } catch (SQLException ex) {
            System.out.println("DEBUG: SQL Error - " + ex.getMessage());
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Update order status.
     */
    public boolean updateOrderStatus(int orderId, String newStatus) {
        try {
            String sql;
            if ("Completed".equals(newStatus)) {
                sql = "UPDATE Orders SET OrderStatus = ?, PaymentStatus = 'Success', PaidAt = GETUTCDATE() WHERE OrderID = ?";
            } else if ("Cancelled".equals(newStatus)) {
                // Nếu đã thanh toán thì hoàn tiền, chưa thì đánh dấu Failed
                String currentPaymentStatus = null;
                PreparedStatement check = connection.prepareStatement(
                    "SELECT PaymentStatus FROM Orders WHERE OrderID = ?");
                check.setInt(1, orderId);
                ResultSet rs = check.executeQuery();
                if (rs.next()) {
                    currentPaymentStatus = rs.getString("PaymentStatus");
                }
                String cancelPaymentStatus = "Success".equals(currentPaymentStatus) ? "Refunded" : "Failed";
                sql = "UPDATE Orders SET OrderStatus = ?, PaymentStatus = '" + cancelPaymentStatus + "' WHERE OrderID = ?";
            } else {
                sql = "UPDATE Orders SET OrderStatus = ? WHERE OrderID = ?";
            }
            PreparedStatement st = connection.prepareStatement(sql);
            st.setString(1, newStatus);
            st.setInt(2, orderId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    /**
     * Get orders with filters for owner (date range, status).
     */
    public List<Order> getOrdersWithFilters(int restaurantId, String fromDate, String toDate, 
                                            String status, int page, int pageSize) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT o.*, u.FullName AS CustomerName ")
           .append("FROM Orders o ")
           .append("LEFT JOIN Users u ON o.CustomerID = u.UserID ")
           .append("WHERE o.RestaurantID = ? ");

        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(o.CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(o.CreatedAt AS DATE) <= ? ");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            sql.append("AND o.OrderStatus = ? ");
        }
        
        sql.append("ORDER BY o.CreatedAt DESC ")
           .append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            st.setInt(idx++, restaurantId);
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
                st.setString(idx++, status);
            }
            st.setInt(idx++, (page - 1) * pageSize);
            st.setInt(idx++, pageSize);
            
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                Order order = mapOrder(rs);
                order.setCustomerName(rs.getString("CustomerName"));
                list.add(order);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Count orders with filters.
     */
    public int countOrdersWithFilters(int restaurantId, String fromDate, String toDate, String status) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Orders WHERE RestaurantID = ? ");
        
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) <= ? ");
        }
        if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
            sql.append("AND OrderStatus = ? ");
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            st.setInt(idx++, restaurantId);
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }
            if (status != null && !status.trim().isEmpty() && !status.equals("All")) {
                st.setString(idx++, status);
            }
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Get revenue statistics for a date range.
     */
    public Map<String, Object> getRevenueStatistics(int restaurantId, String fromDate, String toDate) {
        Map<String, Object> stats = new HashMap<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT ")
           .append("COUNT(*) AS TotalOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Completed' THEN 1 ELSE 0 END) AS CompletedOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Cancelled' THEN 1 ELSE 0 END) AS CancelledOrders, ")
           .append("SUM(CASE WHEN OrderStatus = 'Completed' THEN FinalAmount ELSE 0 END) AS TotalRevenue, ")
           .append("AVG(CASE WHEN OrderStatus = 'Completed' THEN FinalAmount ELSE NULL END) AS AvgOrderValue ")
           .append("FROM Orders ")
           .append("WHERE RestaurantID = ? ");
        
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(CreatedAt AS DATE) <= ? ");
        }
        
        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            st.setInt(idx++, restaurantId);
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                st.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                st.setString(idx++, toDate);
            }
            
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                stats.put("totalOrders", rs.getInt("TotalOrders"));
                stats.put("completedOrders", rs.getInt("CompletedOrders"));
                stats.put("cancelledOrders", rs.getInt("CancelledOrders"));
                stats.put("totalRevenue", rs.getDouble("TotalRevenue"));
                stats.put("avgOrderValue", rs.getDouble("AvgOrderValue"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return stats;
    }

    /**
     * Get the latest OrderID for a restaurant.
     * Returns 0 if the restaurant has no orders yet.
     */
    public int getLatestOrderIdForRestaurant(int restaurantId) {
        String sql = "SELECT ISNULL(MAX(OrderID), 0) AS LatestId FROM Orders WHERE RestaurantID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("LatestId");
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    /**
     * Count new orders created for a restaurant since the given lastOrderId.
     * Only orders in 'Preparing' status are considered "new" for staff alerts.
     */
    public int countNewPreparingOrdersSince(int restaurantId, int lastOrderId) {
        String sql = "SELECT COUNT(*) AS Cnt FROM Orders "
                + "WHERE RestaurantID = ? AND OrderStatus = 'Preparing' AND OrderID > ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            st.setInt(2, lastOrderId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("Cnt");
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return 0;
    }

    // =====================================================================
    // Staff POS Methods
    // =====================================================================

    /**
     * Get all orders for a specific table (by TableID).
     * Returns all orders including unpaid ones, sorted by creation date descending.
     */
    public List<Order> getOrdersByTable(int tableId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM Orders WHERE TableID = ? ORDER BY CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, tableId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                list.add(mapOrder(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Get the active (unpaid/pending) order for a specific table in a restaurant.
     * Returns null if no active order exists.
     */
    public Order getActiveOrderByTable(int tableId, Integer restaurantId) {
        String sql = "SELECT TOP 1 * FROM Orders WHERE TableID = ? AND RestaurantID = ? "
                + "AND PaymentStatus != 'Success' AND OrderStatus != 'Cancelled' "
                + "ORDER BY CreatedAt DESC";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, tableId);
            st.setInt(2, restaurantId);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapOrder(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return null;
    }

    /**
     * Add an order item directly to an existing order.
     * Convenience method for Staff POS.
     */
    public boolean addOrderItem(int orderId, int itemId, int quantity, double unitPrice, String note) {
        String sql = "INSERT INTO OrderItems (OrderID, ItemID, Quantity, UnitPrice, Note, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            st.setInt(2, itemId);
            st.setInt(3, quantity);
            st.setDouble(4, unitPrice);
            if (note != null && !note.trim().isEmpty()) {
                st.setString(5, note);
            } else {
                st.setNull(5, java.sql.Types.NVARCHAR);
            }
            st.setTimestamp(6, new Timestamp(System.currentTimeMillis()));
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    /**
     * Recalculate and update the TotalAmount and FinalAmount of an order
     * based on its current OrderItems.
     */
    public boolean updateOrderTotal(int orderId) {
        String sql = "UPDATE Orders SET TotalAmount = "
                + "(SELECT ISNULL(SUM(Quantity * UnitPrice), 0) FROM OrderItems WHERE OrderID = ?), "
                + "FinalAmount = "
                + "(SELECT ISNULL(SUM(Quantity * UnitPrice), 0) FROM OrderItems WHERE OrderID = ?) "
                + "- DiscountAmount + DeliveryFee "
                + "WHERE OrderID = ?";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            st.setInt(2, orderId);
            st.setInt(3, orderId);
            return st.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    /**
     * Get order count grouped by hour of the day for peak hours analysis.
     */
    public java.util.Map<Integer, Integer> getPeakHoursStats(int restaurantId) {
        java.util.Map<Integer, Integer> stats = new java.util.TreeMap<>();
        // Initialize all 24 hours
        for (int i = 0; i < 24; i++)
            stats.put(i, 0);

        String sql = "SELECT DATEPART(HOUR, CreatedAt) AS OrderHour, COUNT(*) AS OrderCount " +
                "FROM Orders WHERE RestaurantID = ? AND (OrderStatus = 'Completed' OR OrderStatus = 'Preparing') " +
                "GROUP BY DATEPART(HOUR, CreatedAt) ORDER BY OrderHour";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, restaurantId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                stats.put(rs.getInt("OrderHour"), rs.getInt("OrderCount"));
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return stats;
    }

    /**
     * Get daily revenue and order volume for a restaurant.
     */
    public java.util.List<java.util.Map<String, Object>> getDailyRevenueStats(int restaurantId, String startDate,
            String endDate) {
        java.util.List<java.util.Map<String, Object>> list = new java.util.ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT CAST(CreatedAt AS DATE) AS OrderDate, COUNT(*) AS OrderCount, SUM(FinalAmount) AS TotalRevenue ")
                .append("FROM Orders WHERE RestaurantID = ? AND OrderStatus = 'Completed' ");

        if (startDate != null && !startDate.trim().isEmpty()) {
            sql.append(" AND CreatedAt >= ?");
        }
        if (endDate != null && !endDate.trim().isEmpty()) {
            sql.append(" AND CreatedAt <= ?");
        }

        sql.append(" GROUP BY CAST(CreatedAt AS DATE) ORDER BY OrderDate DESC");

        try {
            PreparedStatement st = connection.prepareStatement(sql.toString());
            int idx = 1;
            st.setInt(idx++, restaurantId);
            if (startDate != null && !startDate.trim().isEmpty()) {
                st.setString(idx++, startDate + " 00:00:00");
            }
            if (endDate != null && !endDate.trim().isEmpty()) {
                st.setString(idx++, endDate + " 23:59:59");
            }

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                java.util.Map<String, Object> map = new java.util.HashMap<>();
                map.put("date", rs.getDate("OrderDate"));
                map.put("count", rs.getInt("OrderCount"));
                map.put("revenue", rs.getDouble("TotalRevenue"));
                list.add(map);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return list;
    }

    /**
     * Create an order for a walk-in customer (Staff POS).
     * Inserts a temporary customer record if needed, then creates the order.
     * Returns the generated OrderID, or -1 on failure.
     */
    public int createOrderForStaff(Order order, String customerName, String customerPhone, String deliveryAddress) {
        // For staff orders, we need a valid CustomerID. 
        // We'll use the staff user ID from session or create a guest user approach
        String sql = "INSERT INTO Orders (RestaurantID, CustomerID, OrderType, TableID, OrderStatus, "
                + "DiscountID, TotalAmount, DiscountAmount, DeliveryFee, FinalAmount, "
                + "PaymentMethod, PaymentStatus, IsClosed, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try {
            // Get or create a guest customer ID
            int guestCustomerId = getOrCreateGuestCustomer();
            
            PreparedStatement st = connection.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            st.setInt(1, order.getRestaurantID());
            st.setInt(2, guestCustomerId); // Use valid guest customer ID
            st.setString(3, order.getOrderType());
            if (order.getTableID() != null) {
                st.setInt(4, order.getTableID());
            } else {
                st.setNull(4, java.sql.Types.INTEGER);
            }
            st.setString(5, order.getOrderStatus());
            if (order.getDiscountID() != null) {
                st.setInt(6, order.getDiscountID());
            } else {
                st.setNull(6, java.sql.Types.INTEGER);
            }
            st.setDouble(7, order.getTotalAmount());
            st.setDouble(8, order.getDiscountAmount());
            st.setDouble(9, order.getDeliveryFee());
            st.setDouble(10, order.getFinalAmount());
            st.setString(11, order.getPaymentMethod());
            st.setString(12, order.getPaymentStatus() != null ? order.getPaymentStatus() : "Pending");
            st.setBoolean(13, false);
            st.setTimestamp(14, new Timestamp(System.currentTimeMillis()));

            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet generatedKeys = st.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        int orderId = generatedKeys.getInt(1);
                        // Store delivery address if provided
                        if (deliveryAddress != null && !deliveryAddress.trim().isEmpty()) {
                            saveDeliveryInfo(orderId, deliveryAddress, customerName, customerPhone);
                        }
                        return orderId;
                    }
                }
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        return -1;
    }

    /**
     * Get or create a guest customer for staff orders
     */
    private int getOrCreateGuestCustomer() throws SQLException {
        // First try to find existing guest customer
        String findSql = "SELECT UserID FROM Users WHERE Email = 'guest@system.local' AND RoleID = 4";
        PreparedStatement findSt = connection.prepareStatement(findSql);
        ResultSet rs = findSt.getResultSet();
        
        try (PreparedStatement st = connection.prepareStatement(findSql)) {
            rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserID");
            }
        }
        
        // If not found, create guest customer
        String createSql = "INSERT INTO Users (FullName, Email, PasswordHash, Phone, RoleID, IsActive, CreatedAt) " +
                          "VALUES ('Khách lẻ', 'guest@system.local', 'N/A', '0000000000', 4, 1, GETDATE())";
        try (PreparedStatement createSt = connection.prepareStatement(createSql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            createSt.executeUpdate();
            try (ResultSet generatedKeys = createSt.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        
        // Fallback: return 1 (assuming there's always a user with ID 1)
        return 1;
    }

    /**
     * Save delivery info for an order (used for Online/Delivery orders).
     */
    private void saveDeliveryInfo(int orderId, String address, String recipientName, String phone) {
        String sql = "IF EXISTS (SELECT 1 FROM DeliveryInfo WHERE OrderID = ?) "
                + "UPDATE DeliveryInfo SET Address = ?, RecipientName = ?, Phone = ? WHERE OrderID = ? "
                + "ELSE "
                + "INSERT INTO DeliveryInfo (OrderID, Address, RecipientName, Phone) VALUES (?, ?, ?, ?)";
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderId);
            st.setString(2, address);
            st.setString(3, recipientName);
            st.setString(4, phone);
            st.setInt(5, orderId);
            st.setInt(6, orderId);
            st.setString(7, address);
            st.setString(8, recipientName);
            st.setString(9, phone);
            st.executeUpdate();
        } catch (SQLException ex) {
            // DeliveryInfo table may not exist, log but don't fail the order creation
            Logger.getLogger(OrderDAO.class.getName()).log(Level.WARNING,
                    "Could not save delivery info for order " + orderId + ": " + ex.getMessage(), ex);
        }
    }
}
