package controllers;

import dal.DeliveryFeeDAO;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;
import models.DeliveryFee;

@WebServlet(name = "CalculateDeliveryFeeController", urlPatterns = {"/api/calculate-delivery-fee"})
public class CalculateDeliveryFeeController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        Map<String, Object> result = new HashMap<>();

        try {
            int zoneId = Integer.parseInt(request.getParameter("zoneId"));
            double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));

            DeliveryFeeDAO feeDao = new DeliveryFeeDAO();
            // Fetch all active fees for this zone
            List<DeliveryFee> fees = feeDao.findFeesWithFilters(null, null, zoneId, 1, 100);
            
            double bestFee = -1; // -1 means no fee defined / not deliverable
            
            for (DeliveryFee fee : fees) {
                if (fee.getIsActive()) {
                    // Check order amount constraints
                    boolean validMin = (fee.getMinOrderAmount() == null || totalAmount >= fee.getMinOrderAmount().doubleValue());
                    boolean validMax = (fee.getMaxOrderAmount() == null || totalAmount <= fee.getMaxOrderAmount().doubleValue());
                    
                    if (validMin && validMax) {
                        double calculatedFee = 0;
                        if ("Flat".equals(fee.getFeeType())) {
                            calculatedFee = fee.getFeeValue().doubleValue();
                        } else if ("PercentageOfOrder".equals(fee.getFeeType())) {
                            calculatedFee = totalAmount * (fee.getFeeValue().doubleValue() / 100.0);
                        } else if ("FreeAboveAmount".equals(fee.getFeeType()) || "FreeDelivery".equals(fee.getFeeType())) {
                            calculatedFee = 0;
                        }
                        
                        // We want the lowest valid fee for the customer
                        if (bestFee == -1 || calculatedFee < bestFee) {
                            bestFee = calculatedFee;
                        }
                    }
                }
            }
            
            if (bestFee == -1) {
                // Not supported
                result.put("success", false);
                result.put("message", "Khu vực này không có biểu phí giao hàng hoặc đơn hàng chưa đủ điều kiện.");
                result.put("fee", 0);
            } else {
                result.put("success", true);
                result.put("fee", bestFee);
            }

        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi xử lý phí giao hàng.");
        }
        
        out.print(gson.toJson(result));
        out.flush();
    }
}
