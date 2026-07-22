#!/bin/sh
set -eu

SERVER_XML=/usr/local/tomcat/conf/server.xml

# Bind the HTTP connector to whatever port the platform hands us. Railway,
# Render and Heroku all inject PORT; locally it falls back to 8080.
HTTP_PORT="${PORT:-8080}"
sed -i "s/port=\"8080\" protocol=\"HTTP\/1.1\"/port=\"${HTTP_PORT}\" protocol=\"HTTP\/1.1\"/" "$SERVER_XML"

# Disable Tomcat's shutdown port (default 8005).
#
# In a container nothing uses it: the runtime stops the app with a signal. Left
# enabled it is a second open port with no purpose, and a platform health check
# that lands on it gets answered with a stream of
# "Invalid shutdown command [HEAD / HTTP/1.1] received" instead of a real
# response. Setting the port to -1 makes Tomcat skip the listener entirely.
sed -i "s/<Server port=\"8005\" shutdown=\"SHUTDOWN\">/<Server port=\"-1\" shutdown=\"SHUTDOWN\">/" "$SERVER_XML"

# Log the resolved port so the startup line in the platform log is unambiguous.
echo "Starting Tomcat on port ${HTTP_PORT} (shutdown port disabled)"

exec catalina.sh run
