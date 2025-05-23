package com.shashi.srv;

import java.io.IOException;
import java.io.InputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.http.Part;

import com.shashi.beans.ProductBean;
import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/UpdateProductSrv")
@MultipartConfig
public class UpdateProductSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Установка кодування для правильного відображення кирилиці
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        // Проверка авторизации администратора
        if (userType == null || !userType.equals("admin")) {
            String message = URLEncoder.encode("Доступ заборонено, увійдіть як адміністратор!!", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=" + message);
            return;
        } else if (userName == null || password == null) {
            String message = URLEncoder.encode("Сесія закінчилась, увійдіть знову!!", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=" + message);
            return;
        }

        String prodId = request.getParameter("pid");
        if (prodId == null || prodId.trim().isEmpty()) {
            String message = URLEncoder.encode("Необхідно вказати ID товару", StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/updateProductById.jsp?message=" + message);
            return;
        }

        try {
            // Получение параметров из формы
            String prodName = request.getParameter("name");
            String prodType = request.getParameter("type");
            String prodInfo = request.getParameter("info");
            String size = request.getParameter("size");
            String fabricType = request.getParameter("fabricType");
            boolean hide = "true".equalsIgnoreCase(request.getParameter("hide"));
            
            // Получение файла изображения (если был загружен)
            Part filePart = request.getPart("image");
            InputStream prodImage = null;
            boolean imageUpdated = false;
            
            if (filePart != null && filePart.getSize() > 0) {
                prodImage = filePart.getInputStream();
                imageUpdated = true;
            }

            // Валидация числовых параметров
            double prodPrice;
            int prodQuantity;
            
            try {
                prodPrice = Double.parseDouble(request.getParameter("price").trim());
                prodQuantity = Integer.parseInt(request.getParameter("quantity").trim());
            } catch (NumberFormatException e) {
                String error = URLEncoder.encode("Невірний формат числового значення", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
                return;
            }

            // Дополнительная валидация
            if (prodPrice <= 0) {
                String error = URLEncoder.encode("Ціна повинна бути більше 0", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
                return;
            }
            if (prodQuantity < 0) {
                String error = URLEncoder.encode("Кількість не може бути від'ємною", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
                return;
            }
            if (size == null || size.trim().isEmpty()) {
                String error = URLEncoder.encode("Необхідно вказати розмір", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
                return;
            }
            if (fabricType == null || fabricType.trim().isEmpty()) {
                String error = URLEncoder.encode("Необхідно вказати тип тканини", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
                return;
            }

            // Создание объекта товара
            ProductBean product = new ProductBean();
            product.setProdId(prodId);
            product.setProdName(prodName);
            product.setProdInfo(prodInfo);
            product.setProdPrice(prodPrice);
            product.setProdQuantity(prodQuantity);
            product.setProdType(prodType);
            product.setHide(hide);
            product.setSize(size);
            product.setFabricType(fabricType);
            
            // Если было загружено новое изображение, добавляем его
            if (imageUpdated) {
                product.setProdImage(prodImage);
            }

            ProductServiceImpl dao = new ProductServiceImpl();
            String status;
            
            // Выбор метода обновления в зависимости от наличия нового изображения
            if (imageUpdated) {
                status = dao.updateProduct(dao.getProductDetails(prodId), product);
            } else {
                status = dao.updateProductWithoutImage(prodId, product);
            }

            // Перенаправление с соответствующим сообщением
            if (status.contains("Successfully")) {
                String message = URLEncoder.encode("Товар успішно оновлено!", StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&message=" + message);
            } else {
                String error = URLEncoder.encode(status, StandardCharsets.UTF_8.toString());
                response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
            }

        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = "Помилка при оновленні товару: " + e.getMessage();
            String error = URLEncoder.encode(errorMsg, StandardCharsets.UTF_8.toString());
            response.sendRedirect(request.getContextPath() + "/updateProduct.jsp?prodid=" + prodId + "&error=" + error);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}