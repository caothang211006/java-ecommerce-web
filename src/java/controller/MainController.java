package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet(urlPatterns = {"/MainController"})
public class MainController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            request.getRequestDispatcher("/Home.jsp").forward(request, response);
        } else if (action.equals("account")) {
            response.sendRedirect(request.getContextPath() + "/account");
        } else if (action.equals("category")) {
            response.sendRedirect(request.getContextPath() + "/manageCategory");
        } else if (action.equals("product")) {
            response.sendRedirect(request.getContextPath() + "/manageProduct");
        } else {
            request.getRequestDispatcher("/Home.jsp").forward(request, response);
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
