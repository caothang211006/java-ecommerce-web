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

/**
 * Guards the private areas of the site.
 *
 * Two separate checks, in order:
 *   1. Authentication - is anybody signed in at all?
 *   2. Authorisation  - is that person an administrator?
 *
 * Every path this filter covers is an administrative screen, so all of them
 * require the admin role. Previously only /account did, which meant any
 * signed-in customer could reach /manageProduct/delete or
 * /manageCategory/delete simply by typing the URL.
 */
@WebFilter(urlPatterns = {
    "/account",
    "/account/*",
    "/manageCategory",
    "/manageCategory/*",
    "/manageProduct",
    "/manageProduct/*"
})
public class LoginFilter implements Filter {

    /** Value of accounts.roleInSystem that marks an administrator. */
    private static final int ROLE_ADMIN = 1;

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);
        Account logged = session == null ? null : (Account) session.getAttribute("acc");

        if (logged == null) {
            HttpSession newSession = req.getSession();
            String query = req.getQueryString();
            String fullUrl = req.getServletPath() + (query != null ? "?" + query : "");
            newSession.setAttribute("redirectUrl", fullUrl);

            res.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        if (logged.getRoleInSystem() != ROLE_ADMIN) {
            // Signed in, but not an admin. Answer 403 rather than redirecting,
            // so the refusal is explicit instead of looking like a routing quirk.
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this area.");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig fc) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
