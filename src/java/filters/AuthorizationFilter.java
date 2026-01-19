package filters;

import models.User;
import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AuthorizationFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization code if needed
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        String requestURI = httpRequest.getRequestURI();
        
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String role = user.getRole();
            
            // Define role-based access control
            boolean hasAccess = true;
            
            // Admin-only pages
            if (requestURI.contains("/admin/") || requestURI.contains("/users") || 
                requestURI.contains("/staff") || requestURI.contains("/category")) {
                hasAccess = user.isAdmin();
            }
            
            // Librarian and Admin pages
            else if (requestURI.contains("/borrow") || requestURI.contains("/readers")) {
                hasAccess = user.isLibrarian() || user.isAdmin();
            }
            
            // Books management (librarian and admin can edit)
            else if (requestURI.contains("/book") && !requestURI.contains("/search")) {
                String action = httpRequest.getParameter("action");
                if ("add".equals(action) || "edit".equals(action) || "delete".equals(action)) {
                    hasAccess = user.isLibrarian() || user.isAdmin();
                }
            }
            
            if (hasAccess) {
                chain.doFilter(request, response);
            } else {
                // User doesn't have permission
                httpResponse.sendRedirect(httpRequest.getContextPath() + "/home?error=access_denied");
            }
        } else {
            // No user in session, redirect to login
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login");
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
