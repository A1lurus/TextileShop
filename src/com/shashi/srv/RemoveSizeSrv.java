package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.impl.SizeServiceImpl;

@WebServlet("/RemoveSizeSrv")
public class RemoveSizeSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String sizeId = request.getParameter("sizeId");
        if (sizeId == null || sizeId.trim().isEmpty()) {
            response.sendRedirect("viewSizes.jsp?error=Не вказано ID розміру");
            return;
        }

        SizeServiceImpl sizeService = new SizeServiceImpl();
        String status = sizeService.removeSize(sizeId);

        response.sendRedirect("viewSizes.jsp?message=" + status);
    }
}