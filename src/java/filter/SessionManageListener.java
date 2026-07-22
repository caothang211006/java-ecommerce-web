package filter;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import javax.servlet.annotation.WebListener;
import javax.servlet.http.HttpSession;
import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import model.Account;

@WebListener
public class SessionManageListener implements HttpSessionListener, HttpSessionAttributeListener {

    private static final Map<String, HttpSession> activeSessions = new ConcurrentHashMap<>();

    @Override
    public void sessionCreated(HttpSessionEvent se) {}

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        activeSessions.values().remove(se.getSession());
    }

    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        if ("acc".equals(event.getName())) {
            Account acc = (Account) event.getValue();
            HttpSession newSession = event.getSession();

            HttpSession oldSession = activeSessions.get(acc.getAccount());
            if (oldSession != null && !oldSession.getId().equals(newSession.getId())) {
                try {
                    oldSession.setAttribute("kicked", true);
                    oldSession.invalidate();
                } catch (IllegalStateException e) {}
            }

            activeSessions.put(acc.getAccount(), newSession);
        }
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        if ("acc".equals(event.getName())) {
            Account acc = (Account) event.getValue();
            activeSessions.remove(acc.getAccount());
        }
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {}
}
