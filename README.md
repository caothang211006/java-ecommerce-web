# E-commerce Web App

A full-stack e-commerce web application built with Java Servlet and SQL Server, supporting product browsing, shopping cart, order management, and an admin dashboard.

## Tech Stack
- Java Servlet + JSP (MVC pattern)
- SQL Server (JDBC)
- HTML/CSS, Bootstrap
- Apache Tomcat

## Features
- Product listing, search, and detail pages
- Shopping cart and checkout
- Order history tracking
- Admin: manage products, categories, accounts, orders
- Session-based authentication with login/logout

## How to Run
1. Install JDK 8+, Apache Tomcat, SQL Server
2. Clone this repository
3. Create a database named `ProductIntro_WS2_ThangNDC_SE203709` in SQL Server
4. Update credentials in `src/java/util/ConnectDB.java` if needed (default: SA / 12345)
5. Open project in NetBeans, deploy to Tomcat
6. Access at `http://localhost:8080/WS2_ThangNDC_SE203709`
