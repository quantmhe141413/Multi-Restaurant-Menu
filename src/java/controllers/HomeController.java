package controllers;

import dao.BookDAO;
import dao.CategoryDAO;
import models.Book;
import models.Category;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class HomeController extends HttpServlet {
    
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        boolean isStaff = user != null && (user.isLibrarian() || user.isAdmin());
        
        if (session == null || user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Pagination parameters
        int page = 1;
        int pageSize = 8;
        String pageParam = request.getParameter("page");
        if (pageParam != null) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        String keyword = request.getParameter("keyword");
        String categoryIdStr = request.getParameter("categoryId");
        
        List<Book> books;
        int totalBooks;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            // Search books with pagination
            books = bookDAO.searchBooksPaginated(keyword, page, pageSize, isStaff);
            totalBooks = bookDAO.getTotalSearchResults(keyword, isStaff);
            request.setAttribute("keyword", keyword);
        } else if (categoryIdStr != null && !categoryIdStr.trim().isEmpty()) {
            // Filter by category with pagination
            try {
                int categoryId = Integer.parseInt(categoryIdStr);
                books = bookDAO.getBooksByCategoryPaginated(categoryId, page, pageSize, isStaff);
                totalBooks = bookDAO.getTotalBooksByCategory(categoryId, isStaff);
                request.setAttribute("selectedCategoryId", categoryId);
            } catch (NumberFormatException e) {
                // Invalid category ID, show all books
                books = bookDAO.getBooksPaginated(page, pageSize, isStaff);
                totalBooks = bookDAO.getTotalBooks(isStaff);
            }
        } else {
            // Show all books with pagination
            books = bookDAO.getBooksPaginated(page, pageSize, isStaff);
            totalBooks = bookDAO.getTotalBooks(isStaff);
        }
        
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        
        List<Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        request.setAttribute("user", user);
        
        request.getRequestDispatcher("/views/home.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
