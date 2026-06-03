# E-commerce Web App

Java Servlet + JSP e-commerce app running on Apache Tomcat with MySQL.

## Tech Stack
- Java Servlet + JSP
- Apache Tomcat 9
- MySQL 8
- JDBC with MySQL Connector/J
- Docker / Docker Compose

## Environment Variables

The app reads database settings from environment variables:

| Variable | Default | Notes |
| --- | --- | --- |
| `DB_HOST` | `localhost` | Local or Docker host |
| `DB_PORT` | `3306` | MySQL port |
| `DB_NAME` | `ProductIntro_WS2_ThangNDC_SE203709` | Database name |
| `DB_USER` | `root` | Database user |
| `DB_PASSWORD` | empty | Database password |
| `PORT` | `8080` | Tomcat HTTP port in Docker/Railway |

Railway MySQL variables are also supported automatically: `MYSQLHOST`, `MYSQLPORT`, `MYSQLDATABASE`, `MYSQLUSER`, and `MYSQLPASSWORD`.

## Run With Docker Compose

```bash
docker compose up --build
```

Open:

```text
http://localhost:8080
```

The compose setup starts MySQL 8, initializes the schema and sample data from `db/init.sql`, then starts Tomcat.

## Run In NetBeans / Local Tomcat

1. Install JDK 8+ and Apache Tomcat 9.
2. Create a MySQL database with `ProductIntro_WS2_ThangNDC_SE203709.sql`.
3. Set the DB environment variables for your Tomcat process, or use the defaults from `.env.example`.
4. Open the project in NetBeans and deploy to Tomcat.

## Deploy To Railway

1. Create a Railway project from this GitHub repository.
2. Add a Railway MySQL service.
3. Deploy the web app service using the included `Dockerfile`.
4. Add reference variables on the web app service:

```text
MYSQLHOST=${{MySQL.MYSQLHOST}}
MYSQLPORT=${{MySQL.MYSQLPORT}}
MYSQLDATABASE=${{MySQL.MYSQLDATABASE}}
MYSQLUSER=${{MySQL.MYSQLUSER}}
MYSQLPASSWORD=${{MySQL.MYSQLPASSWORD}}
```

5. Import `db/init.sql` into the Railway MySQL database once.

The Docker image deploys the WAR as `ROOT.war`, so the app is served from `/`.
