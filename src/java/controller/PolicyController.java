package controller;

import dao.CategoryDAO;
import entity.Category;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// Controller này xử lý nhiều URL
@WebServlet(name = "PolicyController", urlPatterns = {
    "/shipping-policy", // Chính sách giao hàng
    "/return-policy",   // Chính sách đổi trả
    "/payment-policy",  // Chính sách thanh toán
    "/partner-policy"   // Chính sách đối tác
})
public class PolicyController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        // Lấy danh mục cho header
        CategoryDAO categoryDAO = new CategoryDAO();
        List<Category> categoryList = categoryDAO.getAllCategories();
        request.setAttribute("categoryList", categoryList);
        
        // Lấy đường dẫn URL mà người dùng gọi
        String servletPath = request.getServletPath();
        String forwardPage = "";
        String pageTitle = "";

        // Quyết định file JSP nào sẽ được hiển thị
        switch (servletPath) {
            case "/shipping-policy":
                pageTitle = "Chính sách giao hàng";
                forwardPage = "/policy/shipping-policy.jsp";
                break;
            case "/return-policy":
                pageTitle = "Chính sách đổi trả";
                forwardPage = "/policy/return-policy.jsp";
                break;
            case "/payment-policy":
                pageTitle = "Chính sách thanh toán";
                forwardPage = "/policy/payment-policy.jsp";
                break;
            case "/partner-policy":
                pageTitle = "Chính sách đối tác";
                forwardPage = "/policy/partner-policy.jsp";
                break;
            default:
                response.sendRedirect("home"); // Nếu URL lạ thì về trang chủ
                return;
        }

        request.setAttribute("pageTitle", pageTitle); // Gửi tiêu đề sang JSP
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}