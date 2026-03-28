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

        existing.setName(name);
        existing.setAddress(address);
        existing.setPhone(phone);
        existing.setDescription(description);
        existing.setLogoUrl(logoUrl);

        restaurantDAO.updateRestaurantCoreInfo(existing);
        // Save logo URL separately
        if (logoUrl != null) {
            restaurantDAO.updateLogoAndTheme(existing.getRestaurantId(), logoUrl.trim(), existing.getThemeColor());
        }

        request.setAttribute("restaurant", existing);
        request.setAttribute("success", "Cập nhật hồ sơ nhà hàng thành công.");
        request.getRequestDispatcher("views/edit-restaurant-profile.jsp").forward(request, response);
    }
}
