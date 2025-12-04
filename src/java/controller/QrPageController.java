package controller;

import dao.QrDAO;
import java.io.IOException;
import java.util.UUID;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "QrPageController", urlPatterns = {"/login-qr"})
public class QrPageController extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. Tạo một mã ngẫu nhiên
        String token = UUID.randomUUID().toString();
        
        // 2. Lưu vào DB
        QrDAO dao = new QrDAO();
        dao.createToken(token);
        
        // 3. Gửi mã này sang JSP để tạo ảnh QR
        request.setAttribute("qrToken", token);
        request.getRequestDispatcher("login_qr.jsp").forward(request, response);
    }
}