package controller.account;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Account;
import model.dao.AccountDAO;
import model.dao.ProductDAO;

@WebServlet(urlPatterns = {"/account/delete"})
public class AccountDeleteController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String id = request.getParameter("id");

        if (!new ProductDAO().listProductByAccount(id).isEmpty()) {
            request.setAttribute("error", "Cannot delete! This account still has products.");
            request.setAttribute("listA", new AccountDAO().listAll());
            request.getRequestDispatcher("/private/Account/Account.jsp").forward(request, response);
            return;
        }

        Account acc = new Account();
        acc.setAccount(id);
        new AccountDAO().deleteRec(acc);
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
