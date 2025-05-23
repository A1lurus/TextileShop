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
import com.shashi.service.impl.UserServiceImpl;
import com.shashi.utility.MailMessage;

@WebServlet("/ShipmentServlet")
public class ShipmentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public ShipmentServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set UTF-8 encoding for request and response
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        if (userType == null) {
            response.sendRedirect("login.jsp?message=Access Denied, Login Again!!");
            return;
        }

        String orderId = request.getParameter("orderid");
        String prodId = request.getParameter("prodid");
        String userName = request.getParameter("userid");
        Double amount = Double.parseDouble(request.getParameter("amount"));
        
        // Тут відбувається виклик методу, який збільшить кількість товару на складі
        String status = new OrderServiceImpl().shipNow(orderId, prodId); 
        
        String pagename = "shippedItems.jsp";
        if ("FAILURE".equalsIgnoreCase(status) || status.contains("Failed to update product quantity")) { 
            pagename = "unshippedItems.jsp";
            request.setAttribute("message", status); 
            RequestDispatcher rd = request.getRequestDispatcher(pagename);
            rd.forward(request, response); 
            return; 
        } else {
            MailMessage.orderShipped(userName, new UserServiceImpl().getFName(userName), orderId, amount);
        }
        
        request.setAttribute("message", status);
        RequestDispatcher rd = request.getRequestDispatcher("unshippedItems.jsp");
        rd.forward(request, response);
        
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}