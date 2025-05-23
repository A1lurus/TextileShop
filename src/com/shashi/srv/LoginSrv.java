package com.shashi.srv;

import java.io.IOException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.beans.UserBean;
import com.shashi.service.impl.UserServiceImpl;

/**
 * Servlet implementation class LoginSrv
 */
@WebServlet("/LoginSrv")
public class LoginSrv extends HttpServlet {
	private static final long serialVersionUID = 1L;

	public LoginSrv() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String userName = request.getParameter("username");
	    String password = request.getParameter("password");
	    response.setContentType("text/html");

	    String status = "Login Denied! Invalid Username or password.";
	    UserServiceImpl udao = new UserServiceImpl();
	    status = udao.isValidCredential(userName, password);
	    
	    if (status.equalsIgnoreCase("valid")) {
	        // valid user
	        UserBean user = udao.getUserDetails(userName, password);
	        HttpSession session = request.getSession();
	        String userType = udao.getUserRole(userName);
	        
	        if ("admin".equalsIgnoreCase(userType)) {
	            RequestDispatcher rd = request.getRequestDispatcher("adminStock.jsp");
	            session.setAttribute("username", userName);
	            session.setAttribute("password", password);
	            session.setAttribute("usertype", userType);
	            rd.forward(request, response);
	        } else if ("customer".equalsIgnoreCase(userType)) {
	            session.setAttribute("userdata", user);
	            session.setAttribute("username", userName);
	            session.setAttribute("password", password);
	            session.setAttribute("usertype", userType);
	            RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");
	            rd.forward(request, response);
	        } else {
	            // invalid user type
	            RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=Invalid user type");
	            rd.forward(request, response);
	        }
	    } else {
	        // invalid credentials
	        RequestDispatcher rd = request.getRequestDispatcher("login.jsp?message=" + status);
	        rd.forward(request, response);
	    }
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doGet(request, response);
	}

}