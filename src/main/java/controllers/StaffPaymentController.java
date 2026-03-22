package controllers;

import dal.OrderDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import utils.VNPayConfig;
import org.json.JSONObject;

import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;

@WebServlet(name = "StaffPaymentController", urlPatterns = {"/staff/payment/vnpay"})
public class StaffPaymentController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        JSONObject json = new JSONObject();

        try {
            HttpSession session = request.getSession();
            Integer restaurantId = (Integer) session.getAttribute("restaurantId");

            if (restaurantId == null) {
                json.put("success", false);
                json.put("message", "Vui lòng đăng nhập");
                out.print(json.toString());
                return;
            }

            String tableIdParam = request.getParameter("tableId");
            String amountParam = request.getParameter("amount");
            String orderInfo = request.getParameter("orderInfo");

            if (tableIdParam == null || amountParam == null) {
                json.put("success", false);
                json.put("message", "Thiếu thông tin");
                out.print(json.toString());
                return;
            }

            int tableId = Integer.parseInt(tableIdParam);
            double amount = Double.parseDouble(amountParam);

            // VNPay payment parameters
            String vnp_Version = "2.1.0";
            String vnp_Command = "pay";
            
            // Amount in VND cents (multiply by 100)
            long vnpAmount = (long) (amount * 100);

            // Generate unique transaction reference
            String vnp_TxnRef = "TABLE" + tableId + "_" + VNPayConfig.getRandomNumber(8);
            String vnp_IpAddr = VNPayConfig.getIpAddress(request);
            String vnp_TmnCode = VNPayConfig.vnp_TmnCode;

            // Build VNPay parameters
            Map<String, String> vnp_Params = new HashMap<>();
            vnp_Params.put("vnp_Version", vnp_Version);
            vnp_Params.put("vnp_Command", vnp_Command);
            vnp_Params.put("vnp_TmnCode", vnp_TmnCode);
            vnp_Params.put("vnp_Amount", String.valueOf(vnpAmount));
            vnp_Params.put("vnp_CurrCode", "VND");
            vnp_Params.put("vnp_TxnRef", vnp_TxnRef);
            vnp_Params.put("vnp_OrderInfo", orderInfo != null ? orderInfo : "Thanh toan ban " + tableId);
            vnp_Params.put("vnp_OrderType", "other");
            vnp_Params.put("vnp_Locale", "vn");
            vnp_Params.put("vnp_ReturnUrl", VNPayConfig.getReturnUrl(request));
            vnp_Params.put("vnp_IpAddr", vnp_IpAddr);

            // Create date
            Calendar cld = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
            SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
            String vnp_CreateDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_CreateDate", vnp_CreateDate);

            // Expire date (15 minutes)
            cld.add(Calendar.MINUTE, 15);
            String vnp_ExpireDate = formatter.format(cld.getTime());
            vnp_Params.put("vnp_ExpireDate", vnp_ExpireDate);

            // Build query string
            List<String> fieldNames = new ArrayList<>(vnp_Params.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();

            Iterator<String> itr = fieldNames.iterator();
            while (itr.hasNext()) {
                String fieldName = itr.next();
                String fieldValue = vnp_Params.get(fieldName);
                if (fieldValue != null && !fieldValue.isEmpty()) {
                    hashData.append(fieldName).append('=').append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII))
                         .append('=')
                         .append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }

            String queryUrl = query.toString();
            String vnp_SecureHash = VNPayConfig.hmacSHA512(VNPayConfig.secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnp_SecureHash;
            String paymentUrl = VNPayConfig.vnp_PayUrl + "?" + queryUrl;

            json.put("success", true);
            json.put("paymentUrl", paymentUrl);

        } catch (Exception e) {
            json.put("success", false);
            json.put("message", "Lỗi hệ thống: " + e.getMessage());
            e.printStackTrace();
        }

        out.print(json.toString());
        out.flush();
    }
}
