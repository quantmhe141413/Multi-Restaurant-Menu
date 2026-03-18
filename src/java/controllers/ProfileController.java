package controllers;

import dal.RestaurantDAO;
import dal.UserDAO;
import models.Restaurant;
import models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ProfileController", urlPatterns = { "/profile" })
public class ProfileController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        RestaurantDAO restaurantDAO = new RestaurantDAO();

        // If user is an Owner (RoleID = 2) or Staff (RoleID = 3), get their restaurant
        if (user.getRoleID() == 2 || user.getRoleID() == 3) {
            Integer restaurantId = userDAO.getRestaurantIdByUserId(user.getUserID());
            if (restaurantId != null) {
                Restaurant restaurant = restaurantDAO.getRestaurantById(restaurantId);
                request.setAttribute("restaurant", restaurant);
            }
        }

        request.getRequestDispatcher("views/profile.jsp").forward(request, response);
    }
}
