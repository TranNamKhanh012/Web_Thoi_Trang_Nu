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

@WebServlet(name = "ProductController", urlPatterns = {"/products"})
public class ProductController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    response.setContentType("text/html;charset=UTF-8");

        // Lấy category ID
        String categoryId_raw = request.getParameter("cid");
        int categoryId = 0;
        try { if (categoryId_raw != null) categoryId = Integer.parseInt(categoryId_raw); } catch (NumberFormatException e) {}

        // LẤY THAM SỐ LỌC GIÁ (dạng checkbox "priceRange=0-200000", "priceRange=200000-400000")
        String[] priceRanges = request.getParameterValues("priceRange");
        Double minPrice = null;
        Double maxPrice = null;
        // Tìm min và max từ các khoảng giá được chọn (nếu có chọn)
        if (priceRanges != null && priceRanges.length > 0) {
            minPrice = Double.MAX_VALUE; // Khởi tạo min lớn nhất
            maxPrice = 0.0; // Khởi tạo max nhỏ nhất
            for (String range : priceRanges) {
                String[] prices = range.split("-");
                if (prices.length == 2) {
                    try {
                        double currentMin = Double.parseDouble(prices[0]);
                        double currentMax = Double.parseDouble(prices[1]);
                        if (currentMin < minPrice) minPrice = currentMin;
                        if (currentMax > maxPrice) maxPrice = currentMax;
                    } catch (NumberFormatException e) { /* Bỏ qua khoảng giá lỗi */ }
                }
            }
             // Nếu không tìm thấy khoảng giá hợp lệ nào thì không lọc
            if (minPrice == Double.MAX_VALUE) minPrice = null;
            if (maxPrice == 0.0) maxPrice = null;
            // Nếu chỉ chọn 1 khoảng thì minPrice có thể lớn hơn maxPrice -> đặt lại maxPrice
            if(minPrice != null && maxPrice != null && minPrice > maxPrice) maxPrice = Double.MAX_VALUE; // Nếu chỉ chọn khoảng giá cao nhất, max không giới hạn
             // Nếu chỉ chọn khoảng giá thấp nhất, min = 0
            // (Logic này có thể cần điều chỉnh tùy cách bạn đặt value cho checkbox)
        }


        // LẤY THAM SỐ SẮP XẾP (dạng radio button "sort=newest", "sort=oldest", "sort=price_asc", "sort=price_desc")
        String sortParam = request.getParameter("sort");
        String sortBy = null; // Mặc định là null (sẽ là date trong DAO)
        String sortOrder = null; // Mặc định là null (sẽ là desc trong DAO)
        if (sortParam != null) {
            switch (sortParam) {
                case "oldest":
                    sortBy = "date"; // Sắp xếp theo ngày
                    sortOrder = "asc"; // Cũ nhất trước
                    break;
                case "price_asc":
                    sortBy = "price";
                    sortOrder = "asc";
                    break;
                case "price_desc":
                    sortBy = "price";
                    sortOrder = "desc";
                    break;
                case "newest": // Mặc định
                default:
                    sortBy = "date";
                    sortOrder = "desc";
                    break;
            }
        }

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();

        List<Product> productList;
        if (categoryId == 0) {
            productList = productDAO.getAllProducts(minPrice, maxPrice, sortBy, sortOrder);
        } else {
            productList = productDAO.getProductsByCategoryId(categoryId, minPrice, maxPrice, sortBy, sortOrder);
        }

        List<Category> categoryList = categoryDAO.getAllCategories();

        request.setAttribute("productList", productList);
        request.setAttribute("categoryList", categoryList);
        request.setAttribute("activeCid", categoryId);
        request.setAttribute("selectedPriceRanges", priceRanges != null ? List.of(priceRanges) : new ArrayList<String>()); // Gửi mảng các khoảng giá đã chọn
        request.setAttribute("selectedSort", sortParam != null ? sortParam : "newest"); // Gửi lựa chọn sort đã chọn
        request.setAttribute("activePage", "products");

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}