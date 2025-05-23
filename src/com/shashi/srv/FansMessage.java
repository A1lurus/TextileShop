package com.shashi.srv;

import java.io.IOException;
//import java.net.URLEncoder;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.utility.MailMessage;

@WebServlet("/fansMessage")
public class FansMessage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Встановлення UTF-8 кодування
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String comments = request.getParameter("comments");

        // Формування HTML-листа українською
        String htmlTextMessage = "<html><body>"
                + "<h2 style='color:green;'>Повідомлення для TextileShop</h2>"
                + "Отримано нове повідомлення від клієнта!<br/><br/>"
                + "Ім'я: " + name + ",<br/><br/>"
                + "Email: " + email + "<br><br/>"
                + "Коментар: <span style='color:grey;'>" + comments + "</span>"
                + "<br/><br/>Ми раді, що Ви обрали наш магазин!"
                + "<br/><br/>З повагою,<br/>Команда TextileShop"
                + "</body></html>";

        // Відправка листа
        String message = MailMessage.sendMessage("ivangroznui2013@gmail.com", 
                "Повідомлення клієнта | " + name + " | " + email, htmlTextMessage);

        // Формування повідомлення про результат
        String userMessage;
        if ("SUCCESS".equals(message)) {
            userMessage = "Повідомлення успішно надіслано! Дякуємо за ваш відгук.";
        } else {
            userMessage = "Помилка: Не вдалося надіслати повідомлення. Спробуйте пізніше.";
        }

        // Відображення результату
        RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.include(request, response);
        
        // Виведення сповіщення з екрануванням спецсимволів
        response.getWriter().print("<script>alert('" + escapeJavaScript(userMessage) + "')</script>");
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // Метод для екранування спецсимволів у JavaScript
    private String escapeJavaScript(String input) {
        if (input == null) return "";
        return input.replace("'", "\\'")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r");
    }
}