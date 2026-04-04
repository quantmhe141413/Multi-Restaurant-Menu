package controllers;

import dal.RestaurantDAO;
import models.Restaurant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "EditRestaurantProfileController", urlPatterns = { "/edit-restaurant-profile" })
public class EditRestaurantProfileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login");
            return;
        }
        models.User user = (models.User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        RestaurantDAO dao = new RestaurantDAO();
        models.Restaurant r = dao.getRestaurantByOwnerId(user.getUserID());
        if (r == null) {
            // Fall back to RestaurantUsers table for managers
            dal.UserDAO userDAO = new dal.UserDAO();
            Integer restaurantId = userDAO.getRestaurantIdByUserId(user.getUserID());
            if (restaurantId != null) {
                r = dao.getRestaurantById(restaurantId);
            }
        }
        if (r != null) {
            request.setAttribute("restaurant", r);
            request.getRequestDispatcher("/views/edit-restaurant-profile.jsp").forward(request, response);
            return;
        }
        response.sendRedirect("restaurant-profile-setup");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        models.User user = (models.User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        models.Restaurant existing = restaurantDAO.getRestaurantByOwnerId(user.getUserID());
        if (existing == null) {
            // Fall back to RestaurantUsers table for managers
            dal.UserDAO userDAO = new dal.UserDAO();
            Integer restaurantId = userDAO.getRestaurantIdByUserId(user.getUserID());
            if (restaurantId != null) {
                existing = restaurantDAO.getRestaurantById(restaurantId);
            }
        }
        if (existing == null) {
            response.sendRedirect("restaurant-profile-setup");
            return;
        }

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");
        String logoUrl = request.getParameter("logoUrl");

        // Server-side validation
        String errorMsg = null;
        if (name == null || name.trim().isEmpty()) {
            errorMsg = "Tên nhà hàng không được để trống.";
        } else if (address == null || address.trim().isEmpty()) {
            errorMsg = "Địa chỉ không được để trống.";
        } else if (phone != null && !phone.matches("^0[0-9]{9}$")) {
            errorMsg = "Số điện thoại không hợp lệ (phải bắt đầu bằng 0 và có 10 chữ số).";
        } else if (description != null && description.length() > 500) {
            errorMsg = "Mô tả không được vượt quá 500 ký tự.";
        } else if (logoUrl != null && !logoUrl.isEmpty() && !logoUrl.matches("^(https?|ftp)://[^\\s/$.?#].[^\\s]*$")) {
            errorMsg = "URL ảnh không hợp lệ.";
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("restaurant", existing);
            request.getRequestDispatcher("views/edit-restaurant-profile.jsp").forward(request, response);
            return;
        }

        existing.setName(name.trim());
        existing.setAddress(address.trim());
        existing.setPhone(phone != null ? phone.trim() : "");
        existing.setDescription(description != null ? description.trim() : "");
        existing.setLogoUrl(logoUrl != null ? logoUrl.trim() : "");

        restaurantDAO.updateRestaurantCoreInfo(existing);
        // Save logo URL separately if using updateLogoAndTheme
        restaurantDAO.updateLogoAndTheme(existing.getRestaurantId(), existing.getLogoUrl(), existing.getThemeColor());

        request.setAttribute("restaurant", existing);
        request.setAttribute("success", "Cập nhật hồ sơ nhà hàng thành công.");
        request.getRequestDispatcher("views/edit-restaurant-profile.jsp").forward(request, response);
    }
}
