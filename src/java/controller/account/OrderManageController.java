package controller.account;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Order;
import model.OrderDetail;
import model.dao.OrderDAO;

@WebServlet(urlPatterns = {"/account/orders"})
public class OrderManageController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        OrderDAO dao = new OrderDAO();
        String action = request.getParameter("action");

        // Cập nhật status
        if ("updateStatus".equals(action)) {
            int orderId = Integer.parseInt(request.getParameter("orderId"));
            int status  = Integer.parseInt(request.getParameter("status"));
            dao.updateStatus(orderId, status);
            response.sendRedirect(request.getContextPath() + "/account/orders");
            return;
        }

        // Xem chi tiết
        String orderIdParam = request.getParameter("orderId");
        if (orderIdParam != null) {
            int orderId = Integer.parseInt(orderIdParam);
            List<OrderDetail> details = dao.getOrderDetails(orderId);
            request.setAttribute("details", details);
            request.setAttribute("orderId", orderId);
        }

        List<Order> orders = dao.listAll();
        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/private/Account/OrderManage.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}
