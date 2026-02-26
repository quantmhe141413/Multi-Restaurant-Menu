package controllers;

import dal.MenuDAO;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.MenuItem;
import models.User;

@WebServlet(name = "CheckoutController", urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Kiểm tra đăng nhập
        User user = (User) session.getAttribute("user");
        if (user == null) {
            session.setAttribute("error", "Vui lòng đăng nhập để đặt hàng!");
            response.sendRedirect("login");
            return;
        }

        // Kiểm tra role - chỉ customer mới được checkout
        if (user.getRoleID() != 4) {
            session.setAttribute("error", "Chỉ khách hàng mới có thể đặt hàng!");
            response.sendRedirect("home");
            return;
        }

        // Lấy giỏ hàng từ session
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            session.setAttribute("error", "Giỏ hàng trống!");
            response.sendRedirect("cart");
            return;
        }

        try {
            // Lấy thông tin chi tiết các món ăn trong giỏ hàng
            MenuDAO menuDAO = new MenuDAO();
            Map<MenuItem, Integer> cartItems = new HashMap<>();
            double totalAmount = 0;
            int restaurantId = 0;

            for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
                MenuItem item = menuDAO.getMenuItemById(entry.getKey());
                if (item != null && item.isIsAvailable()) {
                    cartItems.put(item, entry.getValue());
                    totalAmount += item.getPrice() * entry.getValue();
                    if (restaurantId == 0) {
                        restaurantId = item.getRestaurantID();
                    }
                }
            }

            if (cartItems.isEmpty()) {
                session.setAttribute("error", "Không có món ăn hợp lệ trong giỏ hàng!");
                response.sendRedirect("cart");
                return;
            }

            request.setAttribute("cartItems", cartItems);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("restaurantId", restaurantId);
            
            request.getRequestDispatcher("views/checkout.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect("cart");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
