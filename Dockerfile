FROM tomcat:9.0.80

# ... (no need for manual Tomcat installation)

WORKDIR /opt/tomcat/webapps
RUN curl -O -L http://13.233.56.231:8081/repository/sample-release/in/javahome/myweb/8.2.0/myweb-8.2.0.war

# Fix XML syntax for user roles
RUN sed -i 's/<role rolename='manager-gui'/<role rolename="manager-gui"/' /opt/tomcat/conf/tomcat-users.xml
RUN sed -i 's/<user username='admin' password='admin' roles='manager-gui, manager-script, manager-jmx, manager-status'/>/<user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/' /opt/tomcat/conf/tomcat-users.xml
# ... Repeat the above sed commands for other user and role lines

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
