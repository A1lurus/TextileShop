package com.shashi.srv;

import java.io.IOException;
import java.io.InputStream;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.shashi.service.impl.FabricServiceImpl;

@WebServlet("/AddFabricSrv")
@MultipartConfig(maxFileSize = 16177215)
public class AddFabricSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String fabricTypeName = request.getParameter("fabricTypeName");
        String color = request.getParameter("color");
        Part imagePart = request.getPart("image");
        InputStream image = imagePart.getInputStream();

        FabricServiceImpl fabricService = new FabricServiceImpl();
        // Updated service call
        String status = fabricService.addFabric(fabricTypeName, color, image);

        response.sendRedirect("viewFabrics.jsp?message=" + status);
    }
}