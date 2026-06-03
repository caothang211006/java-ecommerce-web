#!/bin/sh
set -eu

HTTP_PORT="${PORT:-8080}"
sed -i "s/port=\"8080\" protocol=\"HTTP\/1.1\"/port=\"${HTTP_PORT}\" protocol=\"HTTP\/1.1\"/" /usr/local/tomcat/conf/server.xml

exec catalina.sh run
