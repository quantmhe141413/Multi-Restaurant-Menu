package controllers;

import dao.BorrowSlipDAO;
import dao.ReaderDAO;
import dao.BookDAO;
import dao.CategoryDAO;
import models.BorrowSlip;
import models.BorrowDetail;
import models.Reader;
import models.Book;
import models.User;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class BorrowController extends HttpServlet {
    
    private BorrowSlipDAO borrowDAO = new BorrowSlipDAO();
    private ReaderDAO readerDAO = new ReaderDAO();
    private BookDAO bookDAO = new BookDAO();
    private CategoryDAO categoryDAO = new CategoryDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Only librarians and admins can access
        if (!user.isLibrarian() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) action = "list";
        
        switch (action) {
            case "view":
                viewBorrowSlip(request, response);
                break;
            case "new":
                showNewForm(request, response);
                break;
            case "return":
                returnBorrowSlip(request, response, user);
                break;
            case "markFinePaid":
                markFinePaid(request, response, user);
                break;
            default:
                listBorrowSlips(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (!user.isLibrarian() && !user.isAdmin()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("create".equals(action)) {
            createBorrowSlip(request, response, user);
        }
    }
    
    private void listBorrowSlips(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String statusFilter = request.getParameter("status");
        List<BorrowSlip> slips;
        
        if ("active".equals(statusFilter)) {
            slips = borrowDAO.getActiveBorrowSlips();
        } else if ("overdue".equals(statusFilter)) {
            slips = borrowDAO.getOverdueBorrowSlips();
        } else {
            slips = borrowDAO.getAllBorrowSlips();
        }
        
        request.setAttribute("borrowSlips", slips);
        request.setAttribute("statusFilter", statusFilter);
        request.getRequestDispatcher("/views/borrow/list.jsp").forward(request, response);
    }
    
    private void viewBorrowSlip(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        int slipId = Integer.parseInt(request.getParameter("id"));
        BorrowSlip slip = borrowDAO.getBorrowSlipById(slipId);
        List<BorrowDetail> details = borrowDAO.getBorrowDetailsBySlipId(slipId);
        slip.setBorrowDetails(details);
        
        request.setAttribute("borrowSlip", slip);
        request.getRequestDispatcher("/views/borrow/view.jsp").forward(request, response);
    }
    private void markFinePaid(HttpServletRequest request, HttpServletResponse response, User user)
        throws ServletException, IOException {

    // Chỉ cho thủ thư / admin
    if (!user.isLibrarian() && !user.isAdmin()) {
        response.sendRedirect(request.getContextPath() + "/home");
        return;
    }

    try {
        int slipId = Integer.parseInt(request.getParameter("id"));

        boolean ok = borrowDAO.markFinePaid(slipId);
        if (ok) {
            // Quay lại màn chi tiết phiếu với thông báo thành công
            response.sendRedirect(
                    request.getContextPath()
                            + "/borrow?action=view&id=" + slipId + "&success=fine_paid");
        } else {
            response.sendRedirect(
                    request.getContextPath()
                            + "/borrow?action=view&id=" + slipId + "&error=fine_failed");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect(request.getContextPath() + "/borrow?error=fine_failed");
    }
}
    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<Reader> readers = readerDAO.getActiveReaders();
        List<Book> books = bookDAO.getAvailableBooks();
        List<models.Category> categories = categoryDAO.getAllCategories();
        
        request.setAttribute("readers", readers);
        request.setAttribute("books", books);
        request.setAttribute("categories", categories);
        request.getRequestDispatcher("/views/borrow/new.jsp").forward(request, response);
    }
    
    private void createBorrowSlip(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            int readerId = Integer.parseInt(request.getParameter("readerId"));
            int daysToReturn = Integer.parseInt(request.getParameter("daysToReturn"));
            String notes = request.getParameter("notes");
            
            // Basic validate daysToReturn
            if (daysToReturn <= 0 || daysToReturn > 30) {
                request.setAttribute("error", "Days to return must be between 1 and 30.");
                showNewForm(request, response);
                return;
            }

            // Block new borrows if reader has overdue slips with unpaid fine
            if (borrowDAO.hasUnpaidOverdueByReader(readerId)) {
                request.setAttribute("error", "Độc giả đang có phiếu mượn quá hạn chưa nộp phí. Vui lòng thu phí trước khi cho mượn thêm.");
                showNewForm(request, response);
                return;
            }

            // Validate requested books & quantities against current stock
            String[] bookIds = request.getParameterValues("bookId");
            String[] quantities = request.getParameterValues("quantity");

            if (bookIds == null || quantities == null || bookIds.length == 0) {
                request.setAttribute("error", "Please select at least one book to borrow.");
                showNewForm(request, response);
                return;
            }

            for (int i = 0; i < bookIds.length; i++) {
                int bookId = Integer.parseInt(bookIds[i]);
                int quantity = Integer.parseInt(quantities[i]);

                if (quantity <= 0) {
                    request.setAttribute("error", "Quantity must be greater than 0.");
                    showNewForm(request, response);
                    return;
                }

                Book book = bookDAO.getBookById(bookId);
                if (book == null) {
                    request.setAttribute("error", "Selected book does not exist.");
                    showNewForm(request, response);
                    return;
                }

                if (quantity > book.getAvailableQuantity()) {
                    request.setAttribute("error", "Book '" + book.getTitle() + "' only has " + book.getAvailableQuantity() + " copies available.");
                    showNewForm(request, response);
                    return;
                }
            }

            // Create borrow slip
            BorrowSlip slip = new BorrowSlip();
            slip.setReaderId(readerId);
            slip.setLibrarianId(user.getUserId());
            slip.setBorrowDate(new Timestamp(System.currentTimeMillis()));
            slip.setDueDate(new Timestamp(System.currentTimeMillis() + (daysToReturn * 24L * 60 * 60 * 1000)));
            slip.setStatus("borrowed");
            slip.setNotes(notes);
            
            int slipId = borrowDAO.createBorrowSlip(slip);
            
            if (slipId > 0) {
                // Add book details (validated above)
                for (int i = 0; i < bookIds.length; i++) {
                    int bookId = Integer.parseInt(bookIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);

                    BorrowDetail detail = new BorrowDetail();
                    detail.setSlipId(slipId);
                    detail.setBookId(bookId);
                    detail.setQuantity(quantity);
                    detail.setReturned(false);

                    borrowDAO.addBorrowDetail(detail);

                    // Update book available quantity
                    bookDAO.updateAvailableQuantity(bookId, -quantity);
                }
                
                response.sendRedirect(request.getContextPath() + "/borrow?success=created");
            } else {
                request.setAttribute("error", "Failed to create borrow slip");
                showNewForm(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            showNewForm(request, response);
        }
    }
    
    private void returnBorrowSlip(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        try {
            int slipId = Integer.parseInt(request.getParameter("id"));
            
            // Get all details for this slip
            List<BorrowDetail> details = borrowDAO.getBorrowDetailsBySlipId(slipId);
            
            // Return each book and update inventory
            for (BorrowDetail detail : details) {
                if (!detail.isReturned()) {
                    borrowDAO.returnBorrowDetail(detail.getDetailId());
                    bookDAO.updateAvailableQuantity(detail.getBookId(), detail.getQuantity());
                }
            }
            
            // Mark slip as returned
            borrowDAO.returnBorrowSlip(slipId);
            
            response.sendRedirect(request.getContextPath() + "/borrow?success=returned");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/borrow?error=return_failed");
        }
    }
}
