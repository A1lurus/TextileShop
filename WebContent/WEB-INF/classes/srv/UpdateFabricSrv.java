package com.shashi.srv;

import java.io.IOException;
import java.io.InputStream; // Keep this import if you still use it for image handling
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import com.shashi.beans.FabricBean;
import com.shashi.service.impl.FabricServiceImpl;

@WebServlet("/UpdateFabricSrv")
@MultipartConfig(maxFileSize = 16177215)
public class UpdateFabricSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        String fabricId = request.getParameter("fabricId");
        String fabricTypeName = request.getParameter("fabricTypeName");
        String color = request.getParameter("color");
        
        FabricBean fabric = new FabricBean();
        fabric.setFabricId(fabricId);
        fabric.setFabricTypeName(fabricTypeName);
        fabric.setColor(color);
        
        // Обробка зображення (якщо завантажено нове)
        Part imagePart = request.getPart("image");
        if (imagePart != null && imagePart.getSize() > 0) {
            fabric.setImage(imagePart.getInputStream());
        } else {
            // Якщо зображення не змінювалось, отримуємо поточне з БД
            FabricServiceImpl service = new FabricServiceImpl();
            FabricBean currentFabric = service.getFabricDetails(fabricId);
            if (currentFabric != null) {
                // Встановлюємо поточне зображення, якщо нове не було завантажено
                fabric.setImage(currentFabric.getImage()); 
            } else {
                // Обробка випадку, коли тканину не знайдено для оновлення зображення
                response.sendRedirect("viewFabrics.jsp?error=Помилка: Тканину не знайдено для оновлення зображення.");
                return;
            }
        }

        FabricServiceImpl fabricService = new FabricServiceImpl();
        String status = fabricService.updateFabric(fabric); // Викликаємо оновлений метод updateFabric

        response.sendRedirect("viewFabrics.jsp?message=" + status);
    }
}