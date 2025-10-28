package controller;

import dao.ArticleDAO;
import dao.CategoryDAO;
import entity.Article;
import entity.Category;
import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "ArticleDetailController", urlPatterns = {"/article"})
public class ArticleDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            
            ArticleDAO articleDAO = new ArticleDAO();
            CategoryDAO categoryDAO = new CategoryDAO();
            
            Article article = articleDAO.getArticleById(id);
            List<Category> categoryList = categoryDAO.getAllCategories();
            
            request.setAttribute("article", article);
            request.setAttribute("categoryList", categoryList);
            
            request.getRequestDispatcher("article-detail.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}