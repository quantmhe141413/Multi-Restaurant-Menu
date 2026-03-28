package controllers;

import dal.OrderDAO;
import dal.ReviewDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;

@WebServlet(name = "ReviewController", urlPatterns = { "/review" })
public class ReviewController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        // Kiểm tra đăng nhập
        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để đánh giá!");
            response.sendRedirect("login");
            return;
        }

        try {
            // Get parameters
            String orderIdStr = request.getParameter("orderId");
            String restaurantIdStr = request.getParameter("restaurantId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            // Debug logging
            System.out.println("Review submission - orderId: " + orderIdStr + ", restaurantId: " + restaurantIdStr + ", rating: " + ratingStr);

            // Validate parameters - OrderID is required
            if (orderIdStr == null || restaurantIdStr == null || ratingStr == null) {
                session.setAttribute("error", "Thiếu thông tin đánh giá!");
                response.sendRedirect("order-history");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr);
            int restaurantId = Integer.parseInt(restaurantIdStr);
            int rating = Integer.parseInt(ratingStr);

            // Validate rating 1-5
            if (rating < 1 || rating > 5) {
                session.setAttribute("error", "Đánh giá phải từ 1 đến 5 sao!");
                response.sendRedirect("order-history");
                return;
            }

            // Validate comment
            if (comment == null || comment.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập nhận xét của bạn!");
                response.sendRedirect("order-history");
                return;
            }

            // Kiểm tra đơn hàng thuộc về customer này và đã Completed
            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);
            
            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect("order-history");
                return;
            }
            
            if (order.getCustomerID() != user.getUserID()) {
                session.setAttribute("error", "Đơn hàng không thuộc về bạn!");
                response.sendRedirect("order-history");
                return;
            }
            
            if (!"Completed".equals(order.getOrderStatus())) {
                session.setAttribute("error", "Chỉ có thể đánh giá đơn hàng đã hoàn thành!");
                response.sendRedirect("order-history");
                return;
            }

            // Kiểm tra đã đánh giá đơn hàng này chưa
            ReviewDAO reviewDAO = new ReviewDAO();
            if (reviewDAO.hasOrderBeenReviewed(orderId)) {
                session.setAttribute("error", "Bạn đã đánh giá đơn hàng này rồi!");
                response.sendRedirect("order-history");
                return;
            }

            // Lưu đánh giá
            System.out.println("Attempting to insert review...");
            boolean success = reviewDAO.insertReview(restaurantId, user.getUserID(), orderId, rating, comment);
            System.out.println("Insert review result: " + success);
            
            if (success) {
                session.setAttribute("success", "Cảm ơn bạn đã đánh giá! Đánh giá của bạn đã được ghi nhận.");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi gửi đánh giá. Vui lòng thử lại!");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            session.setAttribute("error", "Dữ liệu không hợp lệ: " + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }

        response.sendRedirect("order-history");
    }
}
