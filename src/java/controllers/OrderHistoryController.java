package controllers;

import dal.MenuDAO;
import dal.OrderDAO;
import dal.RestaurantDAO;
import dal.ReviewDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MenuItem;
import models.Order;
import models.OrderItem;
import models.Restaurant;
import models.User;

@WebServlet(name = "OrderHistoryController", urlPatterns = { "/order-history" })
public class OrderHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Kiểm tra đăng nhập
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để xem lịch sử đơn hàng!");
            response.sendRedirect("login");
            return;
        }

        // Kiểm tra role - chỉ customer mới có order history
        if (user.getRoleID() != 4) {
            session.setAttribute("error", "Chỉ khách hàng mới có lịch sử đơn hàng!");
            response.sendRedirect("home");
            return;
        }

        try {
            OrderDAO orderDAO = new OrderDAO();
            MenuDAO menuDAO = new MenuDAO();
            RestaurantDAO restaurantDAO = new RestaurantDAO();

            // Lấy danh sách đơn hàng của customer
            List<Order> orders = orderDAO.getOrdersByCustomer(user.getUserID());

            // Tạo map để lưu thông tin chi tiết cho mỗi đơn hàng
            Map<Integer, List<OrderItem>> orderItemsMap = new HashMap<>();
            Map<Integer, Restaurant> restaurantMap = new HashMap<>();
            Map<Integer, MenuItem> menuItemMap = new HashMap<>();

            for (Order order : orders) {
                // Lấy các items của đơn hàng
                List<OrderItem> items = orderDAO.getOrderItemsByOrderId(order.getOrderID());
                orderItemsMap.put(order.getOrderID(), items);

                // Lấy thông tin restaurant
                if (!restaurantMap.containsKey(order.getRestaurantID())) {
                    Restaurant restaurant = restaurantDAO.getRestaurantById(order.getRestaurantID());
                    if (restaurant != null) {
                        restaurantMap.put(order.getRestaurantID(), restaurant);
                    }
                }

                // Lấy thông tin các món ăn
                for (OrderItem item : items) {
                    if (!menuItemMap.containsKey(item.getItemID())) {
                        MenuItem menuItem = menuDAO.getMenuItemById(item.getItemID());
                        if (menuItem != null) {
                            menuItemMap.put(item.getItemID(), menuItem);
                        }
                    }
                }
            }

            // Kiểm tra đơn hàng nào đã được đánh giá
            ReviewDAO reviewDAO = new ReviewDAO();
            Set<Integer> reviewedOrders = new HashSet<>();
            for (Order order : orders) {
                if ("Completed".equals(order.getOrderStatus())) {
                    if (reviewDAO.hasOrderBeenReviewed(order.getOrderID())) {
                        reviewedOrders.add(order.getOrderID());
                    }
                }
            }

            request.setAttribute("orders", orders);
            request.setAttribute("orderItemsMap", orderItemsMap);
            request.setAttribute("restaurantMap", restaurantMap);
            request.setAttribute("menuItemMap", menuItemMap);
            request.setAttribute("reviewedOrders", reviewedOrders);

            request.getRequestDispatcher("views/order-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra khi tải lịch sử đơn hàng!");
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
