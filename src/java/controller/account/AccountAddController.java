package controller.account;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Account;
import model.dao.AccountDAO;

@WebServlet(urlPatterns = {"/account/add"})
public class AccountAddController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // GET -> hiá»‡n form thÃªm
        if (request.getMethod().equalsIgnoreCase("GET")) {
            request.getRequestDispatcher("/private/Account/addAccount.jsp").forward(request, response);
            return;
        }

        // POST -> xá»­ lÃ½ thÃªm
        Account acc = new Account();
        acc.setAccount(request.getParameter("account"));
        acc.setPass(request.getParameter("pass"));
        acc.setLastName(request.getParameter("lastName"));
        acc.setFirstName(request.getParameter("firstName"));
        String birthdayStr = request.getParameter("birthday");
        if (birthdayStr != null && !birthdayStr.trim().isEmpty()) {
            acc.setBirthday(Date.valueOf(birthdayStr));
        } else {
            acc.setBirthday(null);
        }
        acc.setGender(Boolean.parseBoolean(request.getParameter("gender")));
        acc.setPhone(request.getParameter("phone"));
        acc.setIsUse(true);
        acc.setRoleInSystem(Integer.parseInt(request.getParameter("role")));

        AccountDAO dao = new AccountDAO();
        if (dao.getObjectById(acc.getAccount()) != null) {
            request.setAttribute("error", "Username already exists!");
            request.getRequestDispatcher("/private/Account/addAccount.jsp").forward(request, response);
            return;
        }
        dao.insertRec(acc);
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
