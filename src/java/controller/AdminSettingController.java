package controller;

import dao.SettingDAO;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminSettingController", urlPatterns = {"/admin/settings"})
public class AdminSettingController extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check Admin
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        if (user == null || !"admin".equals(user.getRole())) {
            response.sendRedirect("../login");
            return;
        }

        // Lấy config hiện tại để hiển thị lên form
        SettingDAO dao = new SettingDAO();
        request.setAttribute("promoEnable", dao.getValue("PROMO_ENABLE"));
        request.setAttribute("promoPercent", dao.getValue("PROMO_PERCENT"));
        request.setAttribute("promoDays", dao.getValue("PROMO_DAYS"));
        
        request.setAttribute("activePage", "settings");

        request.getRequestDispatcher("settings.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        
        String enable = request.getParameter("enable");
        String percent = request.getParameter("percent");
        String[] days = request.getParameterValues("days");
        
        // Xử lý chuỗi ngày (nối mảng thành chuỗi "MONDAY,TUESDAY")
        String daysStr = "";
        if (days != null) {
            daysStr = String.join(",", days);
        }

        SettingDAO dao = new SettingDAO();
        dao.updateValue("PROMO_ENABLE", enable);
        dao.updateValue("PROMO_PERCENT", percent);
        dao.updateValue("PROMO_DAYS", daysStr);

        request.setAttribute("msg", "Cập nhật thành công!");
        doGet(request, response); // Load lại trang
    }
}