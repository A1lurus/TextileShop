package com.shashi.srv;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shashi.service.impl.OrderServiceImpl;

@WebServlet("/CancelOrderServlet")
public class CancelOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public CancelOrderServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String transactionId = request.getParameter("orderid");
        String productId = request.getParameter("prodid"); // Отримуємо prodid

        if (transactionId != null && !transactionId.isEmpty() && productId != null && !productId.isEmpty()) {
            OrderServiceImpl orderService = new OrderServiceImpl();
            // Викликаємо оновлений метод з productId
            boolean success = orderService.updateShippedStatus(transactionId, productId, 2); 

            if (success) {
                request.setAttribute("message", "Замовлення #" + transactionId + " для товару " + productId + " успішно скасовано.");
            } else {
                request.setAttribute("message", "Помилка скасування замовлення #" + transactionId + " для товару " + productId + ".");
            }
        } else {
            request.setAttribute("message", "Недійсний ID замовлення або ID товару для скасування.");
        }

        // Перенаправляємо запит назад на ту саму JSP сторінку
        request.getRequestDispatcher("unshippedItems.jsp").forward(request, response);
    }
}