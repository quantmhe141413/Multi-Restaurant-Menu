package controllers;

import dao.ReaderDAO;
import dao.UserDAO;
import dao.BorrowSlipDAO;
import models.Reader;
import models.User;
import models.BorrowSlip;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.Calendar;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

public class ReaderController extends HttpServlet {
    
    private ReaderDAO readerDAO = new ReaderDAO();
    private UserDAO userDAO = new UserDAO();
    private BorrowSlipDAO borrowDAO = new BorrowSlipDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        // Only librarians and admins can access reader management
        if (user == null || (!user.isLibrarian() && !user.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if (action == null) action = "list";
        
        switch (action) {
            case "view":
                viewReader(request, response);
                break;
            case "add":
                showAddForm(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "search":
                searchReaders(request, response);
                break;
            default:
                listReaders(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        
        if (user == null || (!user.isLibrarian() && !user.isAdmin())) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        String action = request.getParameter("action");
        
        if ("add".equals(action)) {
            addReader(request, response);
        } else if ("edit".equals(action)) {
            updateReader(request, response);
        }
    }
    
    private void listReaders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Reader> readers = readerDAO.getAllReaders();
        request.setAttribute("readers", readers);
        request.getRequestDispatcher("/views/readers/list.jsp").forward(request, response);
    }
    
    private void viewReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader reader = readerDAO.getReaderById(readerId);
        request.setAttribute("reader", reader);
        if (reader != null) {
            List<BorrowSlip> borrowSlips = borrowDAO.getBorrowSlipsByReader(reader.getReaderId());
            request.setAttribute("borrowSlips", borrowSlips);
        }
        request.getRequestDispatcher("/views/readers/view.jsp").forward(request, response);
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Get list of users with 'reader' role who don't have a reader card yet
        List<User> availableUsers = userDAO.getUsersByRole("reader");
        request.setAttribute("availableUsers", availableUsers);
        request.getRequestDispatcher("/views/readers/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int readerId = Integer.parseInt(request.getParameter("id"));
        Reader reader = readerDAO.getReaderById(readerId);
        request.setAttribute("reader", reader);
        request.getRequestDispatcher("/views/readers/edit.jsp").forward(request, response);
    }
    
    private void addReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Reader reader = new Reader();
        reader.setCardNumber(request.getParameter("cardNumber"));
        reader.setFullName(request.getParameter("fullName"));
        reader.setPhone(request.getParameter("phone"));
        reader.setEmail(request.getParameter("email"));
        reader.setAddress(request.getParameter("address"));
        
        // Set user_id if provided
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                reader.setUserId(Integer.parseInt(userIdStr));
            } catch (NumberFormatException e) {
                reader.setUserId(null);
            }
        }
        
        // Set expiry date (default: 1 year from now)
        String expiryDateStr = request.getParameter("expiryDate");
        if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
            try {
                reader.setExpiryDate(Timestamp.valueOf(expiryDateStr + " 00:00:00"));
            } catch (Exception e) {
                // Default to 1 year from now
                Calendar cal = Calendar.getInstance();
                cal.add(Calendar.YEAR, 1);
                reader.setExpiryDate(new Timestamp(cal.getTimeInMillis()));
            }
        } else {
            // Default to 1 year from now
            Calendar cal = Calendar.getInstance();
            cal.add(Calendar.YEAR, 1);
            reader.setExpiryDate(new Timestamp(cal.getTimeInMillis()));
        }
        
        reader.setStatus(true); // Active by default
        
        if (readerDAO.createReader(reader)) {
            response.sendRedirect(request.getContextPath() + "/readers?success=added");
        } else {
            request.setAttribute("error", "Failed to create reader card. Card number may already exist.");
            showAddForm(request, response);
        }
    }
    
    private void updateReader(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        Reader reader = new Reader();
        reader.setReaderId(Integer.parseInt(request.getParameter("readerId")));
        reader.setCardNumber(request.getParameter("cardNumber"));
        reader.setFullName(request.getParameter("fullName"));
        reader.setPhone(request.getParameter("phone"));
        reader.setEmail(request.getParameter("email"));
        reader.setAddress(request.getParameter("address"));
        
        // Set user_id if provided
        String userIdStr = request.getParameter("userId");
        if (userIdStr != null && !userIdStr.trim().isEmpty()) {
            try {
                reader.setUserId(Integer.parseInt(userIdStr));
            } catch (NumberFormatException e) {
                reader.setUserId(null);
            }
        }
        
        // Set expiry date
        String expiryDateStr = request.getParameter("expiryDate");
        if (expiryDateStr != null && !expiryDateStr.trim().isEmpty()) {
            try {
                reader.setExpiryDate(Timestamp.valueOf(expiryDateStr + " 00:00:00"));
            } catch (Exception e) {
                reader.setExpiryDate(null);
            }
        }
        
        // Set status
        reader.setStatus("1".equals(request.getParameter("status")));
        
        if (readerDAO.updateReader(reader)) {
            response.sendRedirect(request.getContextPath() + "/readers?success=updated");
        } else {
            request.setAttribute("error", "Failed to update reader card");
            showEditForm(request, response);
        }
    }
    
    private void searchReaders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        List<Reader> readers;
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            readers = readerDAO.searchReaders(keyword);
            request.setAttribute("keyword", keyword);
        } else {
            readers = readerDAO.getAllReaders();
        }
        
        request.setAttribute("readers", readers);
        request.getRequestDispatcher("/views/readers/list.jsp").forward(request, response);
    }
}
