package com.shashi.srv;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.shashi.service.impl.ProductServiceImpl;
import com.shashi.service.impl.FabricServiceImpl;

@WebServlet("/ShowImage")
public class ShowImage extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String prodId = request.getParameter("pid");
        String fabricId = request.getParameter("fabricId");
        byte[] image = null;

        try {
            // Визначаємо, чи це товар чи тканина
            if (prodId != null) {
                ProductServiceImpl productDao = new ProductServiceImpl();
                image = productDao.getImage(prodId);
            } else if (fabricId != null) {
                FabricServiceImpl fabricDao = new FabricServiceImpl();
                image = fabricDao.getFabricImage(fabricId);
                
                // Опціонально: зменшуємо розмір зображення для тканин
                if (image != null && image.length > 0) {
                    image = resizeImageForFabric(image, 100, 100); // 100x100 пікселів
                }
            }

            // Якщо зображення не знайдено - використовуємо заглушку
            if (image == null || image.length == 0) {
                image = getDefaultImage(request);
            }

            // Відправляємо зображення
            response.setContentType("image/jpeg");
            try (ServletOutputStream sos = response.getOutputStream()) {
                sos.write(image);
            }
        } catch (Exception e) {
            // У разі помилки відправляємо зображення-заглушку
            byte[] defaultImage = getDefaultImage(request);
            response.setContentType("image/jpeg");
            try (ServletOutputStream sos = response.getOutputStream()) {
                sos.write(defaultImage);
            }
        }
    }

    private byte[] resizeImageForFabric(byte[] originalImageBytes, int width, int height) throws IOException {
        ByteArrayInputStream bais = new ByteArrayInputStream(originalImageBytes);
        BufferedImage originalImage = ImageIO.read(bais);
        
        BufferedImage resizedImage = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = resizedImage.createGraphics();
        g.drawImage(originalImage, 0, 0, width, height, null);
        g.dispose();
        
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(resizedImage, "jpg", baos);
        return baos.toByteArray();
    }

    private byte[] getDefaultImage(HttpServletRequest request) throws IOException {
        File fnew = new File(request.getServletContext().getRealPath("images/noimage.jpg"));
        BufferedImage originalImage = ImageIO.read(fnew);
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(originalImage, "jpg", baos);
        return baos.toByteArray();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}