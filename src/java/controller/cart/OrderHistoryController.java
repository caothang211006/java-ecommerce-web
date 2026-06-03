package controller.cart;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.Order;
import model.OrderDetail;
import model.dao.OrderDAO;

@WebServlet(urlPatterns = {"/orderHistory"})
public class OrderHistoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account acc = (Account) session.getAttribute("acc");

        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        OrderDAO dao = new OrderDAO();

        // Xem chi tiết đơn hàng
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null) {
            int orderId = Integer.parseInt(orderIdParam);
            List<OrderDetail> details = dao.getOrderDetails(orderId);
            request.setAttribute("details", details);
            request.setAttribute("orderId", orderId);
        }

        List<Order> orders = dao.listByAccount(acc.getAccount());
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/private/Order/OrderHistory.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}