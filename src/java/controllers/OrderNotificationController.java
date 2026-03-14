package controllers;

import dal.OrderDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import models.User;

@WebServlet(name = "OrderNotificationController", urlPatterns = {"/restaurant/order-notifications"})
public class OrderNotificationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession(false);
        try (PrintWriter out = response.getWriter()) {
            User user = session != null ? (User) session.getAttribute("user") : null;

            if (user == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                out.write("{\"success\":false,\"message\":\"Not authenticated\"}");
                return;
            }

            // Only Owner (2) and Staff (3) receive restaurant order notifications
            if (user.getRoleID() != 2 && user.getRoleID() != 3) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                out.write("{\"success\":false,\"message\":\"Not allowed\"}");
                return;
            }

            UserDAO userDao = new UserDAO();
            Integer restaurantId = userDao.getRestaurantIdByUserId(user.getUserID());

            if (restaurantId == null) {
                out.write("{\"success\":false,\"message\":\"User not linked to any restaurant\"}");
                return;
            }

            int lastOrderId = 0;
            String lastOrderIdParam = request.getParameter("lastOrderId");
            if (lastOrderIdParam != null) {
                try {
                    lastOrderId = Integer.parseInt(lastOrderIdParam);
                    if (lastOrderId < 0) {
                        lastOrderId = 0;
                    }
                } catch (NumberFormatException ignore) {
                    lastOrderId = 0;
                }
            }

            OrderDAO orderDao = new OrderDAO();
            int latestOrderId = orderDao.getLatestOrderIdForRestaurant(restaurantId);
            int newOrdersCount = 0;

            if (latestOrderId > lastOrderId) {
                newOrdersCount = orderDao.countNewPreparingOrdersSince(restaurantId, lastOrderId);
            }

            boolean hasNew = newOrdersCount > 0;

            StringBuilder json = new StringBuilder();
            json.append("{");
            json.append("\"success\":true,");
            json.append("\"hasNew\":").append(hasNew).append(",");
            json.append("\"newOrdersCount\":").append(newOrdersCount).append(",");
            json.append("\"latestOrderId\":").append(latestOrderId);
            json.append("}");

            out.write(json.toString());
        } catch (Exception ex) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            try (PrintWriter out = response.getWriter()) {
                out.write("{\"success\":false,\"message\":\"Server error\"}");
            }
        }
    }
}

