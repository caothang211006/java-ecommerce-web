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

@WebServlet(urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String typeId       = request.getParameter("typeId");
        String priceRange   = request.getParameter("priceRange");
        String discountFilter = request.getParameter("discountFilter");
        String sortPrice    = request.getParameter("sortPrice");

        ProductDAO dao = new ProductDAO();
        CategoryDAO cdao = new CategoryDAO();

        List<Product> list = dao.listWithFilter(typeId, priceRange, discountFilter, sortPrice);
        List<Category> listC = cdao.listAll();
        Product last = dao.getLast();

        // Lấy danh sách sp đã xem cho Left.jsp
        List<Product> viewedProductList = new java.util.ArrayList<>();
        java.util.List<String> vIds = (java.util.List<String>) request.getSession().getAttribute("viewedProducts");
        if (vIds != null) {
            int count = 0;
            for (String pid : vIds) {
                if (count >= 5) break;
                Product vp = dao.getObjectById(pid);
                if (vp != null) { viewedProductList.add(vp); count++; }
            }
        }

        request.setAttribute("listP", list);
        request.setAttribute("listC", listC);
        request.setAttribute("last", last);
        request.setAttribute("viewedProductList", viewedProductList);
        request.getRequestDispatcher("/Home.jsp").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException { processRequest(request, response); }
}