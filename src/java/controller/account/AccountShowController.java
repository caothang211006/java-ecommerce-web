package controller.account;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.Product;
import model.dao.AccountDAO;
import model.dao.ProductDAO;
import model.dao.ViewHistoryDAO;

@WebServlet(urlPatterns = {"/account"})
public class AccountShowController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        AccountDAO dao = new AccountDAO();
        String role = request.getParameter("role");
        List<Account> list;
        if (role != null && !role.trim().isEmpty()) {
            list = dao.listByRole(Integer.parseInt(role));
        } else {
            list = dao.listAll();
        }
        request.setAttribute("listA", list);

        // Tính phân khúc cho từng account
        Map<String, String> segmentMap = new HashMap<>();
        ViewHistoryDAO vhDao = new ViewHistoryDAO();
        ProductDAO pdao = new ProductDAO();
        for (Account a : list) {
            List<String> viewed = vhDao.loadViewHistory(a.getAccount());
            if (viewed.isEmpty()) {
                segmentMap.put(a.getAccount(), "Unclassified");
            } else {
                long total = 0; int cnt = 0;
                for (String pid : viewed) {
                    Product p = pdao.getObjectById(pid);
                    if (p != null) { total += p.getPrice(); cnt++; }
                }
                long avg = cnt > 0 ? total / cnt : 0;
                String seg = avg < 5000000 ? "Low income"
                           : avg <= 15000000 ? "Middle income"
                           : "High income";
                segmentMap.put(a.getAccount(), seg);
            }
        }
        request.setAttribute("segmentMap", segmentMap);
        request.getRequestDispatcher("/private/Account/Account.jsp").forward(request, response);
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