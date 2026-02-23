package controllers;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;
import util.VNPayConfig;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        
        // Check authentication
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để thanh toán!");
            response.sendRedirect("login");
            return;
        }

        try {
            // Get order ID from request
            String orderIdStr = request.getParameter("orderId");
            if (orderIdStr == null || orderIdStr.isEmpty()) {
                session.setAttribute("error", "Order ID is required");
                response.sendRedirect("cart");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);

            // Get order details
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                session.setAttribute("error", "Order not found");
                response.sendRedirect("cart");
                return;
            }

            // Check if order belongs to user
            if (order.getCustomerID() != user.getUserID()) {
                session.setAttribute("error", "Unauthorized access");
                response.sendRedirect("home");
                return;
            }

            // Check if order is already paid
            if ("Paid".equals(order.getPaymentStatus())) {
                session.setAttribute("error", "Order has already been paid");
                response.sendRedirect("home");
                return;
            }

            // VNPay payment parameters
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            String orderType = "other";

            // Amount in VND cents (multiply by 100)
            long amount = (long) (order.getFinalAmount() * 100);

            // Generate unique transaction reference
            String vnp_TxnRef = "ORDER" + orderId + "_" + VNPayConfig.getRandomNumber(8);
            String vnp_IpAddr = VNPayConfig.getIpAddress(request);
            String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

            // Build VNPay parameters
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(amount));
            vnp_Params.put("vnp_CurrCode", "VND");

            String bankCode = request.getParameter("bankCode");
            if (bankCode != null && !bankCode.trim().isEmpty()) {
                vnp_Params.put("vnp_BankCode", bankCode.trim());
            }

            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", "Thanh toan don hang #" + orderId + " - " + user.getFullName());
            vnp_Params.put("vnp_OrderType", orderType);

            String locale = request.getParameter("language");
            if (locale != null && !locale.isEmpty()) {
                vnp_Params.put("vnp_Locale", locale);
            } else {
                vnp_Params.put("vnp_Locale", "vn");
            }

            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.getReturnUrl(request));
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            // Set expiry time (15 minutes)
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            // Build query string and hash
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            
            List<String> hashDataList = new ArrayList<>();
            List<String> queryList = new ArrayList<>();

            for (String fieldName : fieldNames) {
                String fieldValue = vnp_Params.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    hashDataList.add(fieldName + "=" + URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                    queryList.add(URLEncoder.encode(fieldName, StandardCharsets.UTF_8.toString()) 
                                + "=" 
                                + URLEncoder.encode(fieldValue, StandardCharsets.UTF_8.toString()));
                }
            }

            String hashData = String.join("&", hashDataList);
            String queryUrl = String.join("&", queryList);
            
            System.out.println("=== VNPay Payment Debug ===");
            System.out.println("Order ID: " + orderId);
            System.out.println("Amount: " + amount);
            System.out.println("Hash Data: " + hashData);
            
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData);
            System.out.println("Secure Hash: " + vnp_SecureHash);
            
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;
            
            System.out.println("Payment URL: " + paymentUrl);
            System.out.println("=========================");

            // Save payment record as pending
            try {
                orderDAO.createPayment(orderId, user.getUserID(), "VNPay", vnp_TxnRef, amount);
                
                // Update order payment status to pending
                orderDAO.updateOrderPaymentStatus(orderId, "Pending", null);
                
                System.out.println("Payment record created for order #" + orderId);
            } catch (SQLException e) {
                session.setAttribute("error", "Failed to create payment record: " + e.getMessage());
                response.sendRedirect("cart");
                return;
            }

            // Redirect to VNPay payment gateway
            response.sendRedirect(paymentUrl);

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Invalid order ID");
            response.sendRedirect("cart");
        } catch (Exception e) {
            session.setAttribute("error", "Payment error: " + e.getMessage());
            response.sendRedirect("cart");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Support GET requests for redirects from OrderController
        doPost(request, response);
    }
}
