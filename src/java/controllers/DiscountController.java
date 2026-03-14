package controllers;

import dal.DiscountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Discount;

/**
 * AJAX endpoint for validating discount codes on the checkout page.
 * POST /apply-discount
 *   Params: discountCode (String), restaurantId (int), totalAmount (double)
 *   Returns JSON: { valid, discountType, discountValue, discountAmount, finalAmount, message }
 */
@WebServlet(name = "DiscountController", urlPatterns = {"/apply-discount"})
public class DiscountController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();

        String code = request.getParameter("discountCode");
        String restaurantIdStr = request.getParameter("restaurantId");
        String totalAmountStr = request.getParameter("totalAmount");

        if (code == null || code.trim().isEmpty()
                || restaurantIdStr == null || totalAmountStr == null) {
            out.print("{\"valid\":false,\"message\":\"Thông tin không hợp lệ!\"}");
            return;
        }

        try {
            int restaurantId = Integer.parseInt(restaurantIdStr);
            double totalAmount = Double.parseDouble(totalAmountStr);

            DiscountDAO dao = new DiscountDAO();
            Discount discount = dao.findValidDiscount(code.trim(), restaurantId);

            if (discount == null) {
                out.print("{\"valid\":false,\"message\":\"Mã giảm giá không hợp lệ hoặc đã hết hạn!\"}");
                return;
            }

            if (discount.getQuantity() <= 0) {
                out.print("{\"valid\":false,\"message\":\"Mã giảm giá đã hết lượt sử dụng!\"}");
                return;
            }

            if (discount.getMinOrderAmount() != null && totalAmount < discount.getMinOrderAmount()) {
                out.print("{\"valid\":false,\"message\":\"Đơn hàng chưa đạt giá trị tối thiểu để áp dụng mã này!\"}");
                return;
            }

            models.User user = (models.User) request.getSession().getAttribute("user");
            if (user != null && discount.getUsageLimitPerUser() > 0) {
                int usedCount = dao.countUserUsage(discount.getDiscountID(), user.getUserID());
                if (usedCount >= discount.getUsageLimitPerUser()) {
                    out.print("{\"valid\":false,\"message\":\"Bạn đã hết lượt sử dụng mã này!\"}");
                    return;
                }
            }

            double discountAmount;
            if ("Percentage".equalsIgnoreCase(discount.getDiscountType())) {
                discountAmount = totalAmount * discount.getDiscountValue() / 100.0;
                if (discount.getMaxDiscountAmount() != null && discount.getMaxDiscountAmount() > 0 && discountAmount > discount.getMaxDiscountAmount()) {
                    discountAmount = discount.getMaxDiscountAmount();
                }
            } else {
                // Fixed
                discountAmount = discount.getDiscountValue();
            }
            // Discount cannot exceed the order total
            if (discountAmount > totalAmount) {
                discountAmount = totalAmount;
            }
            double finalAmount = totalAmount - discountAmount;

            String scope = (discount.getRestaurantID() == 0)
                    ? "Toàn nền tảng" : "Nhà hàng";

            out.print("{\"valid\":true,"
                    + "\"discountID\":" + discount.getDiscountID() + ","
                    + "\"discountType\":\"" + discount.getDiscountType() + "\","
                    + "\"discountValue\":" + discount.getDiscountValue() + ","
                    + "\"discountAmount\":" + discountAmount + ","
                    + "\"finalAmount\":" + finalAmount + ","
                    + "\"scope\":\"" + scope + "\","
                    + "\"message\":\"Áp dụng mã giảm giá thành công!\"}");

        } catch (NumberFormatException e) {
            out.print("{\"valid\":false,\"message\":\"Dữ liệu không hợp lệ!\"}");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}

