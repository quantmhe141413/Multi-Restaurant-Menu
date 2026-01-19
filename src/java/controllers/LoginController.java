package controllers;

import dao.UserDAO;
import models.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class LoginController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to login page
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Validate input
        if (username == null || username.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Username and password are required");
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }
        
        // Validate credentials
        User user = userDAO.validateLogin(username, password);
        
        if (user != null) {
            // Login successful
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("role", user.getRole());
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("fullName", user.getFullName());
            
            // Set session timeout (30 minutes)
            session.setMaxInactiveInterval(30 * 60);
            
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            // Login failed
            request.setAttribute("error", "Invalid username or password");
            request.setAttribute("username", username);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
        }
    }
}
