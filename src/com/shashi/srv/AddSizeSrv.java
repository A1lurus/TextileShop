package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.impl.SizeServiceImpl;

@WebServlet("/AddSizeSrv")
public class AddSizeSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String sizeName = request.getParameter("sizeName");
        String productType = request.getParameter("productType");
        Double length = request.getParameter("length") != null && !request.getParameter("length").isEmpty() 
                ? Double.parseDouble(request.getParameter("length")) 
                : null;
        Double width = request.getParameter("width") != null && !request.getParameter("width").isEmpty()
                ? Double.parseDouble(request.getParameter("width"))
                : null;

        SizeServiceImpl sizeService = new SizeServiceImpl();
        String status = sizeService.addSize(sizeName, productType, length, width);

        response.sendRedirect("viewSizes.jsp?message=" + status);
    }
}