package controller;

import dao.CategoryDAO;
import dao.ProductDAO;
import dao.ProductSizeDAO;
import entity.Product;
import entity.ProductSize;
import entity.User;
import java.io.IOException;
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
    CategoryDAO categoryDAO = new CategoryDAO(); // Cần cho dropdown danh mục
    ProductSizeDAO sizeDAO = new ProductSizeDAO();   // Cần cho size

    String action = request.getParameter("action");
    String id_raw = request.getParameter("pid"); // Dùng pid cho product id
    int id = -1;
    if (id_raw != null) { try { id = Integer.parseInt(id_raw); } catch (NumberFormatException e) {} }
    String keyword = request.getParameter("keyword"); // Lấy từ khóa tìm kiếm

    String forwardPage = "/admin/product_list.jsp"; // Trang mặc định
    request.setAttribute("activePage", "products"); // Đánh dấu sidebar

    // --- Xử lý Action ---
    if (action != null) {
        switch (action) {
            case "add": // Hiển thị form thêm
                request.setAttribute("product", new Product()); // Gửi sản phẩm rỗng
                request.setAttribute("allCategories", categoryDAO.getAllCategories()); // Gửi danh sách danh mục
                request.setAttribute("productSizes", new ArrayList<ProductSize>()); // Danh sách size rỗng
                forwardPage = "/admin/product_form.jsp";
                break; // Thoát switch, để forward đến form

            case "edit": // Hiển thị form sửa
                if (id != -1) {
                    Product productToEdit = productDAO.getProductById(id);
                    if (productToEdit != null) {
                        List<ProductSize> sizes = sizeDAO.getSizesByProductId(id); // Lấy size hiện có
                        request.setAttribute("product", productToEdit);
                        request.setAttribute("allCategories", categoryDAO.getAllCategories());
                        request.setAttribute("productSizes", sizes); // Gửi size hiện có
                        forwardPage = "/admin/product_form.jsp";
                    } else { // Không tìm thấy sản phẩm
                        session.setAttribute("adminErrorMsg", "Không tìm thấy sản phẩm (ID=" + id + ")");
                        response.sendRedirect(request.getContextPath() + "/admin/products"); return; // Redirect về danh sách
                    }
                } else { // ID không hợp lệ
                    session.setAttribute("adminErrorMsg", "ID Sản phẩm không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/products"); return; // Redirect về danh sách
                }
                break; // Thoát switch, để forward đến form

            case "save": // Xử lý lưu form (thêm hoặc sửa)
                try {
                    // Lấy thông tin chung
                    String name = request.getParameter("name");
                    String description = request.getParameter("description");
                    double originalPrice = Double.parseDouble(request.getParameter("originalPrice"));
                    // Xử lý giá bán = 0 nếu để trống
                    String salePriceStr = request.getParameter("salePrice");
                    double salePrice = (salePriceStr == null || salePriceStr.trim().isEmpty()) ? 0 : Double.parseDouble(salePriceStr);
                    String imageUrl = request.getParameter("imageUrl");
                    int categoryId = Integer.parseInt(request.getParameter("categoryId"));

                    // Lấy thông tin size và số lượng
                    String[] sizes = request.getParameterValues("size[]");
                    String[] stocks = request.getParameterValues("stock[]");
                    List<ProductSize> sizeList = new ArrayList<>();
                    if (sizes != null && stocks != null) {
                        for (int i = 0; i < sizes.length; i++) {
                            // Chỉ thêm nếu size không rỗng và số lượng hợp lệ
                            if (sizes[i] != null && !sizes[i].trim().isEmpty()) {
                                try {
                                    int stock = Integer.parseInt(stocks[i]);
                                    if (stock >= 0) { // Số lượng phải >= 0
                                        ProductSize ps = new ProductSize();
                                        ps.setSize(sizes[i].trim().toUpperCase()); // Lưu size IN HOA
                                        ps.setStock(stock);
                                        sizeList.add(ps);
                                    }
                                } catch (NumberFormatException nfe) { /* Bỏ qua nếu số lượng không hợp lệ */ }
                            }
                        }
                    }
                    // Bắt buộc phải có ít nhất 1 size hợp lệ
                    if (sizeList.isEmpty()){
                         throw new Exception("Cần ít nhất một size hợp lệ với số lượng tồn kho.");
                    }


                    Product product = new Product();
                    product.setName(name);
                    product.setDescription(description);
                    product.setOriginalPrice(originalPrice);
                    product.setSalePrice(salePrice);
                    product.setImageUrl(imageUrl);
                    // Gán ID nếu là đang sửa
                    if (id != -1) product.setId(id);

                    if (id == -1) { // Thêm mới
                        int newProductId = productDAO.addProduct(product, sizeList, categoryId);
                        if(newProductId != -1) session.setAttribute("adminSuccessMsg", "Thêm sản phẩm thành công!");
                        else session.setAttribute("adminErrorMsg", "Thêm sản phẩm thất bại.");
                    } else { // Cập nhật
                        productDAO.updateProduct(product, sizeList, categoryId);
                        session.setAttribute("adminSuccessMsg", "Cập nhật sản phẩm thành công!");
                    }
                } catch (Exception e) { // Bắt lỗi nhập liệu hoặc lỗi DAO
                    e.printStackTrace();
                    session.setAttribute("adminErrorMsg", "Lỗi lưu sản phẩm: " + e.getMessage());
                     // Nếu đang sửa mà lỗi thì quay lại form sửa, nếu thêm mới mà lỗi thì quay lại danh sách
                     if (id != -1) {
                         response.sendRedirect(request.getContextPath() + "/admin/products?action=edit&pid=" + id);
                     } else {
                         response.sendRedirect(request.getContextPath() + "/admin/products?action=add");
                     }
                    return; // Dừng lại không redirect về list
                }
                response.sendRedirect(request.getContextPath() + "/admin/products"); return; // Redirect về danh sách sau khi lưu thành công

            case "delete":
                if (id != -1) {
                    productDAO.deleteProduct(id);
                    session.setAttribute("adminSuccessMsg", "Xóa sản phẩm thành công!");
                } else {
                    session.setAttribute("adminErrorMsg", "ID Sản phẩm không hợp lệ để xóa.");
                }
                response.sendRedirect(request.getContextPath() + "/admin/products"); return; // Redirect về danh sách sau khi xóa

            default: // Hiển thị danh sách (nếu action lạ) hoặc khi có tìm kiếm (action=null)
                List<Product> productList;
                if (keyword != null && !keyword.trim().isEmpty()) {
                    productList = productDAO.searchProductsAdmin(keyword.trim()); // Gọi hàm tìm kiếm mới
                    request.setAttribute("searchKeyword", keyword);
                } else {
                    productList = productDAO.getAllProducts();
                }
                request.setAttribute("productList", productList);
                break; // Thoát switch, để forward
        }
    } else {
        // Mặc định HOẶC KHI CÓ TÌM KIẾM (không có action cụ thể)
        List<Product> productList;
        if (keyword != null && !keyword.trim().isEmpty()) {
            productList = productDAO.searchProductsAdmin(keyword.trim());
            request.setAttribute("searchKeyword", keyword);
        } else {
            productList = productDAO.getAllProducts();
        }
        request.setAttribute("productList", productList);
    }

    // Forward đến trang JSP đã xác định
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
         // Có thể dùng doPost để xử lý tìm kiếm sau này
        processRequest(request, response);
    }
}