package filter;

import java.io.IOException;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Account;

@WebFilter(urlPatterns = {
    "/account/*",
    "/manageCategory/*",
    "/manageProduct/*",
    "/manageCategory",
    "/manageProduct",
    "/account"
})
public class LoginFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("acc") == null) {
            // Lưu lại URL trước đó (bao gồm cả query string)
            HttpSession newSession = req.getSession();
            String query = req.getQueryString();
            String fullUrl = req.getServletPath() + (query != null ? "?" + query : "");
            newSession.setAttribute("redirectUrl", fullUrl);

            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Đã login → kiểm tra thêm quyền truy cập /account
        String path = req.getServletPath();
        Account logged = (Account) session.getAttribute("acc");
        if ((path.equals("/account") || path.startsWith("/account/")) && logged.getRoleInSystem() != 1) {
            res.sendRedirect(req.getContextPath() + "/home");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig fc) throws ServletException {}
    @Override public void destroy() {}
}