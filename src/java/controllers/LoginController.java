package controllers;

import dal.UserDAO;
import java.io.IOException;
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
            
            // Get RestaurantID for Owner (RoleID = 2) and Staff (RoleID = 3)
            // SuperAdmin (RoleID = 1) and Customer (RoleID = 4) will have restaurantId = null
            if (u.getRoleID() == 2 || u.getRoleID() == 3) {
                Integer restaurantId = udao.getRestaurantIdByUserId(u.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }
            
            response.sendRedirect("home");
        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }
}
