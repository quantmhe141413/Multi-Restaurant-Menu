package controllers;

import dao.BorrowSlipDAO;
import dao.ReaderDAO;
import models.BorrowDetail;
import models.BorrowSlip;
import models.Reader;
import models.User;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

public class ReaderBorrowHistoryController extends HttpServlet {
    
    private BorrowSlipDAO borrowDAO = new BorrowSlipDAO();
    private ReaderDAO readerDAO = new ReaderDAO();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;
        
        // Only readers can access their own history
        if (user == null || !user.isReader()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }
        
        // Find reader card linked to this user
        Reader reader = readerDAO.getReaderByUserId(user.getUserId());
        if (reader == null) {
            request.setAttribute("error", "Tài khoản của bạn chưa được liên kết với thẻ độc giả.");
            request.getRequestDispatcher("/views/reader/history.jsp").forward(request, response);
            return;
        }
        
        List<BorrowSlip> borrowSlips = borrowDAO.getBorrowSlipsByReader(reader.getReaderId());
        for (BorrowSlip slip : borrowSlips) {
            List<BorrowDetail> details = borrowDAO.getBorrowDetailsBySlipId(slip.getSlipId());
            slip.setBorrowDetails(details);
        }
        
        request.setAttribute("reader", reader);
        request.setAttribute("borrowSlips", borrowSlips);
        request.getRequestDispatcher("/views/reader/history.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
