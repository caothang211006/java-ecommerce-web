package controller.category;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Category;
import model.dao.CategoryDAO;

@WebServlet(urlPatterns = {"/manageCategory/add"})
public class CategoryAddController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");


        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/private/Category/addCategory.jsp").forward(request, response);
            return;
        }

        Category c = new Category();
        c.setCategoryName(request.getParameter("categoryName"));
        c.setMemo(request.getParameter("memo"));
        new CategoryDAO().insertRec(c);
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
