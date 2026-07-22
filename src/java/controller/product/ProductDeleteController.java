package controller.product;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Product;
import model.dao.OrderDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/manageProduct/delete"})
public class ProductDeleteController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");

        if (!new OrderDAO().listByProduct(id).isEmpty()) {
            request.setAttribute("error", "Cannot delete! This product still has orders.");
            request.setAttribute("listP", new ProductDAO().listAll());
            request.getRequestDispatcher("/public/Product/Product.jsp").forward(request, response);
            return;
        }

        Product p = new Product();
        p.setProductId(id);
        new ProductDAO().deleteRec(p);
        response.sendRedirect(request.getContextPath() + "/manageProduct");
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
