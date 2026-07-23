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
 * Two checks run in order: first authentication (is anyone signed in?), then
 * authorisation (does that person's role allow this particular area?).
 *
 * There are two tiers of staff:
 *
 *   role 1  admin  - full access, including the account management screens
 *   role 2  staff  - may manage the catalogue (products and categories) but
 *                    not user accounts
 *
 * So /account is admin-only, while /manageProduct and /manageCategory are open
 * to both. Anyone signed in with a lower role, or not signed in at all, is
 * turned away. The menu already hides links a user may not use; this filter is
 * the enforcement behind that, since a hidden link can still be reached by
 * typing the URL.
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

    private static final int ROLE_ADMIN = 1;
    private static final int ROLE_STAFF = 2;

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

        if (!isAuthorised(req.getServletPath(), logged.getRoleInSystem())) {
            // Signed in, but this role may not use this area. Answer 403 rather
            // than redirecting, so the refusal is explicit instead of looking
            // like a routing quirk.
            res.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "You do not have permission to access this area.");
            return;
        }

        chain.doFilter(request, response);
    }

    /**
     * Decides whether a role may use a path.
     *
     * Account management is admin-only. Catalogue management is open to admin
     * and staff. Anything else this filter covers defaults to admin-only, so a
     * newly added protected path is locked down until it is explicitly opened.
     */
    private boolean isAuthorised(String path, int role) {
        boolean accountArea = path.equals("/account") || path.startsWith("/account/");
        if (accountArea) {
            return role == ROLE_ADMIN;
        }

        boolean catalogueArea =
                path.equals("/manageProduct") || path.startsWith("/manageProduct/")
                || path.equals("/manageCategory") || path.startsWith("/manageCategory/");
        if (catalogueArea) {
            return role == ROLE_ADMIN || role == ROLE_STAFF;
        }

        return role == ROLE_ADMIN;
    }

    @Override
    public void init(FilterConfig fc) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
