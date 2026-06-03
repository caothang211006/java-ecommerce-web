package controller.account;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;
import model.dao.AccountDAO;

@WebServlet(urlPatterns = {"/account/toggleUse"})
public class AccountToggleUseController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String targetId = request.getParameter("id");
        boolean newStatus = Boolean.parseBoolean(request.getParameter("isUse"));

        HttpSession session = request.getSession(false);
        Account logged = (Account) session.getAttribute("acc");

        AccountDAO dao = new AccountDAO();
        Account acc = dao.getObjectById(targetId);

        // Null check
        if (acc == null) {
            response.sendRedirect(request.getContextPath() + "/account");
            return;
        }

        // Không cho tự deactivate chính mình
        if (logged.getAccount().equals(targetId) && !newStatus) {
            request.setAttribute("error", "You cannot deactivate your own account!");
            request.setAttribute("listA", dao.listAll());
            request.getRequestDispatcher("/private/Account/Account.jsp").forward(request, response);
            return;
        }

        // Không cho deactivate nếu chỉ còn 1 admin đang active
        if (acc.getRoleInSystem() == 1 && !newStatus && dao.countActiveAdmins() <= 1) {
            request.setAttribute("error", "Cannot deactivate! There must be at least one active admin.");
            request.setAttribute("listA", dao.listAll());
            request.getRequestDispatcher("/private/Account/Account.jsp").forward(request, response);
            return;
        }

        acc.setIsUse(newStatus);
        dao.updateRec(acc);
        response.sendRedirect(request.getContextPath() + "/account");
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