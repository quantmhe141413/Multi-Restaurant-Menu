package controllers;

import dal.RestaurantDAO;
import dal.ReviewDAO;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Restaurant;

@WebServlet(name = "HomeController", urlPatterns = { "/home" })
public class HomeController extends HttpServlet {

    private static final int PAGE_SIZE = 6;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String search = request.getParameter("search");
        String zone = request.getParameter("zone");
        String cuisine = request.getParameter("cuisine");
        String pageParam = request.getParameter("page");
        
        int currentPage = 1;
        try {
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                currentPage = Integer.parseInt(pageParam);
                if (currentPage < 1) currentPage = 1;
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }
        
        RestaurantDAO rdao = new RestaurantDAO();
        
        // Get total count for pagination
        int totalRestaurants = rdao.countApprovedRestaurants(search, zone, cuisine);
        int totalPages = (int) Math.ceil((double) totalRestaurants / PAGE_SIZE);
        
        // Get restaurants for current page
        List<Restaurant> restaurants = rdao.getApprovedRestaurants(search, zone, cuisine, currentPage, PAGE_SIZE);

        // Rating summary: restaurantId -> double[]{avgRating, reviewCount}
        ReviewDAO reviewDAO = new ReviewDAO();
        Map<Integer, double[]> ratingSummary = reviewDAO.getRatingSummaryForAllRestaurants();

        request.setAttribute("restaurants", restaurants);
        request.setAttribute("ratingSummary", ratingSummary);
        request.setAttribute("zones", rdao.getActiveZoneNames());
        request.setAttribute("cuisines", rdao.getAvailableCuisines());
        request.setAttribute("selectedZone", zone);
        request.setAttribute("selectedCuisine", cuisine);
        request.setAttribute("currentSearch", search);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        
        request.getRequestDispatcher("views/home.jsp").forward(request, response);
    }
}
