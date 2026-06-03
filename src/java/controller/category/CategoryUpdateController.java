package controller.category;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Category;
import model.dao.CategoryDAO;

@WebServlet(urlPatterns = {"/manageCategory/update"})
public class CategoryUpdateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        CategoryDAO dao = new CategoryDAO();

        // GET -> hiện form chỉnh sửa
        if (request.getMethod().equalsIgnoreCase("GET")) {
            String id = request.getParameter("id");
            Category c = dao.getObjectById(id);
            request.setAttribute("cat", c);
            request.getRequestDispatcher("/private/Category/updateCategory.jsp").forward(request, response);
            return;
        }

        // POST -> xử lý cập nhật
        Category c = new Category();
        c.setTypeId(Integer.parseInt(request.getParameter("typeId")));
        c.setCategoryName(request.getParameter("categoryName"));
        c.setMemo(request.getParameter("memo"));
        dao.updateRec(c);
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
