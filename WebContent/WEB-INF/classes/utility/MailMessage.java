package com.shashi.utility;

import jakarta.mail.MessagingException;

public class MailMessage {
    public static void registrationSuccess(String emailId, String name) {
        String recipient = emailId;
        String subject = "Успішна реєстрація";
        String htmlTextMessage = "" + "<html>" + "<body>"
                + "<h2 style='color:green;'>Ласкаво просимо до Textileshop</h2>" + "" + "Вітаємо, " + name + ","
                + "<br><br>Дякуємо за реєстрацію в Textileshop.<br>"
                + "Ми раді, що ви обрали нас. Запрошуємо переглянути нашу нову колекцію текстильних виробів."
                + "<br>Будь ласка, відвідайте наш сайт та ознайомтесь з асортиментом."
                + "Гарного дня!<br>" + "" + "</body>" + "</html>";
        try {
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void transactionSuccess(String recipientEmail, String name, String transId, double transAmount) {
        String recipient = recipientEmail;
        String subject = "Замовлення оформлено в Textileshop";
        String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Вітаємо, " + name + ",<br/><br/>"
                + "      Ми раді, що ви робите покупки в Textileshop!" + "      <br/><br/>"
                + "      Ваше замовлення успішно оформлено і готується до відправки."
                + "<br/><h6>Зверніть увагу: це тестовий лист, ви не здійснювали реальної покупки!</h6>"
                + "      <br/>" + "      Деталі транзакції:<br/>" + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Номер замовлення:</font>"
                + "      <font style=\"color:green;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Сплачено:</font> <font style=\"color:green;font-weight:bold;\">"
                + transAmount + " грн</font>" + "      <br/><br/>" + "      Дякуємо за покупку!<br/><br/>"
                + "      Заходьте ще! <br/<br/> <font style=\"color:green;font-weight:bold;\">Textileshop</font>"
                + "    </p>" + "    " + "  </body>" + "</html>";

        try {
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void orderShipped(String recipientEmail, String name, String transId, double transAmount) {
        String recipient = recipientEmail;
        String subject = "Ваше замовлення відправлено з Textileshop";
        String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Вітаємо, " + name + ",<br/><br/>"
                + "      Ми раді, що ви робите покупки в Textileshop!" + "      <br/><br/>"
                + "      Ваше замовлення успішно відправлено і знаходиться в дорозі."
                + "<br/><h6>Зверніть увагу: це тестовий лист, ви не здійснювали реальної покупки!</h6>"
                + "      <br/>" + "      Деталі транзакції:<br/>" + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Номер замовлення:</font>"
                + "      <font style=\"color:green;font-weight:bold;\">" + transId + "</font><br/>" + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Сплачено:</font> <font style=\"color:green;font-weight:bold;\">"
                + transAmount + " грн</font>" + "      <br/><br/>" + "      Дякуємо за покупку!<br/><br/>"
                + "      Заходьте ще! <br/<br/> <font style=\"color:green;font-weight:bold;\">Textileshop</font>"
                + "    </p>" + "    " + "  </body>" + "</html>";

        try {
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static void productAvailableNow(String recipientEmail, String name, String prodName, String prodId) {
        String recipient = recipientEmail;
        String subject = "Товар " + prodName + " тепер доступний в Textileshop";
        String htmlTextMessage = "<html>" + "  <body>" + "    <p>" + "      Вітаємо, " + name + ",<br/><br/>"
                + "      Ми раді, що ви обираєте Textileshop!" + "      <br/><br/>"
                + "      Як ми помітили, ви цікавились товаром, який раніше був відсутній у достатній кількості."
                + " <br/><br/>"
                + "Раді повідомити, що товар <font style=\"color:green;font-weight:bold;\">" + prodName
                + "</font> з " + "артикулом <font style=\"color:green;font-weight:bold;\">" + prodId
                + "</font> тепер доступний у нашому магазині!"
                + "<br/><h6>Зверніть увагу: це тестовий лист, ви не здійснювали реальних покупок!</h6>"
                + "      <br/>" + "      Інформація про товар:<br/>"
                + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Артикул: </font><font style=\"color:green;font-weight:bold;\">"
                + prodId + " " + "      </font><br/>" + "      <br/>"
                + "      <font style=\"color:red;font-weight:bold;\">Назва товару: </font> <font style=\"color:green;font-weight:bold;\">"
                + prodName + "</font>" + "      <br/><br/>" + "      Дякуємо, що обираєте нас!<br/><br/>"
                + "      Запрошуємо до покупок! <br/<br/><br/> <font style=\"color:green;font-weight:bold;\">Textileshop</font>"
                + "    </p>" + "    " + "  </body>" + "</html>";

        try {
            JavaMailUtil.sendMail(recipient, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }

    public static String sendMessage(String toEmailId, String subject, String htmlTextMessage) {
        try {
            JavaMailUtil.sendMail(toEmailId, subject, htmlTextMessage);
        } catch (MessagingException e) {
            e.printStackTrace();
            return "ПОМИЛКА";
        }
        return "УСПІХ";
    }
}
