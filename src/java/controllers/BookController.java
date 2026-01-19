package controllers;

import dao.BookDAO;
import dao.CategoryDAO;
import dao.BorrowSlipDAO;
import models.Book;
import models.Category;
import models.BorrowSlip;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class BookController extends HttpServlet {
    
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    private BorrowSlipDAO borrowSlipDAO = new BorrowSlipDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if (action == null) action = "list";
        
        switch (action) {
            case "view":
                viewBook(request, response);
                break;
            case "add":
                showAddForm(request, response, user);
                break;
            case "edit":
                showEditForm(request, response, user);
                break;
            case "hide":
                hideBook(request, response, user);
                break;
            case "unhide":
                unhideBook(request, response, user);
                break;
            default:
                listBooks(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addBook(request, response, user);
        } else if ("edit".equals(action)) {
            updateBook(request, response, user);
        }
    }
    
    private void listBooks(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession(false).getAttribute("user");
        boolean isStaff = user != null && (user.isLibrarian() || user.isAdmin());
        
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
        
        List<Book> books;
        int totalBooks;
        
        // Staff can see all books including hidden ones, readers only see visible books
        books = bookDAO.getBooksPaginated(page, pageSize, isStaff);
        totalBooks = bookDAO.getTotalBooks(isStaff);
        
        int totalPages = (int) Math.ceil((double) totalBooks / pageSize);
        
        request.setAttribute("books", books);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBooks", totalBooks);
        request.getRequestDispatcher("/views/books/list.jsp").forward(request, response);
    }
    
    private void viewBook(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);
        request.setAttribute("book", book);
        
        // Load current borrowers for this book (active borrows)
        List<BorrowSlip> currentBorrowers = borrowSlipDAO.getActiveBorrowsByBook(bookId);
        request.setAttribute("currentBorrowers", currentBorrowers);
        request.getRequestDispatcher("/views/books/view.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isLibrarian() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/books/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        int bookId = Integer.parseInt(request.getParameter("id"));
        Book book = bookDAO.getBookById(bookId);
        List<Category> categories = categoryDAO.getAllCategories();
        request.setAttribute("book", book);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/books/edit.jsp").forward(request, response);
    }
    
    private void addBook(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isLibrarian() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        Book book = new Book();
        book.setTitle(request.getParameter("title"));
        book.setAuthor(request.getParameter("author"));
        book.setPublisher(request.getParameter("publisher"));
        book.setPublishYear(Integer.parseInt(request.getParameter("publishYear")));
        book.setIsbn(request.getParameter("isbn"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));
        book.setQuantity(quantity);
        book.setAvailableQuantity(quantity);
        book.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        book.setLocation(request.getParameter("location"));
        book.setDescription(request.getParameter("description"));
        book.setImageUrl(request.getParameter("imageUrl"));
        
        if (bookDAO.createBook(book)) {
            response.sendRedirect(request.getContextPath() + "/books?success=added");
        } else {
            request.setAttribute("error", "Failed to add book");
            showAddForm(request, response, user);
        }
    }
    
    private void updateBook(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        Book book = new Book();
        book.setBookId(Integer.parseInt(request.getParameter("bookId")));
        book.setTitle(request.getParameter("title"));
        book.setAuthor(request.getParameter("author"));
        book.setPublisher(request.getParameter("publisher"));
        book.setPublishYear(Integer.parseInt(request.getParameter("publishYear")));
        book.setIsbn(request.getParameter("isbn"));
        book.setQuantity(Integer.parseInt(request.getParameter("quantity")));
        book.setAvailableQuantity(Integer.parseInt(request.getParameter("availableQuantity")));
        book.setCategoryId(Integer.parseInt(request.getParameter("categoryId")));
        book.setLocation(request.getParameter("location"));
        book.setDescription(request.getParameter("description"));
        book.setImageUrl(request.getParameter("imageUrl"));
        
        if (bookDAO.updateBook(book)) {
            response.sendRedirect(request.getContextPath() + "/books?success=updated");
        } else {
            request.setAttribute("error", "Failed to update book");
            showEditForm(request, response, user);
        }
    }
    
    private void hideBook(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int bookId = Integer.parseInt(request.getParameter("id"));
        if (bookDAO.hideBook(bookId)) {
            response.sendRedirect(request.getContextPath() + "/books?success=hidden");
        } else {
            response.sendRedirect(request.getContextPath() + "/books?error=hide_failed");
        }
    }
    
    private void unhideBook(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        if (!user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        int bookId = Integer.parseInt(request.getParameter("id"));
        if (bookDAO.unhideBook(bookId)) {
            response.sendRedirect(request.getContextPath() + "/books?success=unhidden");
        } else {
            response.sendRedirect(request.getContextPath() + "/books?error=unhide_failed");
        }
    }
}
