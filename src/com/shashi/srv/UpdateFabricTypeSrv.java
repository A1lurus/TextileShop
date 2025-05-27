package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.shashi.beans.FabricTypeBean;
import com.shashi.service.impl.FabricTypeServiceImpl;

@WebServlet("/UpdateFabricTypeSrv")
public class UpdateFabricTypeSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Налаштування кодування
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        // Перевірка авторизації
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Доступ заборонено, увійдіть як адміністратор!!");
            return;
        }
        
        try {
            // Отримання параметрів
            String oldFabricTypeName = request.getParameter("old_fabric_type_name");
            String fabricTypeName = request.getParameter("fabric_type_name");
            String priceParam = request.getParameter("price_per_meter");
            
            // Валідація вхідних даних
            if (oldFabricTypeName == null || oldFabricTypeName.trim().isEmpty() ||
                fabricTypeName == null || fabricTypeName.trim().isEmpty() ||
                priceParam == null || priceParam.trim().isEmpty()) {
                response.sendRedirect("viewFabricTypes.jsp?error=Необхідно заповнити всі поля");
                return;
            }
            
            // Перетворення ціни
            double pricePerMeter;
            try {
                pricePerMeter = Double.parseDouble(priceParam);
                if (pricePerMeter <= 0) {
                    response.sendRedirect("updateFabricType.jsp?type=" + oldFabricTypeName + 
                                         "&error=Ціна повинна бути більше 0");
                    return;
                }
            } catch (NumberFormatException e) {
                response.sendRedirect("updateFabricType.jsp?type=" + oldFabricTypeName + 
                                     "&error=Невірний формат ціни");
                return;
            }
            
            // Створення об'єкта для оновлення
            FabricTypeBean updatedFabricType = new FabricTypeBean();
            updatedFabricType.setFabricTypeName(fabricTypeName);
            updatedFabricType.setPricePerMeter(pricePerMeter);
            
            // Оновлення в базі даних
            FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
            String status = fabricTypeService.updateFabricType(oldFabricTypeName, updatedFabricType);
            
            // Перенаправлення з результатом
            response.sendRedirect("viewFabricTypes.jsp?message=" + status);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("viewFabricTypes.jsp?error=Помилка при оновленні типу тканини: " + e.getMessage());
        }
    }
}