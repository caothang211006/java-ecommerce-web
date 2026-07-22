# ---------- build stage ----------
FROM tomcat:9.0-jdk17-temurin AS build

WORKDIR /app
COPY . .

# mysql-connector-j is committed under web/WEB-INF/lib, so the build needs no
# network access. If it is missing, restore it with:
#   git checkout -- web/WEB-INF/lib/
RUN set -eux; \
    ls web/WEB-INF/lib/mysql-connector-j-*.jar >/dev/null \
        || { echo "ERROR: mysql-connector-j jar missing from web/WEB-INF/lib"; exit 1; }; \
    # Drop SQL Server leftovers: the driver is unused now and the auth DLL is
    # a Windows binary that can never load on Linux.
    rm -f web/WEB-INF/lib/mssql-jdbc-*.jar web/WEB-INF/lib/mssql-jdbc_auth-*.dll; \
    rm -rf build dist; \
    mkdir -p build/web/WEB-INF/classes dist; \
    cp -R web/. build/web/; \
    find src/java -name "*.java" > sources.txt; \
    javac -encoding UTF-8 -source 8 -target 8 -nowarn \
        -cp "/usr/local/tomcat/lib/servlet-api.jar:build/web/WEB-INF/lib/*" \
        -d build/web/WEB-INF/classes \
        @sources.txt; \
    jar -cf dist/app.war -C build/web .

# ---------- runtime stage ----------
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/dist/app.war /usr/local/tomcat/webapps/ROOT.war
COPY docker/start-tomcat.sh /usr/local/bin/start-tomcat.sh

RUN chmod +x /usr/local/bin/start-tomcat.sh

# Force UTF-8 so Vietnamese product names survive the round trip.
# MaxRAMPercentage keeps the heap inside small containers (Render's free tier is
# 512 MB); the JVM reads the cgroup limit, so this adapts to whatever it is given.
ENV CATALINA_OPTS="-Dfile.encoding=UTF-8 -Duser.timezone=UTC -XX:MaxRAMPercentage=60"

EXPOSE 8080

CMD ["/usr/local/bin/start-tomcat.sh"]
