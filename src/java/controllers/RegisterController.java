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
        final int customerRoleId = 4;

        UserDAO udao = new UserDAO();
        if (udao.checkEmailExists(email)) {
            request.setAttribute("error", "Email already exists!");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
            return;
        }

        User u = new User();
        u.setFullName(fullName);
        u.setEmail(email);
        u.setPasswordHash(password); // TODO: hash before storing
        u.setPhone(phone);
        u.setRoleID(customerRoleId);

        if (udao.register(u)) {
            response.sendRedirect("login?registered=1");
        } else {
            request.setAttribute("error", "Registration failed! Please try again.");
            request.getRequestDispatcher("views/register.jsp").forward(request, response);
        }
    }
}
