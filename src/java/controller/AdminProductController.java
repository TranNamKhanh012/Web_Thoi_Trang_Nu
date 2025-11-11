package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductSizeDAO;
import entity.Category;
import entity.Product;
import entity.ProductSize;
import entity.User;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "AdminProductController", urlPatterns = {"/admin/products"})
public class AdminProductController extends HttpServlet {

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

        ProductDAO productDAO = new ProductDAO();
        CategoryDAO categoryDAO = new CategoryDAO();
        ProductSizeDAO sizeDAO = new ProductSizeDAO();

        String action = request.getParameter("action");
        String id_raw = request.getParameter("pid");
        int id = -1;
        if (id_raw != null) { try { id = Integer.parseInt(id_raw); } catch (NumberFormatException e) {} }
        String keyword = request.getParameter("keyword");

        final int PAGE_SIZE = 12;
        String page_raw = request.getParameter("page");
        int currentPage = 1;
        if (page_raw != null) { try { currentPage = Integer.parseInt(page_raw); } catch (NumberFormatException e) { currentPage = 1; } }
        int offset = (currentPage - 1) * PAGE_SIZE;

        String forwardPage = "/admin/product_list.jsp";
        request.setAttribute("activePage", "products");

        if (action != null) {
            switch (action) {
                case "add":
                    request.setAttribute("product", new Product());
                    request.setAttribute("allCategories", categoryDAO.getAllCategories());
                    request.setAttribute("productSizes", new ArrayList<ProductSize>());
                    forwardPage = "/admin/product_form.jsp";
                    break;
                case "edit":
                    if (id != -1) {
                        Product productToEdit = productDAO.getProductById(id);
                        if (productToEdit != null) {
                            List<ProductSize> sizes = sizeDAO.getSizesByProductId(id);
                            request.setAttribute("product", productToEdit);
                            request.setAttribute("allCategories", categoryDAO.getAllCategories());
                            request.setAttribute("productSizes", sizes);
                            forwardPage = "/admin/product_form.jsp";
                        } else {
                            session.setAttribute("adminErrorMsg", "Không tìm thấy sản phẩm (ID=" + id + ")");
                            response.sendRedirect(request.getContextPath() + "/admin/products"); return;
                        }
                    } else {
                        session.setAttribute("adminErrorMsg", "ID Sản phẩm không hợp lệ.");
                        response.sendRedirect(request.getContextPath() + "/admin/products"); return;
                    }
                    break;
                case "save":
                    // --- BẮT ĐẦU XỬ LÝ LƯU ---
                    Product product = new Product();
                    List<ProductSize> sizeList = new ArrayList<>();
                    int categoryId = 0;
                    
                    try {
                        // Lấy thông tin chung
                        String name = request.getParameter("name");
                        String description = request.getParameter("description");
                        String originalPriceStr = request.getParameter("originalPrice");
                        String salePriceStr = request.getParameter("salePrice");
                        String imageUrl = request.getParameter("imageUrl");
                        String categoryIdStr = request.getParameter("categoryId");
                        
                        // Validate dữ liệu
                        if (name == null || name.trim().isEmpty() || originalPriceStr == null || originalPriceStr.trim().isEmpty() || categoryIdStr == null || categoryIdStr.isEmpty()) {
                            throw new Exception("Tên sản phẩm, Giá gốc và Danh mục là bắt buộc.");
                        }

                        double originalPrice = Double.parseDouble(originalPriceStr);
                        double salePrice = (salePriceStr == null || salePriceStr.trim().isEmpty()) ? 0 : Double.parseDouble(salePriceStr);
                        categoryId = Integer.parseInt(categoryIdStr);
                        
                        // Lấy thông tin size và số lượng
                        String[] sizes = request.getParameterValues("size[]");
                        String[] stocks = request.getParameterValues("stock[]");
                        
                        if (sizes == null || stocks == null || sizes.length == 0) {
                               throw new Exception("Sản phẩm phải có ít nhất một size.");
                        }

                        // =================== PHẦN SỬA LỖI ===================
                        for (int i = 0; i < sizes.length; i++) {
                            // Chỉ xử lý nếu cả 'size' và 'stock' đều tồn tại và không rỗng
                            if (sizes[i] != null && !sizes[i].trim().isEmpty() && 
                                stocks[i] != null && !stocks[i].trim().isEmpty()) {
                                
                                try {
                                    // Thêm .trim() để phòng trường hợp có khoảng trắng
                                    int stock = Integer.parseInt(stocks[i].trim()); 
                                    
                                    if (stock >= 0) { // Chỉ thêm nếu số lượng hợp lệ
                                        ProductSize ps = new ProductSize();
                                        ps.setSize(sizes[i].trim().toUpperCase());
                                        ps.setStock(stock);
                                        sizeList.add(ps);
                                    }
                                } catch (NumberFormatException e) {
                                    // Bắt lỗi nếu ai đó nhập chữ "abc" vào ô số lượng
                                    throw new Exception("Số lượng tồn kho cho size '" + sizes[i] + "' không hợp lệ (phải là số).");
                                }
                            }
                            // Nếu size[i] hoặc stocks[i] rỗng, ta tự động bỏ qua (không thêm vào list)
                            // -> Đây là logic mong muốn.
                        }
                        
                        if (sizeList.isEmpty()){
                             throw new Exception("Cần ít nhất một size hợp lệ (đã nhập cả tên size và số lượng > 0).");
                        }
                        // ================= KẾT THÚC PHẦN SỬA LỖI =================

                        // Gán thông tin vào đối tượng product
                        product.setName(name);
                        product.setDescription(description);
                        product.setOriginalPrice(originalPrice);
                        product.setSalePrice(salePrice);
                        product.setImageUrl(imageUrl);
                        product.setCategoryId(categoryId); // Gán categoryId cho product
                        if (id != -1) product.setId(id); // Gán ID nếu là sửa

                        // Gọi DAO để lưu
                        if (id == -1) { // Thêm mới
                            int newProductId = productDAO.addProduct(product, sizeList, categoryId);
                            if(newProductId != -1) session.setAttribute("adminSuccessMsg", "Thêm sản phẩm thành công!");
                            else session.setAttribute("adminErrorMsg", "Thêm sản phẩm thất bại (Lỗi DAO).");
                        } else { // Cập nhật
                            productDAO.updateProduct(product, sizeList, categoryId);
                            session.setAttribute("adminSuccessMsg", "Cập nhật sản phẩm thành công!");
                        }
                        response.sendRedirect(request.getContextPath() + "/admin/products"); return;

                    } catch (Exception e) {
                        // Nếu có lỗi (ví dụ: nhập chữ vào giá, thiếu size...)
                        e.printStackTrace();
                        // Gửi lỗi sang JSP để hiển thị
                        request.setAttribute("formError", "Lỗi: " + e.getMessage()); 
                        
                        // Gửi lại các giá trị đã nhập (để giữ form)
                        product.setId(id); // Giữ lại ID nếu là sửa
                        product.setName(request.getParameter("name"));
                        product.setDescription(request.getParameter("description"));
                        try { product.setOriginalPrice(Double.parseDouble(request.getParameter("originalPrice"))); } catch (Exception ex) {}
                        try { product.setSalePrice(Double.parseDouble(request.getParameter("salePrice"))); } catch (Exception ex) {}
                        product.setImageUrl(request.getParameter("imageUrl"));
                        try { product.setCategoryId(Integer.parseInt(request.getParameter("categoryId"))); } catch (Exception ex) {}
                        
                        request.setAttribute("product", product); // Gửi lại product
                        request.setAttribute("allCategories", categoryDAO.getAllCategories()); // Gửi lại danh mục
                        
                        // Gửi lại danh sách size đã nhập (dù có thể nó là rỗng)
                        // Note: Việc giữ lại sizeList đã nhập trước đó sẽ hơi phức tạp
                        // Ở đây ta tạm gửi lại 1 list rỗng (nếu thêm mới) hoặc load lại (nếu edit)
                        if(id == -1) {
                            request.setAttribute("productSizes", sizeList); // Giữ lại size nếu nhập lỗi
                        } else {
                            // Nếu là edit, an toàn nhất là load lại size cũ
                             request.setAttribute("productSizes", sizeDAO.getSizesByProductId(id));
                        }
                        
                        forwardPage = "/admin/product_form.jsp"; // Quay lại form
                        request.getRequestDispatcher(forwardPage).forward(request, response); // Dùng forward để giữ lại request
                        return;
                    }
                    // --- KẾT THÚC XỬ LÝ LƯU ---

                case "delete":
                    if (id != -1) {
                        productDAO.deleteProduct(id);
                        session.setAttribute("adminSuccessMsg", "Xóa sản phẩm thành công!");
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/products"); return;
                
                default:
                    break;
            }
        } 
        
        // --- Logic Hiển thị Danh sách (Mặc định) ---
        List<Product> productList;
        int totalProducts;
        if (keyword != null && !keyword.trim().isEmpty()) {
            totalProducts = productDAO.countSearchProductsAdmin(keyword.trim());
            productList = productDAO.searchProductsAdmin(keyword.trim(), PAGE_SIZE, offset);
            request.setAttribute("searchKeyword", keyword);
        } else {
            totalProducts = productDAO.countProducts(null, null, null); 
            productList = productDAO.getAllProducts(null, null, null, null, PAGE_SIZE, offset);
        }
        int totalPages = (int) Math.ceil((double) totalProducts / PAGE_SIZE);
        request.setAttribute("productList", productList);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", currentPage);
        
        request.getRequestDispatcher(forwardPage).forward(request, response);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        processRequest(request, response);
    }
}