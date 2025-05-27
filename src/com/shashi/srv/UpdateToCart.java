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

@WebServlet("/UpdateToCart")
public class UpdateToCart extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public UpdateToCart() {
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

        if (userName == null || password == null) {
            response.sendRedirect("login.jsp?message=Session Expired, Login Again!!");
            return;
        }

        String prodId = request.getParameter("pid");
        String fid = request.getParameter("fid");
        if (prodId == null || fid == null || prodId.trim().isEmpty() || fid.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Product ID or fid is missing");
            return;
        }

        int pQty;
        try {
            pQty = Integer.parseInt(request.getParameter("pqty"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid quantity");
            return;
        }

        CartServiceImpl cart = new CartServiceImpl();
        ProductServiceImpl productDao = new ProductServiceImpl();
        ProductBean product = productDao.getProductDetails(prodId);
        if (product == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
            return;
        }
        int availableQty = product.getProdQuantity();

        PrintWriter pw = response.getWriter();

        if (availableQty < pQty) {
            String status = cart.updateProductToCart(userName, prodId, availableQty, fid);
            status = "Only " + availableQty + " no of " + product.getProdName()
                    + " are available in the shop! So we are adding only " + availableQty + " products into Your Cart";

            DemandBean demandBean = new DemandBean(userName, product.getProdId(), pQty - availableQty);
            DemandServiceImpl demand = new DemandServiceImpl();
            boolean flag = demand.addProduct(demandBean);

            if (flag)
                status += "<br/>Later, We Will Mail You when " + product.getProdName()
                        + " will be available into the Store!";

            RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");
            rd.include(request, response);
            pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
        } else {
            String status = cart.updateProductToCart(userName, prodId, pQty, fid);
            RequestDispatcher rd = request.getRequestDispatcher("cartDetails.jsp");
            rd.include(request, response);
            pw.println("<script>document.getElementById('message').innerHTML='" + status + "'</script>");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
