package controller.home;

import java.io.IOException;
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
import model.dao.CartDAO;
import model.dao.ProductDAO;
import model.dao.ViewHistoryDAO;
import util.PasswordHasher;

@WebServlet(urlPatterns = {"/login"})
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        String user = request.getParameter("user");
        String pass = request.getParameter("pass");

        HttpSession session = request.getSession();
        Integer failCount = (Integer) session.getAttribute("failCount");
        if (failCount == null) {
            failCount = 0;
        }

        if (failCount >= 3) {
            request.setAttribute("error", "Too many failed attempts! Please try again later.");
            request.getRequestDispatcher("/Login.jsp").forward(request, response);
            return;
        }

        AccountDAO dao = new AccountDAO();
        Account acc = dao.getObjectById(user);

        if (acc == null || !PasswordHasher.matches(pass, acc.getPass())) {
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

        // The password was right. If the row still holds it in plain text
        // (a pre-hashing account), quietly replace it with a real hash now,
        // while we still have the raw value in hand.
        if (PasswordHasher.needsUpgrade(acc.getPass())) {
            dao.upgradeStoredPassword(acc.getAccount(), pass);
        }

        session.removeAttribute("failCount");
        session.setAttribute("acc", acc);

        Map<String, Integer> cart = new CartDAO().loadCart(acc.getAccount());
        session.setAttribute("cart", cart);

        List<String> viewedIds = new ViewHistoryDAO().loadViewHistory(acc.getAccount());
        session.setAttribute("viewedProducts", viewedIds);
        if (!viewedIds.isEmpty()) {
            // One query for the whole view history instead of one per id.
            // On a signed-in user with a long history this was the slowest part
            // of logging in.
            List<Product> viewed = new ProductDAO().listByIds(viewedIds);
            long totalPrice = 0;
            for (Product p : viewed) {
                totalPrice += p.getPrice();
            }
            int count = viewed.size();
            long avgPrice = count > 0 ? totalPrice / count : 0;
            String segment = avgPrice < 5000000
                    ? "Low income"
                    : avgPrice <= 15000000
                    ? "Middle income"
                    : "High income";
            session.setAttribute("userSegment", segment);
        }

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
