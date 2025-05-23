package com.shashi.srv;

import java.io.IOException;
//import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.shashi.service.impl.OrderServiceImpl;

@WebServlet("/OrderServlet")
public class OrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
            return;
        }

        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
            return;
        }

        try {
            double paidAmount = Double.parseDouble(request.getParameter("amount"));
            OrderServiceImpl orderService = new OrderServiceImpl();
            String status = orderService.paymentSuccess(userName, paidAmount);

            request.setAttribute("message", status);
            RequestDispatcher rd = request.getRequestDispatcher("orderDetails.jsp");
            rd.forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("payment.jsp?error=Невірний формат суми оплати");
        } catch (Exception e) {
            response.sendRedirect("payment.jsp?error=Помилка при обробці оплати: " + e.getMessage());
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        doGet(request, response);
    }
}
