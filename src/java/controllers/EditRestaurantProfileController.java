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
        if (session != null) {
            models.User user = (models.User) session.getAttribute("user");
            if (user != null) {
                RestaurantDAO dao = new RestaurantDAO();
                models.Restaurant r = dao.getRestaurantByOwnerId(user.getUserID());
                if (r != null) {
                    request.setAttribute("restaurant", r);
                    request.getRequestDispatcher("views/edit-restaurant-profile.jsp").forward(request, response);
                    return;
                }
            }
        }
        response.sendRedirect("login");
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
        Integer ownerId = user.getUserID();

        RestaurantDAO restaurantDAO = new RestaurantDAO();
        models.Restaurant existing = restaurantDAO.getRestaurantByOwnerId(ownerId);
        if (existing == null) {
            response.sendRedirect("restaurant-profile-setup");
            return;
        }

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String description = request.getParameter("description");

        existing.setName(name);
        existing.setAddress(address);
        existing.setPhone(phone);
        existing.setDescription(description);

        restaurantDAO.updateRestaurantCoreInfo(existing);

        request.setAttribute("restaurant", existing);
        request.setAttribute("success", "Cập nhật hồ sơ nhà hàng thành công.");
        request.getRequestDispatcher("views/edit-restaurant-profile.jsp").forward(request, response);
    }
}
