package com.shashi.utility;

import java.util.Properties;
import java.util.ResourceBundle;
import java.util.logging.Level;
import java.util.logging.Logger;

import jakarta.mail.Authenticator;
import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

public class JavaMailUtil {
    public static void sendMail(String recipientMailId) throws MessagingException {
        System.out.println("Готуємося до відправки листа");
        Properties properties = new Properties();
        String host = "smtp.gmail.com";
        
        properties.put("mail.smtp.host", host);
        properties.put("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.mime.charset", "UTF-8");
        
        ResourceBundle rb = ResourceBundle.getBundle("application");
        String emailId = rb.getString("mailer.email");
        String passWord = rb.getString("mailer.password");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(emailId, passWord);
            }
        });

        Message message = prepareMessage(session, emailId, recipientMailId);
        Transport.send(message);
        System.out.println("Лист успішно відправлено!");
    }

    private static Message prepareMessage(Session session, String myAccountEmail, String recipientEmail) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myAccountEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            
            // Встановлення теми з кодуванням UTF-8
            message.setSubject("Ласкаво просимо до TextileShop", "UTF-8");
            
            // Встановлення тексту з кодуванням UTF-8
            message.setText("Привіт, " + recipientEmail + "! Дякуємо за реєстрацію у нашому сервісі!", "UTF-8");
            
            return message;
        } catch (Exception exception) {
            Logger.getLogger(JavaMailUtil.class.getName()).log(Level.SEVERE, null, exception);
        }
        return null;
    }

    protected static void sendMail(String recipient, String subject, String htmlTextMessage) throws MessagingException {
        System.out.println("Готуємося до відправки листа");
        Properties properties = new Properties();
        String host = "smtp.gmail.com";
        
        properties.put("mail.smtp.host", host);
        properties.put("mail.transport.protocol", "smtp");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");
        properties.put("mail.smtp.port", "587");
        properties.put("mail.mime.charset", "UTF-8");
        
        ResourceBundle rb = ResourceBundle.getBundle("application");
        String emailId = rb.getString("mailer.email");
        String passWord = rb.getString("mailer.password");

        Session session = Session.getInstance(properties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(emailId, passWord);
            }
        });

        Message message = prepareMessage(session, emailId, recipient, subject, htmlTextMessage);
        Transport.send(message);
        System.out.println("Лист успішно відправлено!");
    }

    private static Message prepareMessage(Session session, String myAccountEmail, String recipientEmail, 
                                        String subject, String htmlTextMessage) {
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(myAccountEmail));
            message.setRecipient(Message.RecipientType.TO, new InternetAddress(recipientEmail));
            
            // Встановлення теми з кодуванням UTF-8
            message.setSubject(subject, "UTF-8");
            
            // Встановлення HTML-вмісту з кодуванням UTF-8
            message.setContent(htmlTextMessage, "text/html; charset=UTF-8");
            
            return message;
        } catch (Exception exception) {
            Logger.getLogger(JavaMailUtil.class.getName()).log(Level.SEVERE, null, exception);
        }
        return null;
    }
}