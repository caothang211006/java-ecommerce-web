package controller.product;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.Category;
import model.Product;
import model.dao.CategoryDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/manageProduct/add"})
public class ProductAddController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // GET -> hiện form thêm
        if (request.getMethod().equalsIgnoreCase("GET")) {
            List<Category> listC = new CategoryDAO().listAll();
            request.setAttribute("listC", listC);
            request.getRequestDispatcher("/private/Product/addProduct.jsp").forward(request, response);
            return;
        }

        // POST -> xử lý thêm
        // Validation
        String productId = request.getParameter("productId");
        String productName = request.getParameter("productName");
        String typeIdStr = request.getParameter("typeId");

        if (productId == null || productId.trim().isEmpty()
                || productName == null || productName.trim().isEmpty()
                || typeIdStr == null || typeIdStr.trim().isEmpty()) {
            List<Category> listC = new CategoryDAO().listAll();
            request.setAttribute("listC", listC);
            request.setAttribute("error", "Please fill in all required fields!");
            request.getRequestDispatcher("/Product/addProduct.jsp").forward(request, response);
            return;
        }

        try {
            Product p = new Product();
            p.setProductId(productId.trim());
            p.setProductName(productName.trim());
            p.setProductImage(request.getParameter("productImage"));
            p.setBrief(request.getParameter("brief"));
            p.setUnit(request.getParameter("unit"));
            p.setPrice(Integer.parseInt(request.getParameter("price")));
            p.setDiscount(Integer.parseInt(request.getParameter("discount")));
            p.setPostedDate(new Timestamp(System.currentTimeMillis()));

            // FIX: set typeId
            Category c = new Category();
            c.setTypeId(Integer.parseInt(typeIdStr));
            p.setType(c);

            // FIX: set account từ session
            HttpSession session = request.getSession(false);
            Account acc = (Account) session.getAttribute("acc");
            p.setAccount(acc);

            new ProductDAO().insertRec(p);
            response.sendRedirect(request.getContextPath() + "/manageProduct");

        } catch (NumberFormatException e) {
            List<Category> listC = new CategoryDAO().listAll();
            request.setAttribute("listC", listC);
            request.setAttribute("error", "Price and Discount must be valid numbers!");
            request.getRequestDispatcher("/Product/addProduct.jsp").forward(request, response);
        }
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