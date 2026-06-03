package controller.cart;

import java.io.IOException;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.dao.OrderDAO;

@WebServlet(urlPatterns = {"/checkout"})
public class CheckoutController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Map<String, Integer> cart = (Map<String, Integer>) session.getAttribute("cart");
        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/cart");
            return;
        }

        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/private/Cart/Checkout.jsp").forward(request, response);
            return;
        }

        // POST: xử lý đặt hàng
        String address = request.getParameter("address");
        String phone   = request.getParameter("phone");

        if (address == null || address.trim().isEmpty() || phone == null || phone.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            request.getRequestDispatcher("/private/Cart/Checkout.jsp").forward(request, response);
            return;
        }

        int orderId = new OrderDAO().createOrder(acc.getAccount(), address.trim(), phone.trim(), cart);
        if (orderId > 0) {
            // Xóa cart sau khi đặt hàng
            session.removeAttribute("cart");
            new model.dao.CartDAO().saveCart(acc.getAccount(), null);
            response.sendRedirect(request.getContextPath() + "/orderHistory?success=1");
        } else {
            request.setAttribute("error", "Đặt hàng thất bại, vui lòng thử lại!");
            request.getRequestDispatcher("/private/Checkout.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}
