package controllers;

import dal.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            if (user.getRoleID() == 1) { // SuperAdmin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect("home");
            }
            return;
        }
        request.getRequestDispatcher("views/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO udao = new UserDAO();
        User u = udao.login(email, password);

        if (u != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", u);
            // Handle Restaurant IDs for session
            if (u.getRoleID() == 2) {
                // Owner
                dal.RestaurantDAO rdao = new dal.RestaurantDAO();
                models.Restaurant r = rdao.getRestaurantByOwnerId(u.getUserID());
                List<Integer> rList = new java.util.ArrayList<>();
                if (r != null) {
                    session.setAttribute("restaurantId", r.getRestaurantId());
                    rList.add(r.getRestaurantId());
                } else {
                    Integer restaurantId = udao.getRestaurantIdByUserId(u.getUserID());
                    if (restaurantId != null) {
                        session.setAttribute("restaurantId", restaurantId);
                        rList.add(restaurantId);
                    }
                }
                session.setAttribute("restaurantIds", rList);
            } else if (u.getRoleID() == 3) {
                // Staff
                List<Integer> restaurantIds = udao.getRestaurantIdsByUserId(u.getUserID());
                if (!restaurantIds.isEmpty()) {
                    session.setAttribute("restaurantId", restaurantIds.get(0));
                    session.setAttribute("restaurantIds", restaurantIds);
                }
            }

            // Redirect based on role
            if (u.getRoleID() == 1) { // SuperAdmin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }
}
