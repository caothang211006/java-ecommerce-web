package controller.home;

import java.io.IOException;
import java.util.ArrayList;
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
import model.dao.ViewHistoryDAO;

@WebServlet(urlPatterns = {"/detail"})
public class DetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");

        String id = request.getParameter("productId");

        ProductDAO dao = new ProductDAO();
        Product p = dao.getObjectById(id);
        List<Category> listC = new CategoryDAO().listAll();
        Product last = dao.getLast();

        // Ghi nháº­n sáº£n pháº©m Ä‘Ã£ xem vÃ o session (tá»‘i Ä‘a 20 sp)
        HttpSession session = request.getSession();
        List<String> viewedIds = (List<String>) session.getAttribute("viewedProducts");
        if (viewedIds == null) viewedIds = new ArrayList<>();
        viewedIds.remove(id); // trÃ¡nh trÃ¹ng
        viewedIds.add(0, id); // thÃªm vÃ o Ä‘áº§u
        if (viewedIds.size() > 20) viewedIds = viewedIds.subList(0, 20);
        session.setAttribute("viewedProducts", viewedIds);

        // LÆ°u vÃ o DB ngay náº¿u Ä‘Ã£ login
        Account logged = (Account) session.getAttribute("acc");
        if (logged != null) {
            new ViewHistoryDAO().saveView(logged.getAccount(), id);
        }

        // TÃ­nh phÃ¢n khÃºc thu nháº­p dá»±a trÃªn giÃ¡ trung bÃ¬nh cÃ¡c sp Ä‘Ã£ xem
        if (!viewedIds.isEmpty()) {
            long totalPrice = 0;
            int count = 0;
            for (String pid : viewedIds) {
                Product viewed = dao.getObjectById(pid);
                if (viewed != null) {
                    totalPrice += viewed.getPrice();
                    count++;
                }
            }
            long avgPrice = count > 0 ? totalPrice / count : 0;
            String segment;
            if (avgPrice < 5000000) {
                segment = "Thu nháº­p tháº¥p";
            } else if (avgPrice <= 15000000) {
                segment = "Thu nháº­p trung bÃ¬nh";
            } else {
                segment = "Thu nháº­p cao";
            }
            session.setAttribute("userSegment", segment);
        }

        // Láº¥y danh sÃ¡ch sp Ä‘Ã£ xem Ä‘á»ƒ hiá»ƒn thá»‹ (tá»‘i Ä‘a 8)
        List<Product> viewedProductList = new ArrayList<>();
        List<String> vIds = (List<String>) session.getAttribute("viewedProducts");
        if (vIds != null) {
            int count2 = 0;
            for (String pid : vIds) {
                if (count2 >= 8) break;
                Product vp = dao.getObjectById(pid);
                if (vp != null) { viewedProductList.add(vp); count2++; }
            }
        }

        request.setAttribute("detail", p);
        request.setAttribute("viewedProductList", viewedProductList);
        request.setAttribute("listC", listC);
        request.setAttribute("last", last);

        request.getRequestDispatcher("/public/Detail.jsp").forward(request, response);
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
