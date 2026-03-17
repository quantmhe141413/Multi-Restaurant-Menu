package dal;

import models.Invoice;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO extends DBContext {

    /**
     * Map ResultSet to Invoice object
     */
    public Invoice getFromResultSet(ResultSet rs) throws SQLException {
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(rs.getInt("InvoiceID"));
        invoice.setOrderId(rs.getInt("OrderID"));
        invoice.setInvoiceNumber(rs.getString("InvoiceNumber"));
        invoice.setIssuedDate(rs.getTimestamp("IssuedDate"));
        invoice.setSubtotal(rs.getBigDecimal("Subtotal"));
        invoice.setTaxAmount(rs.getBigDecimal("TaxAmount"));
        invoice.setFinalAmount(rs.getBigDecimal("FinalAmount"));

        // Additional fields — silently skip if not in result set
        try {
            invoice.setOrderDate(rs.getTimestamp("OrderDateUTC"));
            invoice.setRestaurantId(rs.getInt("RestaurantID"));
            invoice.setRestaurantName(rs.getString("RestaurantName"));
            invoice.setCustomerId(rs.getInt("CustomerID"));
            invoice.setCustomerName(rs.getString("CustomerName"));
            invoice.setOrderType(rs.getString("OrderType"));
            invoice.setOrderStatus(rs.getString("OrderStatus"));
            invoice.setPaymentType(rs.getString("PaymentType"));
            invoice.setPaymentStatus(rs.getString("PaymentStatus"));
            invoice.setIsPaid(rs.getBoolean("IsPaid"));
            invoice.setTransactionRef(rs.getString("TransactionRef"));
            invoice.setPaidAt(rs.getTimestamp("PaidAt"));
            invoice.setDeliveryAddress(rs.getString("DeliveryAddress"));
            invoice.setDeliveryStatus(rs.getString("DeliveryStatus"));
        } catch (SQLException e) {
            // Fields not available in basic query
        }

        return invoice;
    }

    /**
     * Find invoices with filters (paginated).
     * restaurantId = null → SuperAdmin sees all restaurants.
     */
    public List<Invoice> findInvoicesWithFilters(Integer restaurantId, String fromDate,
                                                  String toDate, int page, int pageSize) {
        List<Invoice> invoices = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT inv.InvoiceID, inv.OrderID, inv.InvoiceNumber, inv.IssuedDate, ")
           .append("inv.Subtotal, inv.TaxAmount, inv.FinalAmount, ")
           .append("o.CreatedAt AS OrderDateUTC, o.OrderType, o.OrderStatus, ")
           .append("r.RestaurantID, r.Name AS RestaurantName, ")
           .append("u.UserID AS CustomerID, u.FullName AS CustomerName, ")
           .append("p.PaymentType, p.PaymentStatus, p.IsPaid ")
           .append("FROM Invoices inv ")
           .append("JOIN Orders o ON inv.OrderID = o.OrderID ")
           .append("JOIN Restaurants r ON o.RestaurantID = r.RestaurantID ")
           .append("JOIN Users u ON o.CustomerID = u.UserID ")
           .append("LEFT JOIN Payments p ON o.OrderID = p.OrderID ")
           .append("WHERE 1=1 ");

        if (restaurantId != null) {
            sql.append("AND r.RestaurantID = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(inv.IssuedDate AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(inv.IssuedDate AS DATE) <= ? ");
        }

        sql.append("ORDER BY inv.IssuedDate DESC ");
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int idx = 1;
            if (restaurantId != null) {
                statement.setInt(idx++, restaurantId);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                statement.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                statement.setString(idx++, toDate);
            }
            statement.setInt(idx++, (page - 1) * pageSize);
            statement.setInt(idx++, pageSize);

            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                invoices.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding invoices: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return invoices;
    }

    /**
     * Total count for pagination.
     */
    public int getTotalFilteredInvoices(Integer restaurantId, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Invoices inv ")
           .append("JOIN Orders o ON inv.OrderID = o.OrderID ")
           .append("WHERE 1=1 ");

        if (restaurantId != null) {
            sql.append("AND o.RestaurantID = ? ");
        }
        if (fromDate != null && !fromDate.trim().isEmpty()) {
            sql.append("AND CAST(inv.IssuedDate AS DATE) >= ? ");
        }
        if (toDate != null && !toDate.trim().isEmpty()) {
            sql.append("AND CAST(inv.IssuedDate AS DATE) <= ? ");
        }

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql.toString());

            int idx = 1;
            if (restaurantId != null) {
                statement.setInt(idx++, restaurantId);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                statement.setString(idx++, fromDate);
            }
            if (toDate != null && !toDate.trim().isEmpty()) {
                statement.setString(idx++, toDate);
            }

            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting invoices: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    /**
     * Find invoice by ID with full details.
     */
    public Invoice findById(Integer invoiceId) {
        String sql = "SELECT inv.InvoiceID, inv.OrderID, inv.InvoiceNumber, inv.IssuedDate, " +
                     "inv.Subtotal, inv.TaxAmount, inv.FinalAmount, " +
                     "o.CreatedAt AS OrderDateUTC, o.OrderType, o.OrderStatus, " +
                     "o.TotalAmount, o.DiscountAmount, " +
                     "r.RestaurantID, r.Name AS RestaurantName, r.Address AS RestaurantAddress, " +
                     "u.UserID AS CustomerID, u.FullName AS CustomerName, u.Email AS CustomerEmail, " +
                     "u.Phone AS CustomerPhone, " +
                     "p.PaymentType, p.PaymentStatus, p.IsPaid, p.TransactionRef, p.PaidAt, " +
                     "di.Address AS DeliveryAddress, di.DeliveryStatus " +
                     "FROM Invoices inv " +
                     "JOIN Orders o ON inv.OrderID = o.OrderID " +
                     "JOIN Restaurants r ON o.RestaurantID = r.RestaurantID " +
                     "JOIN Users u ON o.CustomerID = u.UserID " +
                     "LEFT JOIN Payments p ON o.OrderID = p.OrderID " +
                     "LEFT JOIN DeliveryInfo di ON o.OrderID = di.OrderID " +
                     "WHERE inv.InvoiceID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, invoiceId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding invoice by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Find invoice by Order ID.
     */
    public Invoice findByOrderId(Integer orderId) {
        String sql = "SELECT * FROM Invoices WHERE OrderID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding invoice by order ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Get restaurant ID from invoice ID.
     */
    public Integer getRestaurantIdByInvoiceId(Integer invoiceId) {
        String sql = "SELECT o.RestaurantID FROM Invoices inv " +
                     "JOIN Orders o ON inv.OrderID = o.OrderID " +
                     "WHERE inv.InvoiceID = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, invoiceId);
            resultSet = statement.executeQuery();

            if (resultSet.next()) {
                return resultSet.getInt("RestaurantID");
            }
        } catch (SQLException ex) {
            System.out.println("Error getting restaurant ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    /**
     * Auto-create invoice for an order after payment.
     * Queries TotalAmount and FinalAmount directly from Orders table.
     * Skips if an invoice already exists for this order.
     * Returns new InvoiceID, or null if already exists / error.
     */
    public Integer createInvoiceForOrder(int orderId) {
        if (findByOrderId(orderId) != null) {
            return null;
        }

        // Fetch amounts directly — avoids depending on OrderDAO
        String selectSql = "SELECT TotalAmount, FinalAmount FROM Orders WHERE OrderID = ?";
        double subtotal = 0, finalAmount = 0;
        try {
            connection = getConnection();
            statement = connection.prepareStatement(selectSql);
            statement.setInt(1, orderId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                subtotal = resultSet.getDouble("TotalAmount");
                finalAmount = resultSet.getDouble("FinalAmount");
            } else {
                return null;
            }
        } catch (SQLException ex) {
            System.out.println("Error fetching order amounts: " + ex.getMessage());
            return null;
        } finally {
            closeResources();
        }

        String invoiceNumber = String.format("INV-%d-%d", System.currentTimeMillis(), orderId);
        String insertSql = "INSERT INTO Invoices (OrderID, InvoiceNumber, IssuedDate, Subtotal, TaxAmount, FinalAmount) " +
                           "VALUES (?, ?, GETDATE(), ?, 0, ?)";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(insertSql, java.sql.Statement.RETURN_GENERATED_KEYS);
            statement.setInt(1, orderId);
            statement.setString(2, invoiceNumber);
            statement.setBigDecimal(3, java.math.BigDecimal.valueOf(subtotal));
            statement.setBigDecimal(4, java.math.BigDecimal.valueOf(finalAmount));

            int rows = statement.executeUpdate();
            if (rows > 0) {
                resultSet = statement.getGeneratedKeys();
                if (resultSet.next()) {
                    return resultSet.getInt(1);
                }
            }
        } catch (SQLException ex) {
            System.out.println("Error creating invoice: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }
}
