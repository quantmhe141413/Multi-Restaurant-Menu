package dal;

import models.Invoice;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO extends DBContext {

    /**
     * Map ResultSet to Invoice object from vw_InvoiceData view
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
        
        // Additional fields from view
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
     * Find invoices with filters
     * @param restaurantId Restaurant ID (null for SuperAdmin to view all restaurants)
     * @param fromDate Start date (YYYY-MM-DD format or null)
     * @param toDate End date (YYYY-MM-DD format or null)
     * @param page Page number (1-based)
     * @param pageSize Number of records per page
     * @return List of invoices
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

        // Restaurant filter - only if restaurantId is specified
        if (restaurantId != null) {
            sql.append("AND r.RestaurantID = ? ");
        }

        // Date range filter
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
            
            int paramIndex = 1;
            
            // Set restaurant ID parameter only if specified
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                statement.setString(paramIndex++, fromDate);
            }
            
            if (toDate != null && !toDate.trim().isEmpty()) {
                statement.setString(paramIndex++, toDate);
            }
            
            statement.setInt(paramIndex++, (page - 1) * pageSize);
            statement.setInt(paramIndex++, pageSize);

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
     * Get total count of filtered invoices
     * @param restaurantId Restaurant ID (null for SuperAdmin to view all restaurants)
     * @param fromDate Start date (YYYY-MM-DD format or null)
     * @param toDate End date (YYYY-MM-DD format or null)
     * @return Total count
     */
    public int getTotalFilteredInvoices(Integer restaurantId, String fromDate, String toDate) {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM Invoices inv ")
           .append("JOIN Orders o ON inv.OrderID = o.OrderID ")
           .append("WHERE 1=1 ");

        // Restaurant filter - only if restaurantId is specified
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
            
            int paramIndex = 1;
            
            // Set restaurant ID parameter only if specified
            if (restaurantId != null) {
                statement.setInt(paramIndex++, restaurantId);
            }
            
            if (fromDate != null && !fromDate.trim().isEmpty()) {
                statement.setString(paramIndex++, fromDate);
            }
            
            if (toDate != null && !toDate.trim().isEmpty()) {
                statement.setString(paramIndex++, toDate);
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
     * Find invoice by ID with complete details
     */
    public Invoice findById(Integer invoiceId) {
        String sql = "SELECT inv.InvoiceID, inv.OrderID, inv.InvoiceNumber, inv.IssuedDate, " +
                     "inv.Subtotal, inv.TaxAmount, inv.FinalAmount, " +
                     "o.CreatedAt AS OrderDateUTC, o.OrderType, o.OrderStatus, " +
                     "o.TotalAmount, o.DiscountAmount, " +
                     "r.RestaurantID, r.Name AS RestaurantName, r.Address AS RestaurantAddress, " +
                     "r.Phone AS RestaurantPhone, " +
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
     * Find invoice by Order ID
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
     * Get restaurant ID from invoice ID
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
}
