package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import models.Order;
import models.OrderItem;

public class OrderDAO extends DBContext {

    public int createOrder(Order order) {
        String sql = "INSERT INTO Orders (RestaurantID, CustomerID, OrderType, TableID, OrderStatus, DiscountID, TotalAmount, DiscountAmount, FinalAmount, PaymentMethod, PaymentStatus, IsClosed, CreatedAt) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
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
            st.setDouble(9, order.getFinalAmount());
            st.setString(10, order.getPaymentMethod());
            st.setString(11, order.getPaymentStatus() != null ? order.getPaymentStatus() : "Pending");
            st.setBoolean(12, false); // IsClosed = false khi mới tạo
            st.setTimestamp(13, new Timestamp(System.currentTimeMillis()));
            
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
        String sql = "SELECT * FROM Orders WHERE OrderID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            ResultSet rs = st.executeQuery();
            
            if (rs.next()) {
                return mapOrder(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(OrderDAO.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId(int orderID) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM OrderItems WHERE OrderID = ?";
        
        try {
            PreparedStatement st = connection.prepareStatement(sql);
            st.setInt(1, orderID);
            ResultSet rs = st.executeQuery();
            
            while (rs.next()) {
                list.add(mapOrderItem(rs));
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
}
