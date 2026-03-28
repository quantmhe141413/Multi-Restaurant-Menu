package controllers;

import dal.ComplaintDAO;
import dal.OrderDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Order;
import models.User;

@WebServlet(name = "CustomerComplaintController", urlPatterns = {"/submit-complaint"})
public class CustomerComplaintController extends HttpServlet {

    private static final int MAX_DESC = 255;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/order-history");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để gửi khiếu nại!");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        if (user.getRoleID() != 4) {
            session.setAttribute("error", "Chỉ khách hàng mới có thể gửi khiếu nại!");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        try {
            String orderIdStr = request.getParameter("orderId");
            String description = request.getParameter("description");

            if (orderIdStr == null || description == null || description.trim().isEmpty()) {
                session.setAttribute("error", "Vui lòng nhập nội dung khiếu nại!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            int orderId = Integer.parseInt(orderIdStr.trim());
            String descTrim = description.trim();
            if (descTrim.length() > MAX_DESC) {
                session.setAttribute("error", "Nội dung khiếu nại tối đa " + MAX_DESC + " ký tự.");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            OrderDAO orderDAO = new OrderDAO();
            Order order = orderDAO.getOrderById(orderId);

            if (order == null) {
                session.setAttribute("error", "Không tìm thấy đơn hàng!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            if (order.getCustomerID() != user.getUserID()) {
                session.setAttribute("error", "Đơn hàng không thuộc về bạn!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            if (!"Completed".equals(order.getOrderStatus())) {
                session.setAttribute("error", "Chỉ có thể khiếu nại đơn hàng đã hoàn thành!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            ComplaintDAO complaintDAO = new ComplaintDAO();
            if (complaintDAO.hasOrderBeenComplained(orderId)) {
                session.setAttribute("error", "Bạn đã gửi khiếu nại cho đơn hàng này rồi!");
                response.sendRedirect(request.getContextPath() + "/order-history");
                return;
            }

            boolean ok = complaintDAO.insertComplaint(orderId, user.getUserID(), descTrim);
            if (ok) {
                session.setAttribute("success", "Khiếu nại của bạn đã được gửi. Admin sẽ xử lý sớm nhất có thể.");
            } else {
                session.setAttribute("error", "Không thể gửi khiếu nại. Vui lòng thử lại!");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Dữ liệu không hợp lệ!");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra khi gửi khiếu nại!");
        }

        response.sendRedirect(request.getContextPath() + "/order-history");
    }
}
