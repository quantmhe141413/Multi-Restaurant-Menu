package controllers;

import dal.UserDAO;
import utils.EmailService;
import java.io.IOException;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "ForgotPasswordController", urlPatterns = { "/forgot-password" })
public class ForgotPasswordController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");

        // Validate email
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập email");
            request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
            return;
        }

        // Validate email format
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$";
        if (!email.matches(emailRegex)) {
            request.setAttribute("error", "Email không hợp lệ");
            request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();

        // Check if email exists
        if (!dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống");
            request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
            return;
        }

        // Generate reset token
        String token = UUID.randomUUID().toString();

        // Save token to database
        boolean tokenSaved = dao.saveResetToken(email, token);

        if (tokenSaved) {
            // Build reset link
            String resetLink = request.getScheme() + "://" +
                    request.getServerName() + ":" +
                    request.getServerPort() +
                    request.getContextPath() +
                    "/reset-password?token=" + token;

            // Send email with reset link
            boolean emailSent = EmailService.sendPasswordResetEmail(email, resetLink);

            if (emailSent) {
                request.setAttribute("success",
                        "Password reset link has been sent to your email. Please check your inbox.");
            } else {
                request.setAttribute("success",
                        "Reset link generated, but email could not be sent. Please contact support.");
                request.setAttribute("demoLink", resetLink);
            }

            request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "An error occurred. Please try again later.");
            request.getRequestDispatcher("views/forgot-password.jsp").forward(request, response);
        }
    }
}
