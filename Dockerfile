FROM tomcat:9.0

COPY ./WebContent /usr/local/tomcat/webapps/ROOT

EXPOSE 8080