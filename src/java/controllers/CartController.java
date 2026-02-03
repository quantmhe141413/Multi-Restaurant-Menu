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

@WebServlet(name = "CartController", urlPatterns = { "/cart" })
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Kiểm tra đăng nhập
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy giỏ hàng từ session
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        // Lấy thông tin chi tiết các món ăn trong giỏ hàng
        MenuDAO menuDAO = new MenuDAO();
        Map<MenuItem, Integer> cartItems = new HashMap<>();
        double totalAmount = 0;
        
        for (Map.Entry<Integer, Integer> entry : cart.entrySet()) {
            MenuItem item = menuDAO.getMenuItemById(entry.getKey());
            if (item != null) {
                int quantity = entry.getValue();
                cartItems.put(item, quantity);
                totalAmount += item.getPrice() * quantity;
            }
        }

        request.setAttribute("cartItems", cartItems);
        request.setAttribute("totalAmount", totalAmount);
        request.getRequestDispatcher("views/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();
        
        // Kiểm tra đăng nhập
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        // Lấy giỏ hàng từ session
        Map<Integer, Integer> cart = (Map<Integer, Integer>) session.getAttribute("cart");
        if (cart == null) {
            cart = new HashMap<>();
            session.setAttribute("cart", cart);
        }

        if ("add".equals(action)) {
            // Thêm món vào giỏ hàng
            String itemIdStr = request.getParameter("itemId");
            String quantityStr = request.getParameter("quantity");
            
            if (itemIdStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    int quantity = 1;
                    if (quantityStr != null && !quantityStr.trim().isEmpty()) {
                        quantity = Integer.parseInt(quantityStr);
                    }
                    
                    // Kiểm tra xem món ăn có tồn tại không
                    MenuDAO menuDAO = new MenuDAO();
                    MenuItem item = menuDAO.getMenuItemById(itemId);
                    if (item != null && item.isIsAvailable()) {
                        // Kiểm tra xem giỏ hàng đã có món từ nhà hàng khác chưa
                        if (!cart.isEmpty()) {
                            MenuItem existingItem = menuDAO.getMenuItemById(cart.keySet().iterator().next());
                            if (existingItem != null && existingItem.getRestaurantID() != item.getRestaurantID()) {
                                session.setAttribute("error", "Bạn chỉ có thể đặt món từ một nhà hàng trong một đơn hàng!");
                                response.sendRedirect("menu?restaurantId=" + item.getRestaurantID());
                                return;
                            }
                        }
                        
                        // Thêm hoặc cập nhật số lượng
                        cart.put(itemId, cart.getOrDefault(itemId, 0) + quantity);
                        session.setAttribute("cart", cart);
                        session.setAttribute("success", "Đã thêm vào giỏ hàng!");
                    }
                    
                    String restaurantId = request.getParameter("restaurantId");
                    if (restaurantId != null) {
                        response.sendRedirect("menu?restaurantId=" + restaurantId);
                    } else {
                        response.sendRedirect("cart");
                    }
                } catch (NumberFormatException e) {
                    response.sendRedirect("home");
                }
            }
        } else if ("update".equals(action)) {
            // Cập nhật số lượng
            String itemIdStr = request.getParameter("itemId");
            String quantityStr = request.getParameter("quantity");
            
            if (itemIdStr != null && quantityStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    int quantity = Integer.parseInt(quantityStr);
                    
                    if (quantity > 0) {
                        cart.put(itemId, quantity);
                    } else {
                        cart.remove(itemId);
                    }
                    session.setAttribute("cart", cart);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect("cart");
        } else if ("remove".equals(action)) {
            // Xóa món khỏi giỏ hàng
            String itemIdStr = request.getParameter("itemId");
            if (itemIdStr != null) {
                try {
                    int itemId = Integer.parseInt(itemIdStr);
                    cart.remove(itemId);
                    session.setAttribute("cart", cart);
                } catch (NumberFormatException e) {
                    // Ignore
                }
            }
            response.sendRedirect("cart");
        } else if ("clear".equals(action)) {
            // Xóa toàn bộ giỏ hàng
            cart.clear();
            session.setAttribute("cart", cart);
            response.sendRedirect("cart");
        } else {
            response.sendRedirect("cart");
        }
    }
}
