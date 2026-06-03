package controller.cart;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Product;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/cart"})
public class CartController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        // Kiểm tra login khi add/buyNow
        if ("add".equals(action) || "buyNow".equals(action)) {
            if (session.getAttribute("acc") == null) {
                session.setAttribute("redirectUrl", "/cart");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
        }

        // Lấy giỏ hàng từ session, nếu chưa có thì tạo mới
        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null) cart = new HashMap<>();

        if (action == null || action.equals("show")) {
            // Xem giỏ hàng
            showCart(request, response, session, cart);
            return;
        }

        String productId = request.getParameter("productId");

        switch (action) {
            case "add":
                // Thêm sản phẩm vào giỏ (tăng thêm 1)
                cart.put(productId, cart.getOrDefault(productId, 0) + 1);
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;

            case "buyNow":
                // Thêm vào giỏ rồi chuyển thẳng sang checkout
                cart.put(productId, cart.getOrDefault(productId, 0) + 1);
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/checkout");
                break;

            case "remove":
                // Xóa sản phẩm khỏi giỏ
                cart.remove(productId);
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;

            case "increase":
                // Tăng số lượng thêm 1
                cart.put(productId, cart.getOrDefault(productId, 0) + 1);
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;

            case "decrease":
                // Giảm số lượng, nếu về 0 thì xóa luôn
                int qty = cart.getOrDefault(productId, 1) - 1;
                if (qty <= 0) {
                    cart.remove(productId);
                } else {
                    cart.put(productId, qty);
                }
                session.setAttribute("cart", cart);
                response.sendRedirect(request.getContextPath() + "/cart");
                break;

            default:
                showCart(request, response, session, cart);
        }
    }

    private void showCart(HttpServletRequest request, HttpServletResponse response,
            HttpSession session, Map<String, Integer> cart) throws ServletException, IOException {

        ProductDAO dao = new ProductDAO();

        // Lấy thông tin chi tiết từng sản phẩm trong giỏ
        List<Product> cartProducts = new ArrayList<>();
        for (String pid : cart.keySet()) {
            Product p = dao.getObjectById(pid);
            if (p != null) cartProducts.add(p);
        }

        // Tính tổng tiền
        int total = 0;
        for (Product p : cartProducts) {
            int qty = cart.get(p.getProductId());
            int finalPrice = p.getDiscount() > 0
                    ? p.getPrice() - (p.getPrice() * p.getDiscount() / 100)
                    : p.getPrice();
            total += finalPrice * qty;
        }

        request.setAttribute("cartProducts", cartProducts);
        request.setAttribute("cart", cart);
        request.setAttribute("total", total);
        request.getRequestDispatcher("/private/Cart/Cart.jsp").forward(request, response);
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