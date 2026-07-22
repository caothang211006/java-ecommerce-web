package controller.home;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;
import model.Product;
import model.dao.CategoryDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/category"})
public class CategoryController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String typeId = request.getParameter("typeId");

        ProductDAO dao = new ProductDAO();
        List<Product> list = dao.listProductByCategory(typeId);
        List<Category> listC = new CategoryDAO().listAll();
        Product last = dao.getLastByCategory(typeId);

        request.setAttribute("listP", list);
        request.setAttribute("listC", listC);
        request.setAttribute("last", last);
        request.setAttribute("tag", typeId);

        request.getRequestDispatcher("/Home.jsp").forward(request, response);
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
