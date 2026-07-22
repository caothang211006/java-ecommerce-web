package controller.home;

import java.io.IOException;
import java.util.ArrayList;
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
import util.ConnectDB;

@WebServlet(urlPatterns = {"/home"})
public class HomeController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String typeId = request.getParameter("typeId");
        String priceRange = request.getParameter("priceRange");
        String discountFilter = request.getParameter("discountFilter");
        String sortPrice = request.getParameter("sortPrice");

        ProductDAO dao = new ProductDAO();
        CategoryDAO cdao = new CategoryDAO();

        List<Product> list = dao.listWithFilter(typeId, priceRange, discountFilter, sortPrice);
        List<Category> listC = cdao.listAll();
        Product last = dao.getLast();

        // Recently viewed products: one query for all of them rather than one
        // query per id. Trim to five before querying so the database is never
        // asked for rows that would be thrown away.
        List<Product> viewedProductList;
        List<String> vIds = (List<String>) request.getSession().getAttribute("viewedProducts");
        if (vIds == null || vIds.isEmpty()) {
            viewedProductList = new ArrayList<>();
        } else {
            List<String> wanted = vIds.size() > 5 ? vIds.subList(0, 5) : vIds;
            viewedProductList = dao.listByIds(wanted);
        }

        request.setAttribute("listP", list);
        request.setAttribute("listC", listC);
        request.setAttribute("last", last);
        request.setAttribute("viewedProductList", viewedProductList);
        request.setAttribute("dbError", ConnectDB.getLastErrorMessage());
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
