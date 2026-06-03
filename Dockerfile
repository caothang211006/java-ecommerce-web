FROM tomcat:9.0-jdk17-temurin AS build

WORKDIR /app
COPY . .

RUN rm -rf build dist \
    && mkdir -p build/web/WEB-INF/classes dist \
    && cp -R web/. build/web/ \
    && find src/java -name "*.java" > sources.txt \
    && javac -encoding UTF-8 -source 8 -target 8 \
        -cp "/usr/local/tomcat/lib/servlet-api.jar:build/web/WEB-INF/lib/*" \
        -d build/web/WEB-INF/classes \
        @sources.txt \
    && jar -cf dist/app.war -C build/web .

FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

COPY --from=build /app/dist/app.war /usr/local/tomcat/webapps/ROOT.war
COPY docker/start-tomcat.sh /usr/local/bin/start-tomcat.sh

RUN chmod +x /usr/local/bin/start-tomcat.sh

EXPOSE 8080

CMD ["/usr/local/bin/start-tomcat.sh"]
