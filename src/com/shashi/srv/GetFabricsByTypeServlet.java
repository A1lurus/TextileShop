package com.shashi.srv;

import com.shashi.beans.FabricBean;
import com.shashi.service.FabricService;
import com.shashi.service.impl.FabricServiceImpl;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet("/GetFabricsByType")
public class GetFabricsByTypeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private final FabricService fabricService = new FabricServiceImpl();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            String fabricType = request.getParameter("fabricType");
            
            if (fabricType == null || fabricType.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print("{\"error\":\"Тип тканини не вказано\"}");
                return;
            }
            
            List<FabricBean> fabrics = fabricService.getFabricsByType(fabricType);
            StringBuilder jsonBuilder = new StringBuilder("[");
            
            for (int i = 0; i < fabrics.size(); i++) {
                FabricBean fabric = fabrics.get(i);
                if (i > 0) jsonBuilder.append(",");
                jsonBuilder.append("{")
                    .append("\"fabricId\":\"").append(escapeJson(fabric.getFabricId())).append("\",")
                    .append("\"fabricTypeName\":\"").append(escapeJson(fabric.getFabricTypeName())).append("\",")
                    .append("\"color\":\"").append(escapeJson(fabric.getColor()))
                    // .append(",\"availableMeters\":").append(fabric.getAvailableMeters()) // availableMeters видалено
                    .append("}");
            }
            
            jsonBuilder.append("]");
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(jsonBuilder.toString());
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Внутрішня помилка сервера\"}");
            e.printStackTrace();
        } finally {
            out.flush();
            out.close();
        }
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\b", "\\b")
                    .replace("\f", "\\f")
                    .replace("\n", "\\n")
                    .replace("\r", "\\r")
                    .replace("\t", "\\t");
    }
}