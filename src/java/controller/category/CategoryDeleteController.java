package controller.category;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;
import model.dao.CategoryDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/manageCategory/delete"})
public class CategoryDeleteController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        int id = Integer.parseInt(request.getParameter("id"));

        ProductDAO productDAO = new ProductDAO();
        if (!productDAO.listProductByCategory(String.valueOf(id)).isEmpty()) {
            List<Category> listC = new CategoryDAO().listAll();
            request.setAttribute("listC", listC);
            request.setAttribute("error", "Cannot delete! This category still has products.");
            request.getRequestDispatcher("/public/Category/Category.jsp").forward(request, response);
            return;
        }

        Category c = new Category();
        c.setTypeId(id);
        new CategoryDAO().deleteRec(c);
        response.sendRedirect(request.getContextPath() + "/manageCategory");
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
