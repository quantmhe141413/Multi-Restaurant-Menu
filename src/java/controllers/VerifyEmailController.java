package controllers;

import dal.UserDAO;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import models.User;

@WebServlet(name = "VerifyEmailController", urlPatterns = {"/verify-email"})
public class VerifyEmailController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        HttpSession session = request.getSession();

        if (token == null || token.trim().isEmpty()) {
            session.setAttribute("message", "Invalid or missing verification token.");
            session.setAttribute("messageType", "error");
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        UserDAO userDAO = new UserDAO();
        boolean verified = userDAO.verifyEmail(token);

        if (verified) {
            session.setAttribute("message", "Your email has been successfully verified! You can now log in.");
            session.setAttribute("messageType", "success");
        } else {
            session.setAttribute("message", "Verification failed. The link may be invalid or expired.");
            session.setAttribute("messageType", "error");
        }

        response.sendRedirect(request.getContextPath() + "/login");
    }
}
