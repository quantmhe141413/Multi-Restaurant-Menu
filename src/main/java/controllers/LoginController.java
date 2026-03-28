package controllers;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import constants.UserRole;
import models.User;

@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            // Redirect all users to home
            // response.sendRedirect("home");
            User currentUser = (User) session.getAttribute("user");
            redirectByRole(currentUser, request, response);
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
            if (u.getRoleID() == 2 || u.getRoleID() == 3) {
                Integer restaurantId = udao.getRestaurantIdByUserId(u.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }

            // Redirect all users to home
            //response.sendRedirect("home");
            // Redirect by role after successful login
            redirectByRole(u, request, response);

        } else {
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }

    private void redirectByRole(User user, HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int roleId = user.getRoleID();
        
        // Role 1: Super Admin -> Admin Dashboard
        if (roleId == UserRole.SUPER_ADMIN) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            return;
        }
        
        // Role 2: Owner -> Management Dashboard
        if (roleId == UserRole.OWNER) {
            response.sendRedirect(request.getContextPath() + "/restaurant-analytics-dashboard");
            return;
        }
        
        // Role 3: Staff -> Staff Home (POS System)
        if (roleId == UserRole.STAFF) {
            response.sendRedirect(request.getContextPath() + "/staff/home");
            return;
        }
        
        // Role 4: Customer -> Home
        if (roleId == UserRole.CUSTOMER) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Default: Home
        response.sendRedirect(request.getContextPath() + "/home");
    }
}
