package controllers;

// DAO for user authentication and related queries
import dal.UserDAO;

import java.io.IOException;

// Servlet libraries
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// User model
import models.User;

// Map URL: /login
@WebServlet(name = "LoginController", urlPatterns = { "/login" })
public class LoginController extends HttpServlet {

    /**
     * Handle GET request:
     * - If user already logged in → redirect based on role
     * - Otherwise → show login page
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get existing session (do not create new)
        HttpSession session = request.getSession(false);

        // If session exists and user already logged in
        if (session != null && session.getAttribute("user") != null) {

            User user = (User) session.getAttribute("user");

            // Redirect user based on role
            if (user.getRoleID() == 1) { // Admin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (user.getRoleID() == 2) { // Owner
                response.sendRedirect(request.getContextPath() + "/owner/order-history");
            } else if (user.getRoleID() == 3) { // Staff
                response.sendRedirect(request.getContextPath() + "/staff/home");
            } else { // Customer
                response.sendRedirect("home");
            }
            return;
        }

        // If not logged in → show login page
        request.getRequestDispatcher("views/login.jsp").forward(request, response);
    }

    /**
     * Handle POST request:
     * - Process login form submission
     * - Authenticate user
     * - Create session and redirect based on role
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get login parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserDAO udao = new UserDAO();

        // Authenticate user
        User u = udao.login(email, password);

        if (u != null) {

            // Create new session
            HttpSession session = request.getSession();
            session.setAttribute("user", u);

            // If user is Owner or Staff → store restaurantId in session
            if (u.getRoleID() == 2 || u.getRoleID() == 3) {
                Integer restaurantId = udao.getRestaurantIdByUserId(u.getUserID());
                if (restaurantId != null) {
                    session.setAttribute("restaurantId", restaurantId);
                }
            }

            // Redirect user based on role
            if (u.getRoleID() == 1) { // Admin
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else if (u.getRoleID() == 2) { // Owner
                response.sendRedirect(request.getContextPath() + "/owner/order-history");
            } else if (u.getRoleID() == 3) { // Staff
                response.sendRedirect(request.getContextPath() + "/staff/home");
            } else { // Customer
                response.sendRedirect("home");
            }

        } else {
            // Authentication failed → return to login page with error
            request.setAttribute("error", "Invalid email or password!");
            request.getRequestDispatcher("views/login.jsp").forward(request, response);
        }
    }
}