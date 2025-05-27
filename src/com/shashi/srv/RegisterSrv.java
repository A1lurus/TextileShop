package com.shashi.srv;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

@WebServlet("/RegisterSrv")
public class RegisterSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Встановлюємо кодування UTF-8 для запиту та відповіді
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        // Отримуємо параметри з урахуванням UTF-8
        String userName = request.getParameter("username");
        Long mobileNo = Long.parseLong(request.getParameter("mobile"));
        String emailId = request.getParameter("email");
        String address = request.getParameter("address");
        int pinCode = Integer.parseInt(request.getParameter("pincode"));
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String status = "";

        if (password != null && password.equals(confirmPassword)) {
            UserBean user = new UserBean(userName, mobileNo, emailId, address, pinCode, password);
            UserServiceImpl dao = new UserServiceImpl();
            status = dao.registerUser(user);
        } else {
            status = "Паролі не співпадають!";
        }

        // Кодуємо статусне повідомлення для URL
        String encodedStatus = URLEncoder.encode(status, StandardCharsets.UTF_8.toString());
        RequestDispatcher rd = request.getRequestDispatcher("register.jsp?message=" + encodedStatus);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Обробляємо POST запит так само як GET
        doGet(request, response);
    }
}