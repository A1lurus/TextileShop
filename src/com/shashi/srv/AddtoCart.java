package com.shashi.srv;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.shashi.beans.DemandBean;
import com.shashi.beans.ProductBean;
import com.shashi.service.impl.CartServiceImpl;
import com.shashi.service.impl.DemandServiceImpl;
import com.shashi.service.impl.ProductServiceImpl;

@WebServlet("/AddtoCart")
public class AddtoCart extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AddtoCart() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession();
        String userName = (String) session.getAttribute("username");
        String password = (String) session.getAttribute("password");
        String usertype = (String) session.getAttribute("usertype");
        if (userName == null || password == null || usertype == null || !usertype.equalsIgnoreCase("customer")) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again to Continue!");
            return;
        }

        String prodId = request.getParameter("pid");
        String fabricId = request.getParameter("fabricId");  // Новий параметр fabricId
        String action = request.getParameter("action");

        if (prodId == null || prodId.trim().isEmpty() || fabricId == null || fabricId.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID or fid is missing");
            return;
        }

        CartServiceImpl cart = new CartServiceImpl();
        ProductServiceImpl productDao = new ProductServiceImpl();
        PrintWriter pw = response.getWriter();

        try {
            ProductBean product = productDao.getProductDetails(prodId);
            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            int availableQty = product.getProdQuantity();
            int cartQty = cart.getProductCount(userName, prodId, fabricId);
            int pQty = 1;

            if ("remove".equals(action)) {
                String status = cart.removeProductFromCart(userName, prodId, fabricId);
                RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");
                rd.include(request, response);
                pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
                return;
            } else if ("add".equals(action) || "buy".equals(action)) {
                pQty += cartQty;

                if (availableQty < pQty) {
                    String status;
                    if (availableQty == 0) {
                        status = "Product is Out of Stock!";
                    } else {
                        cart.updateProductToCart(userName, prodId, availableQty, fabricId);
                        status = "Only " + availableQty + " no of " + product.getProdName()
                                + " are available in the shop! So we are adding only " + availableQty
                                + " products into Your Cart";
                    }
                    
                    DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);
                    DemandServiceImpl demand = new DemandServiceImpl();
                    boolean flag = demand.addProduct(demandBean);

                    if (flag) {
                        status += "<br/>Later, We Will Mail You when " + product.getProdName()
                                + " will be available into the Store!";
                    }

                    RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");
                    rd.include(request, response);
                    pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
                } else {
                    String status = cart.updateProductToCart(userName, prodId, pQty, fabricId);
                    if ("buy".equals(action)) {
                        response.sendRedirect("cartDetails.jsp");
                    } else {
                        RequestDispatcher rd = request.getRequestDispatcher("userHome.jsp");
                        rd.include(request, response);
                        pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
                    }
                }
            } else {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error processing request");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
