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
        String phone = request.getParameter("phone");
        String roleIDParam = request.getParameter("roleID");

        // Validate roleID: only allow 2 (Owner) or 4 (Customer) to prevent manipulation
        int roleID = 4; // default to Customer
        if ("2".equals(roleIDParam)) {
            roleID = 2; // Restaurant Owner
        }

        UserDAO udao = new UserDAO();
        if (udao.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            // Preserve the role so the form re-renders correctly
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPasswordHash(password); // TODO: hash before storing
        u.setPhone(phone);
        u.setRoleID(roleID);

        if (udao.register(u)) {
            response.sendRedirect("login?registered=1");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.setAttribute("initialRole", roleID == 2 ? "owner" : "customer");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }
}
