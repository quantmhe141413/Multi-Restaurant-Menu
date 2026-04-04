package controllers;

import dal.UserDAO;
import dal.RestaurantDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name = "RegisterController", urlPatterns = { "/register" })
public class RegisterController extends HttpServlet {


    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect("home");
            return;
        }
        request.getRequestDispatcher("views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");
        String roleIDParam = request.getParameter("roleID");

        // Server-side validation
        String errorMsg = null;
        if (fullName == null || fullName.trim().length() < 3) {
            errorMsg = "Full name must be at least 3 characters.";
        } else if (email == null || !email.matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            errorMsg = "Invalid email format.";
        } else if (password == null || password.length() < 6) {
            errorMsg = "Password must be at least 6 characters.";
        } else if (!password.equals(confirmPassword)) {
            errorMsg = "Passwords do not match.";
        } else if (phone == null || !phone.matches("^\\d{8,}$")) {
            errorMsg = "Invalid phone number (minimum 8 digits).";
        }

        // Validate roleID: only allow 2 (Owner) or 4 (Customer) to prevent manipulation
        int roleID = 4; // default to Customer
        if ("2".equals(roleIDParam)) {
            roleID = 2; // Restaurant Owner
            // Additional validation for Owners could go here (e.g. restaurant info)
        }

        if (errorMsg != null) {
            request.setAttribute("error", errorMsg);
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        UserDAO udao = new UserDAO();
        if (udao.checkEmailExists(email.trim())) {
            request.setAttribute("error", "Email already exists!");
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setFullName(fullName.trim());
        u.setEmail(email.trim());
        u.setPasswordHash(password); // TODO: hash before storing
        u.setPhone(phone.trim());
        u.setRoleID(roleID);

        int newUserId = udao.register(u);
        if (newUserId > 0) {
            if (roleID == 2) {
                // Also create the restaurant record
                String rName = request.getParameter("restaurantName");
                String rAddress = request.getParameter("restaurantAddress");
                String rPhone = request.getParameter("restaurantPhone");
                String rDescription = request.getParameter("restaurantDescription");

                models.Restaurant restaurant = new models.Restaurant();
                restaurant.setOwnerId(newUserId);
                restaurant.setName(rName != null ? rName.trim() : "");
                restaurant.setAddress(rAddress != null ? rAddress.trim() : "");
                restaurant.setPhone(rPhone != null ? rPhone.trim() : "");
                restaurant.setDescription(rDescription != null ? rDescription.trim() : "");
                
                RestaurantDAO rdao = new RestaurantDAO();
                rdao.insertRestaurant(restaurant);
            }
            response.sendRedirect("login?registered=1");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }
}
