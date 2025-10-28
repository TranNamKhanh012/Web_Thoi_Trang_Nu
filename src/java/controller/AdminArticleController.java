package controller;

import dao.ArticleDAO;
import entity.Article;
import entity.User;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminArticleController", urlPatterns = {"/admin/articles"})
public class AdminArticleController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        User adminUser = (User) session.getAttribute("acc");
        if (adminUser == null || !"admin".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        ArticleDAO articleDAO = new ArticleDAO();
        String action = request.getParameter("action");
        String id_raw = request.getParameter("id");
        int id = -1;
        if (id_raw != null) {
            try { id = Integer.parseInt(id_raw); } catch (NumberFormatException e) {}
        }

        String forwardPage = "article_list.jsp"; // Trang mặc định
        request.setAttribute("activePage", "articles"); // Đánh dấu sidebar

        // Xử lý các action
        if (action != null) {
            switch (action) {
                case "add": // Hiển thị form thêm mới
                    request.setAttribute("article", new Article()); // Gửi article rỗng
                    forwardPage = "article_form.jsp";
                    break;
                case "edit": // Hiển thị form sửa
                    if (id != -1) {
                        Article articleToEdit = articleDAO.getArticleById(id);
                        request.setAttribute("article", articleToEdit); // Gửi article cần sửa
                        forwardPage = "article_form.jsp";
                    } else {
                        response.sendRedirect(request.getContextPath() + "/admin/articles");
                        return;
                    }
                    break;
                case "save": // Lưu (thêm mới hoặc cập nhật)
                    String title = request.getParameter("title");
                    String content = request.getParameter("content");
                    String imageUrl = request.getParameter("imageUrl");
                    
                    if (title != null && !title.trim().isEmpty() && content != null && !content.trim().isEmpty()) {
                        if (id == -1) { // Thêm mới
                             articleDAO.addArticle(title.trim(), content.trim(), imageUrl, adminUser.getId());
                        } else { // Cập nhật
                             articleDAO.updateArticle(id, title.trim(), content.trim(), imageUrl);
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/articles");
                    return; // Chuyển hướng ngay sau khi lưu
                case "delete":
                    if (id != -1) {
                        articleDAO.deleteArticle(id);
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/articles");
                    return; // Chuyển hướng ngay sau khi xóa
                default: // Hiển thị danh sách (mặc định)
                    List<Article> articleList = articleDAO.getAllArticles();
                    request.setAttribute("articleList", articleList);
                    forwardPage = "article_list.jsp";
                    break;
            }
        } else {
            // Mặc định: Hiển thị danh sách
            List<Article> articleList = articleDAO.getAllArticles();
            request.setAttribute("articleList", articleList);
        }
        
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}