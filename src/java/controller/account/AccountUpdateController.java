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

@WebServlet(urlPatterns = {"/account/update"})
public class AccountUpdateController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        AccountDAO dao = new AccountDAO();

        // GET -> hiá»‡n form chá»‰nh sá»­a
        if (request.getMethod().equalsIgnoreCase("GET")) {
            String id = request.getParameter("id");
            Account acc = dao.getObjectById(id);
            request.setAttribute("editAcc", acc);
            request.getRequestDispatcher("/private/Account/updateAccount.jsp").forward(request, response);
            return;
        }

        // POST -> xá»­ lÃ½ cáº­p nháº­t
        Account acc = new Account();
        acc.setAccount(request.getParameter("account"));

        // Kiá»ƒm tra khÃ´ng cho háº¡ role admin cuá»‘i cÃ¹ng xuá»‘ng Staff
        int newRole = Integer.parseInt(request.getParameter("role"));
        Account current = dao.getObjectById(acc.getAccount());
        if (current != null && current.getRoleInSystem() == 1
                && newRole != 1 && dao.countActiveAdmins() <= 1) {
            request.setAttribute("editAcc", current);
            request.setAttribute("error", "Cannot change role! There must be at least one admin.");
            request.getRequestDispatcher("/private/Account/updateAccount.jsp").forward(request, response);
            return;
        }
        // Giá»¯ pass cÅ© náº¿u user Ä‘á»ƒ trá»‘ng
        String newPass = request.getParameter("pass");
        if (newPass == null || newPass.trim().isEmpty()) {
            acc.setPass(current.getPass());
        } else {
            acc.setPass(newPass);
        }
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
        String isUseParam = request.getParameter("isUse");
        acc.setIsUse(isUseParam != null && isUseParam.equals("true"));
        acc.setRoleInSystem(newRole);

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
