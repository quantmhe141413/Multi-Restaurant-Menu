package controllers;

import dal.MenuDAO;
import models.TopDish;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "TopDishesReportController", urlPatterns = { "/top-dishes-report" })
public class TopDishesReportController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer restaurantId = (session != null) ? (Integer) session.getAttribute("restaurantId") : null;
        
        if (restaurantId == null) {
            response.sendRedirect("login");
            return;
        }

        MenuDAO dao = new MenuDAO();
        List<TopDish> topDishes = dao.getTopDishesByRestaurant(restaurantId);
        
        request.setAttribute("topDishes", topDishes);
        request.getRequestDispatcher("views/top-dishes-report.jsp").forward(request, response);
    }
}
