package com.shashi.srv;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.service.impl.FabricTypeServiceImpl;

/**
 * Servlet implementation class AddFabricTypeSrv
 */
@WebServlet("/AddFabricTypeSrv")
public class AddFabricTypeSrv extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Встановлюємо кодування UTF-8 для запиту та відповіді
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        String userType = (String) session.getAttribute("usertype");
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");

        if (userType == null || !userType.equals("admin")) {
            response.sendRedirect("login.jsp?message=Access Denied!");
            return;
        }
        else if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again to Continue!");
            return;
        }

        String status = "Fabric Type Registration Failed!";
        String fabricTypeName = request.getParameter("fabric_type_name");
        double pricePerMeter = Double.parseDouble(request.getParameter("price_per_meter"));

        FabricTypeServiceImpl fabricTypeService = new FabricTypeServiceImpl();
        status = fabricTypeService.addFabricType(fabricTypeName, pricePerMeter);

        RequestDispatcher rd = request.getRequestDispatcher("addFabricType.jsp?message=" + status);
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}