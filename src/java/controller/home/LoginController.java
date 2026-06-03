package controller.home;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.dao.AccountDAO;
import model.dao.CartDAO;
import model.dao.ViewHistoryDAO;
import model.dao.ProductDAO;
import model.Product;
import java.util.List;
import java.util.Map;

@WebServlet(urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // GET -> hiện form login
        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        // POST -> xử lý login
        String user = request.getParameter("user");
        String pass = request.getParameter("pass");

        // Lấy số lần đăng nhập sai từ session
        HttpSession session = request.getSession();
        Integer failCount = (Integer) session.getAttribute("failCount");
        if (failCount == null) failCount = 0;

        // Kiểm tra đã bị khóa chưa
        if (failCount >= 3) {
            request.setAttribute("error", "Too many failed attempts! Please try again later.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();
        Account acc = dao.getObjectById(user);

        if (acc == null || !acc.getPass().equals(pass)) {
            failCount++;
            session.setAttribute("failCount", failCount);
            request.setAttribute("error", "Wrong account or password! (" + failCount + "/3 attempts)");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        if (!acc.isIsUse()) {
            request.setAttribute("error", "This account is deactivated!");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        // Login thành công → reset failCount
        session.removeAttribute("failCount");
        session.setAttribute("acc", acc);


        // Load cart từ DB vào session
        Map<String, Integer> cart = new CartDAO().loadCart(acc.getAccount());
        session.setAttribute("cart", cart);

        // Load viewHistory từ DB, tính phân khúc
        List<String> viewedIds = new ViewHistoryDAO().loadViewHistory(acc.getAccount());
        session.setAttribute("viewedProducts", viewedIds);
        if (!viewedIds.isEmpty()) {
            ProductDAO pdao = new ProductDAO();
            long totalPrice = 0;
            int count = 0;
            for (String pid : viewedIds) {
                Product p = pdao.getObjectById(pid);
                if (p != null) { totalPrice += p.getPrice(); count++; }
            }
            long avgPrice = count > 0 ? totalPrice / count : 0;
            String segment = avgPrice < 5000000 ? "Thu nhập thấp"
                           : avgPrice <= 15000000 ? "Thu nhập trung bình"
                           : "Thu nhập cao";
            session.setAttribute("userSegment", segment);
        }

        // Redirect về trang trước đó nếu có, không thì về home
        String redirectUrl = (String) session.getAttribute("redirectUrl");
        session.removeAttribute("redirectUrl");

        if (redirectUrl != null) {
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/home");
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