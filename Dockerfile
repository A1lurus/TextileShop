FROM tomcat:9.0

COPY ./AllWeb /usr/local/tomcat/webapps/ROOT

EXPOSE 8080