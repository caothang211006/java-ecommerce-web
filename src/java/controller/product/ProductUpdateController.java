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
import model.Category;
import model.Product;
import model.dao.CategoryDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/manageProduct/update"})
public class ProductUpdateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        ProductDAO dao = new ProductDAO();

        // GET -> hiện form chỉnh sửa
        if (request.getMethod().equalsIgnoreCase("GET")) {
            String id = request.getParameter("id");
            Product p = dao.getObjectById(id);
            List<Category> listC = new CategoryDAO().listAll();
            request.setAttribute("p", p);
            request.setAttribute("listC", listC);
            request.getRequestDispatcher("/private/Product/updateProduct.jsp").forward(request, response);
            return;
        }

        // POST -> xử lý cập nhật
        Product p = new Product();
        p.setProductId(request.getParameter("productId"));
        p.setProductName(request.getParameter("productName"));
        p.setProductImage(request.getParameter("productImage"));
        p.setBrief(request.getParameter("brief"));
        p.setUnit(request.getParameter("unit"));
        p.setPrice(Integer.parseInt(request.getParameter("price")));
        p.setDiscount(Integer.parseInt(request.getParameter("discount")));

        // FIX: set typeId
        Category c = new Category();
        c.setTypeId(Integer.parseInt(request.getParameter("typeId")));
        p.setType(c);

        dao.updateRec(p);
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