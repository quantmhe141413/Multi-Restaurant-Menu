package filters;

import constants.UserRole;
import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebFilter(urlPatterns = {"/staff/*"})
public class StaffAuthenticationFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization logic if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        // Check if user is logged in
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");

        // Verify user has Staff role
        if (!UserRole.isStaff(user.getRoleID())) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
            return;
        }

        // Check if restaurantId exists in session
        Integer restaurantId = (Integer) session.getAttribute("restaurantId");
        if (restaurantId == null) {
            httpRequest.setAttribute("error", "Tài khoản chưa được gán nhà hàng");
            httpRequest.getRequestDispatcher("/views/login.jsp").forward(httpRequest, httpResponse);
            return;
        }

        // Update last activity timestamp for session timeout tracking
        session.setAttribute("lastActivity", System.currentTimeMillis());

        // User is authenticated and authorized, continue with request
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // Cleanup logic if needed
    }
}
