package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.impl.FabricServiceImpl;

@WebServlet("/RemoveFabricSrv")
public class RemoveFabricSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fabricId = request.getParameter("fabricId");
        if (fabricId == null || fabricId.trim().isEmpty()) {
            response.sendRedirect("viewFabrics.jsp?error=Не вказано ID тканини");
            return;
        }

        FabricServiceImpl fabricService = new FabricServiceImpl();
        String status = fabricService.removeFabric(fabricId);

        response.sendRedirect("viewFabrics.jsp?message=" + status);
    }
}