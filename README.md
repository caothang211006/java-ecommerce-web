# E-commerce Web App

Java Servlet + JSP e-commerce app running on Apache Tomcat 9 with MySQL 8.

## Tech Stack

- Java Servlet + JSP (Servlet 3.1, `javax.servlet`)
- Apache Tomcat 9
- MySQL 8.4
- JDBC via MySQL Connector/J 8.4

## Quick Start (Docker)

```bash
docker compose up --build
```

Then open <http://localhost:8080>. Compose starts MySQL, loads `db/init.sql`,
waits for the health check, and only then starts the app.

Seed logins:

| Account | Password | Role |
| --- | --- | --- |
| `admin` | `abc` | Administrator (`roleInSystem = 1`) |
| `manager` | `123` | Staff (`roleInSystem = 2`) |

Only `roleInSystem = 1` reaches `/account`, `/manageProduct`, and
`/manageCategory`. Everyone else gets `403`.

## Environment Variables

| Variable | Default | Notes |
| --- | --- | --- |
| `DB_HOST` | `localhost` | MySQL host |
| `DB_PORT` | `3306` | MySQL port |
| `DB_NAME` | `ProductIntro_WS2_ThangNDC_SE203709` | Database name |
| `DB_USER` | `root` | MySQL user |
| `DB_PASSWORD` | empty | MySQL password |
| `PORT` | `8080` | Tomcat HTTP port |
| `DATABASE_URL` | unset | Full connection string; overrides the above when set |

`DATABASE_URL` accepts both `mysql://user:pass@host:3306/db` and
`jdbc:mysql://host:3306/db`, which covers what Railway, Render, and Heroku hand
out.

## Passwords

Passwords are stored as salted PBKDF2-HMAC-SHA256 hashes (120,000 iterations),
using only JDK built-ins so no extra jar is required.

Accounts created before hashing existed still hold plain text. Those logins keep
working, and the row is rewritten as a hash the first time that account signs in
successfully. No manual migration step is needed.

## Run Locally in NetBeans

1. Install JDK 8+ and Apache Tomcat 9.
2. Start MySQL on `localhost:3306` and create the database.
3. Import the schema:
   ```bash
   mysql -u root -p ProductIntro_WS2_ThangNDC_SE203709 < db/init.sql
   ```
4. Make sure `web/WEB-INF/lib/mysql-connector-j-9.7.0.jar` is present. It is
   committed to the repo; if it is missing from your working copy, restore it:
   ```bash
   git checkout -- web/WEB-INF/lib/
   ```
   Without it every page reports "MySQL JDBC driver not found."
5. Open the project in NetBeans and run.

## Deploying

### Railway

1. Create a project from this repo. `railway.json` already selects the
   Dockerfile builder.
2. Add the MySQL plugin.
3. In the app service, set `DB_HOST`, `DB_PORT`, `DB_NAME`, `DB_USER`, and
   `DB_PASSWORD` to reference the MySQL service variables (or set
   `DATABASE_URL` to `${{MySQL.MYSQL_URL}}`).
4. Import `db/init.sql` into the MySQL service once.

Leave `PORT` unset. Railway injects it and `docker/start-tomcat.sh` rewrites
`server.xml` to match at startup.

### Render + external MySQL

Render's free tier has no managed MySQL, so pair a Docker web service with a
free MySQL host such as Aiven. Set the same variables as above. Note that free
Render services sleep after 15 minutes idle and take roughly 50 seconds to wake.

## Notes

- `ProductIntro_WS2_ThangNDC_SE203709_sqlserver.sql` and the root-level
  `ProductIntro_WS2_ThangNDC_SE203709.sql` are pre-migration SQL Server dumps,
  kept for reference only. `db/init.sql` is the schema the app actually uses.
- Each request opens its own JDBC connection; there is no pool yet. Fine for
  coursework traffic, worth revisiting under real load.
