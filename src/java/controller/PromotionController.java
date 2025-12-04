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
import service.PromotionService;

@WebServlet(name = "PromotionController", urlPatterns = {"/promotions"})
public class PromotionController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");

        // --- 1. LẤY TẤT CẢ THAM SỐ LỌC & TRANG ---
        
        // *** LẤY LỌC CATEGORY (SỬA LỖI Ở ĐÂY) ***
        String categoryId_raw = request.getParameter("cid");
        int categoryId = 0;
        try {
            // Chỉ parse nếu khác null và KHÔNG phải là chữ (như "newest")
            if (categoryId_raw != null && categoryId_raw.matches("\\d+")) {
                categoryId = Integer.parseInt(categoryId_raw);
            }
        } catch (NumberFormatException e) {
            // Nếu lỗi, mặc định là 0 (Tất cả sản phẩm)
            categoryId = 0;
        }
        Integer categoryIdFilter = (categoryId > 0) ? categoryId : null;

        // Lấy Lọc giá (priceRange)
        String[] priceRanges = request.getParameterValues("priceRange");
        Double minPrice = null;
        Double maxPrice = null;
        if (priceRanges != null && priceRanges.length > 0) {
            minPrice = Double.MAX_VALUE;
            maxPrice = 0.0;
            for (String range : priceRanges) {
                String[] prices = range.split("-");
                if (prices.length == 2) {
                    try {
                        double currentMin = Double.parseDouble(prices[0]);
                        double currentMax = Double.parseDouble(prices[1]);
                        if (currentMin < minPrice) minPrice = currentMin;
                        if (currentMax > maxPrice) maxPrice = currentMax;
                    } catch (NumberFormatException e) {}
                }
            }
            if (minPrice == Double.MAX_VALUE) minPrice = null;
            if (maxPrice == 0.0) maxPrice = null;
            if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
                maxPrice = Double.MAX_VALUE;
            }
        }

        // Lấy Sắp xếp (sort) - Đây là nơi chứa "newest"
        String sortParam = request.getParameter("sort");
        String sortBy = null;
        String sortOrder = null;
        if (sortParam != null) {
            switch (sortParam) {
                case "oldest": sortBy = "date"; sortOrder = "asc"; break;
                case "price_asc": sortBy = "price"; sortOrder = "asc"; break;
                case "price_desc": sortBy = "price"; sortOrder = "desc"; break;
                case "newest": default: sortBy = "date"; sortOrder = "desc"; break;
            }
        }

        // --- 2. XỬ LÝ PHÂN TRANG (SỬA LỖI Ở ĐÂY) ---
        final int PAGE_SIZE = 12;
        String page_raw = request.getParameter("page");
        int currentPage = 1;
        try {
            if (page_raw != null && page_raw.matches("\\d+")) {
                currentPage = Integer.parseInt(page_raw);
            }
        } catch (NumberFormatException e) {
            currentPage = 1;
        }

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Đếm tổng số sản phẩm
        int totalProducts = productDAO.countOnSaleProducts(categoryIdFilter, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1; // Đảm bảo ít nhất 1 trang
        if (currentPage > totalPages) currentPage = totalPages;

        int offset = (currentPage - 1) * PAGE_SIZE;

        // --- 3. LẤY DỮ LIỆU TRANG HIỆN TẠI ---
        List<Product> saleProductList = productDAO.getOnSaleProducts(categoryIdFilter, minPrice, maxPrice, sortBy, sortOrder, PAGE_SIZE, offset);
        
        // === LOGIC KHUYẾN MÃI TỰ ĐỘNG (DÙNG SERVICE) ===
        boolean isSpecialDay = PromotionService.isPromotionActive();
        
        if (isSpecialDay) {
            double discountRate = PromotionService.getDiscountRate();
            for (Product p : saleProductList) {
                double currentSalePrice = p.getSalePrice();
                double newSalePrice = currentSalePrice * (1.0 - discountRate);
                p.setSalePrice(newSalePrice);
            }
        }
        request.setAttribute("isSpecialDay", isSpecialDay);
        // =======================================================

        List<Category> categoryList = categoryDAO.getAllCategories();

        // --- 4. GỬI DỮ LIỆU SANG JSP ---
        request.setAttribute("saleProductList", saleProductList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activeCid", categoryId);
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