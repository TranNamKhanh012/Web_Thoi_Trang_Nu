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

@WebServlet(name = "NewsController", urlPatterns = {"/news"})
public class NewsController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        ArticleDAO articleDAO = new ArticleDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Article> articleList = articleDAO.getAllArticles();
        List<Category> categoryList = categoryDAO.getAllCategories();
        
        request.setAttribute("articleList", articleList);
        request.setAttribute("categoryList", categoryList);
        
        request.setAttribute("activePage", "news");
        request.getRequestDispatcher("news.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}