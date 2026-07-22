package util;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

/**
 * Closes the JDBC connection pool when the web application stops.
 *
 * Without this, the pool's idle-eviction thread keeps running after the context
 * is undeployed. Tomcat notices and logs a "web application appears to have
 * started a thread but has failed to stop it" warning, and on repeated
 * redeploys the orphaned pools leak both memory and server-side connections --
 * which matters here because the free database plan allows only a small number.
 */
@WebListener
public class ConnectionPoolListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent event) {
        // The pool is created lazily on the first query, so there is nothing to
        // do here. Building it eagerly would make startup fail whenever the
        // database happens to be asleep, which is routine on a free plan.
    }

    @Override
    public void contextDestroyed(ServletContextEvent event) {
        ConnectDB.shutdown();
    }
}
