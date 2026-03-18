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

@WebServlet(name = "RestaurantProfileSetupController", urlPatterns = { "/restaurant-profile-setup" })
public class RestaurantProfileSetupController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/restaurant-profile-setup.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer ownerId = (Integer) session.getAttribute("userId");
        if (ownerId == null) {
            response.sendRedirect("login");
            return;
        }
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");
        // Add more fields as needed

        Restaurant restaurant = new Restaurant();
        restaurant.setOwnerId(ownerId);
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setDescription(description);

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        restaurantDAO.insertRestaurant(restaurant);

        // Fetch newly created restaurant to set session if role is Owner.
        models.Restaurant created = restaurantDAO.getRestaurantByOwnerId(ownerId);
        if (created != null) {
            session.setAttribute("restaurantId", created.getRestaurantId());
        }

        request.setAttribute("success", "Thiết lập hồ sơ nhà hàng thành công.");
        request.getRequestDispatcher("views/restaurant-profile-setup.jsp").forward(request, response);
    }
}
