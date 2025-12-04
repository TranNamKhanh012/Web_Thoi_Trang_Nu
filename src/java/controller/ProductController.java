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
import java.time.DayOfWeek;
import java.time.LocalDate;
import service.PromotionService;

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8"); // Đảm bảo đọc UTF-8

        // --- 1. LẤY TẤT CẢ THAM SỐ LỌC & TRANG ---
        // Lấy Category ID (cid)
        String categoryId_raw = request.getParameter("cid");
        int categoryId = 0;
        try {
            if (categoryId_raw != null) {
                categoryId = Integer.parseInt(categoryId_raw);
            }
        } catch (NumberFormatException e) {
        }

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
                        if (currentMin < minPrice) {
                            minPrice = currentMin;
                        }
                        if (currentMax > maxPrice) {
                            maxPrice = currentMax;
                        }
                    } catch (NumberFormatException e) {
                        /* Bỏ qua */ }
                }
            }
            if (minPrice == Double.MAX_VALUE) {
                minPrice = null;
            }
            if (maxPrice == 0.0) {
                maxPrice = null;
            }
            if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
                maxPrice = Double.MAX_VALUE;
            }
        }

        // Lấy Sắp xếp (sort)
        String sortParam = request.getParameter("sort");
        String sortBy = null;
        String sortOrder = null;
        if (sortParam != null) {
            switch (sortParam) {
                case "oldest":
                    sortBy = "date";
                    sortOrder = "asc";
                    break;
                case "price_asc":
                    sortBy = "price";
                    sortOrder = "asc";
                    break;
                case "price_desc":
                    sortBy = "price";
                    sortOrder = "desc";
                    break;
                case "newest":
                default:
                    sortBy = "date";
                    sortOrder = "desc";
                    break;
            }
        }

        // --- 2. XỬ LÝ PHÂN TRANG ---
        final int PAGE_SIZE = 12; // 12 sản phẩm mỗi trang
        String page_raw = request.getParameter("page");
        int currentPage = 1; // Trang hiện tại
        if (page_raw != null) {
            try {
                currentPage = Integer.parseInt(page_raw);
            } catch (NumberFormatException e) {
                currentPage = 1;
            }
        }

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        // Đếm tổng số sản phẩm (để tính tổng số trang)
        int totalProducts = productDAO.countProducts(categoryId > 0 ? categoryId : null, minPrice, maxPrice);
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);

        // Tính offset (vị trí bắt đầu lấy)
        int offset = (currentPage - 1) * PAGE_SIZE;

        // --- 3. LẤY DỮ LIỆU TRANG HIỆN TẠI ---
        List<Product> productList;
        if (categoryId == 0) {
            productList = productDAO.getAllProducts(minPrice, maxPrice, sortBy, sortOrder, PAGE_SIZE, offset);
        } else {
            productList = productDAO.getProductsByCategoryId(categoryId, minPrice, maxPrice, sortBy, sortOrder, PAGE_SIZE, offset);
        }

        // === LOGIC KHUYẾN MÃI TỰ ĐỘNG (DÙNG SERVICE) ===
        // 1. Kiểm tra xem có khuyến mãi không
        boolean isSpecialDay = PromotionService.isPromotionActive();
        
        if (isSpecialDay) {
            // 2. Lấy % giảm giá từ cấu hình
            double discountRate = PromotionService.getDiscountRate();

            for (Product p : productList) {
                // Lấy giá hiện tại (ưu tiên giá sale nếu có)
                double currentPrice = p.getSalePrice() > 0 ? p.getSalePrice() : p.getOriginalPrice();
                
                // Tính giá mới
                double newSalePrice = currentPrice * (1.0 - discountRate);
                
                // Ghi đè giá sale để hiển thị
                p.setSalePrice(newSalePrice);
            }
        }
        request.setAttribute("isSpecialDay", isSpecialDay);
        // ===============================================
        List<Category> categoryList = categoryDAO.getAllCategories();

        // --- 4. GỬI DỮ LIỆU SANG JSP ---
        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activeCid", categoryId);
        request.setAttribute("selectedPriceRanges", priceRanges != null ? List.of(priceRanges) : new ArrayList<String>());
        request.setAttribute("selectedSort", sortParam != null ? sortParam : "newest");
        request.setAttribute("activePage", "products");

        request.setAttribute("totalPages", totalPages); // Gửi tổng số trang
        request.setAttribute("currentPage", currentPage); // Gửi trang hiện tại

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}
