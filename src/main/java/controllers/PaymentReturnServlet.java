package controllers;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import utils.VNPayConfig;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.*;

@WebServlet(name = "PaymentReturnServlet", urlPatterns = {"/payment-return"})
public class PaymentReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all parameters from VNPay
        Map<String, String> fields = new HashMap<>();
        for (Enumeration<String> params = request.getParameterNames(); params.hasMoreElements();) {
            String fieldName = params.nextElement();
            String fieldValue = request.getParameter(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                try {
                    String encodedName = java.net.URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString());
                    String encodedValue = java.net.URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString());
                    fields.put(encodedName, encodedValue);
                } catch (Exception e) {
                    System.err.println("ERROR: Failed to encode field " + fieldName + ": " + e.getMessage());
                    fields.put(fieldName, fieldValue);
                }
            }
        }

        // Get secure hash from VNPay
        String vnp_SecureHash = request.getParameter("vnp_SecureHash");

        // Remove hash fields before validating
        try {
            String encodedHashType = java.net.URLEncoder.encode("vnp_SecureHashType", StandardCharsets.UTF_8.toString());
            String encodedHash = java.net.URLEncoder.encode("vnp_SecureHash", StandardCharsets.UTF_8.toString());
            if (fields.containsKey(encodedHashType)) {
                fields.remove(encodedHashType);
            }
            if (fields.containsKey(encodedHash)) {
                fields.remove(encodedHash);
            }
        } catch (Exception e) {
            fields.remove("vnp_SecureHashType");
            fields.remove("vnp_SecureHash");
        }

        System.out.println("DEBUG: VNPay SecureHash from response: " + vnp_SecureHash);
        
        // Validate signature
        String signValue = VNPayConfig.hashAllFields(fields);
        boolean isValidSignature = signValue.equals(vnp_SecureHash);
        
        System.out.println("DEBUG: Signature validation result: " + isValidSignature);

        // Get payment details
        String vnp_TxnRef = request.getParameter("vnp_TxnRef");
        String vnp_Amount = request.getParameter("vnp_Amount");
        String vnp_OrderInfo = request.getParameter("vnp_OrderInfo");
        String vnp_ResponseCode = request.getParameter("vnp_ResponseCode");
        String vnp_TransactionNo = request.getParameter("vnp_TransactionNo");
        String vnp_BankCode = request.getParameter("vnp_BankCode");
        String vnp_PayDate = request.getParameter("vnp_PayDate");
        String vnp_TransactionStatus = request.getParameter("vnp_TransactionStatus");
        String vnp_CardType = request.getParameter("vnp_CardType");

        // Set attributes for JSP display
        request.setAttribute("vnp_TxnRef", vnp_TxnRef);
        request.setAttribute("vnp_Amount", vnp_Amount);
        request.setAttribute("vnp_OrderInfo", vnp_OrderInfo);
        request.setAttribute("vnp_ResponseCode", vnp_ResponseCode);
        request.setAttribute("vnp_TransactionNo", vnp_TransactionNo);
        request.setAttribute("vnp_BankCode", vnp_BankCode);
        request.setAttribute("vnp_PayDate", vnp_PayDate);
        request.setAttribute("vnp_TransactionStatus", vnp_TransactionStatus);
        request.setAttribute("vnp_CardType", vnp_CardType);
        request.setAttribute("isValidSignature", isValidSignature);

        // Process payment result
        OrderDAO dao = new OrderDAO();
        String paymentStatus = "failed";
        String message = "";

        try {
            if (isValidSignature) {
                // Check transaction status
                if ("00".equals(vnp_ResponseCode) && "00".equals(vnp_TransactionStatus)) {
                    // Payment successful
                    paymentStatus = "success";
                    message = "Payment successful!";

                    // Update payment record
                    dao.updatePayment(
                        vnp_TxnRef,
                        vnp_BankCode,
                        vnp_CardType,
                        vnp_PayDate,
                        vnp_ResponseCode,
                        vnp_TransactionNo,
                        vnp_TransactionStatus,
                        vnp_SecureHash,
                        "Success"
                    );

                    // Get order ID from transaction reference
                    int orderId = extractOrderIdFromTxnRef(vnp_TxnRef);
                    if (orderId > 0) {
                        // Update order payment status to paid
                        dao.updateOrderPaymentStatus(orderId, "Paid", new Timestamp(System.currentTimeMillis()));
                        
                        // Clear cart from session
                        request.getSession().setAttribute("cart", new HashMap<Integer, Integer>());
                        
                        System.out.println("Order #" + orderId + " payment completed successfully");
                    }

                } else {
                    // Payment failed
                    paymentStatus = "failed";
                    
                    String errorMessage = getVNPayErrorMessage(vnp_ResponseCode);
                    message = "Payment failed: " + errorMessage + " (Code: " + vnp_ResponseCode + ")";

                    // Update payment record
                    dao.updatePayment(
                        vnp_TxnRef,
                        vnp_BankCode,
                        vnp_CardType,
                        vnp_PayDate,
                        vnp_ResponseCode,
                        vnp_TransactionNo,
                        vnp_TransactionStatus,
                        vnp_SecureHash,
                        "Failed"
                    );

                    // Reset order status to pending so user can retry
                    int orderId = extractOrderIdFromTxnRef(vnp_TxnRef);
                    if (orderId > 0) {
                        try {
                            dao.updateOrderPaymentStatus(orderId, "Pending", null);
                            System.out.println("Order #" + orderId + " status reset to 'Pending' after payment failure");
                        } catch (SQLException e) {
                            System.err.println("ERROR: Failed to reset order #" + orderId + " to pending: " + e.getMessage());
                            message += " Warning: Please contact support to reset order status.";
                        }
                    }
                }
            } else {
                // Invalid signature
                paymentStatus = "failed";
                message = "Invalid payment signature. This transaction may be fraudulent. Please contact support.";

                // Update VNPay payment record
                dao.updatePayment(
                    vnp_TxnRef,
                    vnp_BankCode,
                    vnp_CardType,
                    vnp_PayDate,
                    vnp_ResponseCode,
                    vnp_TransactionNo,
                    vnp_TransactionStatus,
                    vnp_SecureHash,
                    "Failed"
                );

                // Reset order status
                int orderId = extractOrderIdFromTxnRef(vnp_TxnRef);
                if (orderId > 0) {
                    try {
                        dao.updateOrderPaymentStatus(orderId, "Pending", null);
                        System.out.println("Order #" + orderId + " status reset to 'Pending' after invalid signature");
                    } catch (SQLException e) {
                        System.err.println("ERROR: Failed to reset order #" + orderId + ": " + e.getMessage());
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("ERROR: Database error in VNPay return: " + e.getMessage());
            e.printStackTrace();
            message = "Database error: " + e.getMessage();
            paymentStatus = "failed";
            
            // Try to reset order status even on database error
            try {
                int orderId = extractOrderIdFromTxnRef(vnp_TxnRef);
                if (orderId > 0) {
                    dao.updateOrderPaymentStatus(orderId, "Pending", null);
                    System.out.println("Order #" + orderId + " status reset to 'Pending' after database error");
                }
            } catch (Exception ex) {
                System.err.println("ERROR: Could not reset order status after error: " + ex.getMessage());
            }
        }

        request.setAttribute("paymentStatus", paymentStatus);
        request.setAttribute("message", message);

        // Forward to result page
        request.getRequestDispatcher("/views/payment-return.jsp").forward(request, response);
    }

    /**
     * Extract order ID from VNPay transaction reference
     * Format: ORDER{orderId}_{randomNumber}
     */
    private int extractOrderIdFromTxnRef(String txnRef) {
        try {
            if (txnRef != null && txnRef.startsWith("ORDER")) {
                String idPart = txnRef.substring(5); // Remove "ORDER" prefix
                int underscoreIndex = idPart.indexOf('_');
                if (underscoreIndex > 0) {
                    int orderId = Integer.parseInt(idPart.substring(0, underscoreIndex));
                    System.out.println("DEBUG: Extracted order ID " + orderId + " from txn ref: " + txnRef);
                    return orderId;
                }
            }
        } catch (Exception e) {
            System.err.println("ERROR: Failed to extract order ID from txn ref '" + txnRef + "': " + e.getMessage());
        }
        return 0;
    }
    
    /**
     * Get friendly error message for VNPay response codes
     */
    private String getVNPayErrorMessage(String responseCode) {
        if (responseCode == null) return "Unknown error";
        
        switch (responseCode) {
            case "07": return "Giao dịch thành công nhưng bị từ chối bởi ngân hàng";
            case "09": return "Thẻ/Tài khoản chưa đăng ký dịch vụ Internet Banking";
            case "10": return "Xác thực thông tin thẻ/tài khoản không chính xác quá 3 lần";
            case "11": return "Giao dịch hết hạn. Vui lòng thử lại";
            case "12": return "Thẻ/Tài khoản bị khóa";
            case "13": return "Mã OTP không chính xác";
            case "24": return "Giao dịch bị hủy bởi người dùng";
            case "51": return "Tài khoản không đủ số dư";
            case "65": return "Vượt quá hạn mức giao dịch";
            case "75": return "Cổng thanh toán đang bảo trì";
            case "79": return "Giao dịch hết hạn, vui lòng thử lại";
            default: return "Giao dịch thất bại";
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
