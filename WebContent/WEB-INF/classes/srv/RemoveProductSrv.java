package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/RemoveProductSrv")
public class RemoveProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Налаштування кодування
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Перевірка авторизації
        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Доступ заборонено! Увійдіть як адміністратор");
            return;
        }

        // Отримання ID товару
        String prodId = request.getParameter("prodid");
        if (prodId == null || prodId.trim().isEmpty()) {
            response.sendRedirect("adminStock.jsp?error=Не вказано ID товару");
            return;
        }

        try {
            ProductServiceImpl productService = new ProductServiceImpl();
            String status = productService.removeProduct(prodId);
            
            // Перенаправлення на сторінку складу з повідомленням
            response.sendRedirect("adminStock.jsp?message=" + status);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("adminStock.jsp?error=Помилка при видаленні товару: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}