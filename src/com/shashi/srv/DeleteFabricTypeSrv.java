package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.impl.FabricTypeServiceImpl;

@WebServlet("/DeleteFabricTypeSrv")
public class DeleteFabricTypeSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html; charset=UTF-8");
        
        String fabricTypeName = request.getParameter("type");
        
        FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
        String status = fabricTypeService.removeFabricType(fabricTypeName);
        
        response.sendRedirect("viewFabricTypes.jsp?message=" + status);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}