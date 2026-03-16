package controllers;

import dal.OrderDAO;
import models.Order;
import models.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "OrderManagementController", urlPatterns = {"/order-management"})
public class OrderManagementController extends HttpServlet {

    private static final int PAGE_SIZE = 15;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        if (user.getRoleID() != 3) {
            session.setAttribute("toastMessage", "You don't have permission to view order management");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        if (restaurantId == null) {
            session.setAttribute("toastMessage", "You must be assigned to a restaurant to manage orders");
            session.setAttribute("toastType", "error");
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null && !pageStr.isEmpty()) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }

        OrderDAO orderDAO = new OrderDAO();
        List<Order> orders = orderDAO.getOrdersByRestaurant(restaurantId, page, PAGE_SIZE);
        int totalOrders = orderDAO.countOrdersByRestaurant(restaurantId);
        int totalPages = (int) Math.ceil((double) totalOrders / PAGE_SIZE);

        request.setAttribute("orders", orders);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalOrders", totalOrders);

        request.getRequestDispatcher("/views/owner/order-list.jsp").forward(request, response);
    }
}
