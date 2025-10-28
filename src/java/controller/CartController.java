package controller;

import dao.CartDAO;
import entity.Cart;
import entity.User;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet(name = "CartController", urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        Cart cart = (Cart) session.getAttribute("cart");
        
        String action = request.getParameter("action");
        if (action != null && action.equals("remove")) {
            try {
                int productId = Integer.parseInt(request.getParameter("pid"));
                String size = request.getParameter("size"); // LẤY SIZE
                if (user == null) {
                    if (cart != null) {
                        cart.removeItem(productId, size); // DÙNG PHƯƠNG THỨC MỚI
                        session.setAttribute("cart", cart);
                    }
                } else {
                    CartDAO cartDAO = new CartDAO();
                    cartDAO.removeItem(user.getId(), productId, size); // DÙNG PHƯƠNG THỨC MỚI
                    cart = cartDAO.getCartByUserId(user.getId());
                    session.setAttribute("cart", cart);
                }
            } catch (NumberFormatException e) {}
            response.sendRedirect("cart");
            return;
        }
        
        request.getRequestDispatcher("cart.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("acc");
        Cart cart = (Cart) session.getAttribute("cart");
        
        String[] productIds = request.getParameterValues("productId");
        String[] quantities = request.getParameterValues("quantity");
        String[] sizes = request.getParameterValues("size"); // LẤY MẢNG SIZE

        if (productIds != null && quantities != null && sizes != null) {
            for (int i = 0; i < productIds.length; i++) {
                try {
                    int id = Integer.parseInt(productIds[i]);
                    int quantity = Integer.parseInt(quantities[i]);
                    String size = sizes[i]; // LẤY SIZE TƯƠNG ỨNG

                    if (user == null) {
                        if (cart != null) cart.updateItem(id, size, quantity); // DÙNG PHƯƠNG THỨC MỚI
                    } else {
                        CartDAO cartDAO = new CartDAO();
                        cartDAO.updateItemQuantity(user.getId(), id, quantity, size); // DÙNG PHƯƠNG THỨC MỚI
                    }
                } catch (NumberFormatException e) {}
            }
        }
        
        if (user == null) {
            session.setAttribute("cart", cart);
        } else {
            // Tải lại giỏ hàng từ DB
            CartDAO cartDAO = new CartDAO();
            cart = cartDAO.getCartByUserId(user.getId());
            session.setAttribute("cart", cart);
        }
        
        response.sendRedirect("cart");
    }
}