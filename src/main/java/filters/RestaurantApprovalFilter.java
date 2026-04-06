package filters;

import dal.RestaurantDAO;
import models.Restaurant;
import models.User;

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
import java.io.IOException;

/**
 * Filter to prevent Restaurant Owners from accessing management pages
 * if their restaurant is not 'Approved'.
 */
@WebFilter(filterName = "RestaurantApprovalFilter", urlPatterns = {
    "/restaurant-analytics-dashboard",
    "/categories/*",
    "/items/*",
    "/menu-management-dashboard",
    "/owner/*"
})
public class RestaurantApprovalFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            // Check if user is an Owner (RoleID 2)
            if (user != null && user.getRoleID() == 2) {
                RestaurantDAO dao = new RestaurantDAO();
                Restaurant r = dao.getRestaurantByOwnerId(user.getUserID());

                // If no restaurant, or status is not 'Approved', redirect to profile setup
                if (r == null || !"Approved".equalsIgnoreCase(r.getStatus())) {
                    // Allow access to the profile setup itself (though it's not in the pattern)
                    String path = httpRequest.getRequestURI();
                    if (!path.contains("/restaurant-profile-setup")) {
                        httpResponse.sendRedirect(httpRequest.getContextPath() + "/restaurant-profile-setup");
                        return;
                    }
                }
            }
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
    }
}
