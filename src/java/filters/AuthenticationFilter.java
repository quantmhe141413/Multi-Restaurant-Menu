package filters;

import java.io.IOException;
import jakarta.servlet.*;
import jakarta.servlet.http.*;

public class AuthenticationFilter implements Filter {
    
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
        
        String loginURI = httpRequest.getContextPath() + "/login";
        String registerURI = httpRequest.getContextPath() + "/register";
        String requestURI = httpRequest.getRequestURI();
        
        // Check if user is logged in
        boolean loggedIn = (session != null && session.getAttribute("user") != null);
        boolean loginRequest = requestURI.equals(loginURI);
        boolean registerRequest = requestURI.equals(registerURI);
        boolean resourceRequest = requestURI.contains("/css/") || requestURI.contains("/js/") || 
                                  requestURI.contains("/images/") || requestURI.contains(".css") ||
                                  requestURI.contains(".js") || requestURI.contains(".png") ||
                                  requestURI.contains(".jpg") || requestURI.contains(".ico");
        
        if (loggedIn || loginRequest || registerRequest || resourceRequest) {
            // User is logged in or requesting login page or static resources
            chain.doFilter(request, response);
        } else {
            // User is not logged in, redirect to login page
            httpResponse.sendRedirect(loginURI);
        }
    }
    
    @Override
    public void destroy() {
        // Cleanup code if needed
    }
}
