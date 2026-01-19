package controllers;

import dao.UserDAO;
import models.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class RegisterController extends HttpServlet {
    
    private UserDAO userDAO = new UserDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Show registration form
        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Get form parameters
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        
        // Validate input
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all required fields!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check if passwords match
        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        // Check if username already exists
        User existingUser = userDAO.getUserByUsername(username);
        if (existingUser != null) {
            request.setAttribute("error", "Username already exists! Please choose another username.");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }
        
        // Create new user with reader role
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password); // In production, should hash password
        newUser.setRole("reader"); // Default role for registration
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setPhone(phone);
        newUser.setStatus(true); // Active by default
        
        // Save to database
        if (userDAO.createUser(newUser)) {
            // Registration successful, redirect to login with success message
            response.sendRedirect(request.getContextPath() + "/login?registered=success");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.setAttribute("username", username);
            request.setAttribute("fullName", fullName);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
        }
    }
}
