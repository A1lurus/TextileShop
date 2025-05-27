<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page
    import="com.shashi.service.impl.*, com.shashi.service.*,com.shashi.beans.*,java.util.*,javax.servlet.ServletOutputStream,java.io.*"%>
<!DOCTYPE html>
<html>
<head>
<title>Textileshop - Оплата</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet"
    href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<link rel="stylesheet" href="css/changes.css">
<script
    src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
    src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>
<style>
    .payment-container {
        background-color: white;
        border-radius: 10px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        padding: 25px;
        margin-top: 30px;
        margin-bottom: 30px;
    }
    .payment-header {
        color: #0066cc;
        margin-bottom: 25px;
        text-align: center;
    }
    .payment-image {
        max-height: 80px;
        margin-bottom: 15px;
    }
    .pay-btn {
        background-color: #0066cc;
        border: none;
        padding: 10px 20px;
        font-weight: bold;
        margin-top: 10px;
    }
    .pay-btn:hover {
        background-color: #0055aa;
    }
</style>
</head>
<body style="background-color: #E6F9E6;">

    <%
    /* Перевірка авторизації */
    String userName = (String) session.getAttribute("username");
    String password = (String) session.getAttribute("password");

    if (userName == null || password == null) {
        response.sendRedirect("login.jsp?message=Сесія закінчилась, увійдіть знову!!");
    }

    String sAmount = request.getParameter("amount");
    double amount = 0;
    if (sAmount != null) {
        amount = Double.parseDouble(sAmount);
    }
    %>

    <jsp:include page="header.jsp" />

    <div class="container">
        <div class="row">
            <div class="col-md-6 col-md-offset-3 payment-container">
                <form action="./OrderServlet" method="post">
                    <div class="payment-header">
                        <h2>Оплата карткою</h2>
                        <hr style="border-color: #ddd;">
                    </div>
                    
                    <div class="form-group">
                        <label for="cardholder">Ім'я власника картки</label>
                        <input type="text" class="form-control" id="cardholder" 
                            name="cardholder" placeholder="Введіть ім'я" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="cardnumber">Номер картки</label>
                        <input type="text" class="form-control" id="cardnumber" 
                            name="cardnumber" placeholder="4242 4242 4242 4242" required>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="expmonth">Місяць закінчення</label>
                            <input type="text" class="form-control" id="expmonth" 
                                name="expmonth" placeholder="MM" maxlength="2" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label for="expyear">Рік закінчення</label>
                            <input type="text" class="form-control" id="expyear" 
                                name="expyear" placeholder="РРРР" maxlength="4" required>
                        </div>
                    </div>
                    
                    <div class="row">
                        <div class="col-md-6 form-group">
                            <label for="cvv">CVV код</label>
                            <input type="text" class="form-control" id="cvv" 
                                name="cvv" placeholder="123" maxlength="3" required>
                        </div>
                        <div class="col-md-6 form-group">
                            <label>Сума до оплати</label>
                            <div class="input-group">
                                <span class="input-group-addon">₴</span>
                                <input type="text" class="form-control" 
                                    value="<%=String.format("%.2f", amount)%>" readonly>
                            </div>
                            <input type="hidden" name="amount" value="<%=amount%>">
                        </div>
                    </div>
                    
                    <div class="text-center">
                        <button type="submit" class="btn btn-primary pay-btn">
                            Підтвердити оплату
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="footer.html"%>

</body>
</html>