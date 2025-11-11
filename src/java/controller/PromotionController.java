package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import entity.Category;
import entity.Product;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(name = "PromotionController", urlPatterns = {"/promotions"})
public class PromotionController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");
    request.setCharacterEncoding("UTF-8");

    // --- 1. LẤY TẤT CẢ THAM SỐ LỌC & TRANG ---
    
    // *** LẤY LỌC CATEGORY ***
    String categoryId_raw = request.getParameter("cid");
    int categoryId = 0;
    try { if (categoryId_raw != null) categoryId = Integer.parseInt(categoryId_raw); } catch (NumberFormatException e) {}
    Integer categoryIdFilter = (categoryId > 0) ? categoryId : null; // Dùng Integer để có thể null

    // Lấy Lọc giá (priceRange)
    String[] priceRanges = request.getParameterValues("priceRange");
    Double minPrice = null;
    Double maxPrice = null;
    if (priceRanges != null && priceRanges.length > 0) {
        // ... (code xử lý priceRanges giữ nguyên) ...
        minPrice = Double.MAX_VALUE; maxPrice = 0.0;
        for (String range : priceRanges) { String[] prices = range.split("-"); if (prices.length == 2) { try { double currentMin = Double.parseDouble(prices[0]); double currentMax = Double.parseDouble(prices[1]); if (currentMin < minPrice) minPrice = currentMin; if (currentMax > maxPrice) maxPrice = currentMax; } catch (NumberFormatException e) {} } }
        if (minPrice == Double.MAX_VALUE) minPrice = null; if (maxPrice == 0.0) maxPrice = null; if(minPrice != null && maxPrice != null && minPrice > maxPrice) maxPrice = Double.MAX_VALUE;
    }
    
    // Lấy Sắp xếp (sort)
    String sortParam = request.getParameter("sort");
    String sortBy = null; String sortOrder = null;
    if (sortParam != null) {
        switch (sortParam) {
            case "oldest": sortBy = "date"; sortOrder = "asc"; break;
            case "price_asc": sortBy = "price"; sortOrder = "asc"; break;
            case "price_desc": sortBy = "price"; sortOrder = "desc"; break;
            case "newest": default: sortBy = "date"; sortOrder = "desc"; break;
        }
    }

    // --- 2. XỬ LÝ PHÂN TRANG ---
    final int PAGE_SIZE = 12;
    String page_raw = request.getParameter("page");
    int currentPage = 1;
    if (page_raw != null) { try { currentPage = Integer.parseInt(page_raw); } catch (NumberFormatException e) { currentPage = 1; } }
    
    ProductDAO productDAO = new ProductDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    
    // Đếm tổng số sản phẩm (truyền cả categoryIdFilter)
    int totalProducts = productDAO.countOnSaleProducts(categoryIdFilter, minPrice, maxPrice);
    int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
    
    int offset = (currentPage - 1) * PAGE_SIZE;

    // --- 3. LẤY DỮ LIỆU TRANG HIỆN TẠI ---
    List<Product> saleProductList = productDAO.getOnSaleProducts(categoryIdFilter, minPrice, maxPrice, sortBy, sortOrder, PAGE_SIZE, offset);
    
    List<Category> categoryList = categoryDAO.getAllCategories();
    
    // --- 4. GỬI DỮ LIỆU SANG JSP ---
    request.setAttribute("saleProductList", saleProductList);
    request.setAttribute("categoryList", categoryList);
    request.setAttribute("activeCid", categoryId); // *** GỬI CATEGORY ĐANG CHỌN ***
    request.setAttribute("selectedPriceRanges", priceRanges != null ? List.of(priceRanges) : new ArrayList<String>());
    request.setAttribute("selectedSort", sortParam != null ? sortParam : "newest");
    request.setAttribute("activePage", "promo");
    request.setAttribute("totalPages", totalPages);
    request.setAttribute("currentPage", currentPage);
    
    request.getRequestDispatcher("/promotions.jsp").forward(request, response);
}

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}
