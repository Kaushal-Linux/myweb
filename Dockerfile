FROM centos

MAINTAINER hello@gritfy.com

RUN mkdir /opt/tomcat/

WORKDIR /opt/tomcat
RUN curl -O https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.80/bin/apache-tomcat-9.0.80.tar.gz
RUN tar -xvzf apache*.tar.gz
RUN mv apache-tomcat-9.0.80/* /opt/tomcat/.
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum repolist;yum -y install java-1.8.0-openjdk
RUN java -version
RUN sed -i '/<\/tomcat-users>/d' /opt/tomcat/conf/tomcat-users.xml
RUN echo '-->' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <role rolename="manager-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <role rolename="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <role rolename="manager-jmx"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <role rolename="manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <user username="admin" password="admin" roles="manager-gui, manager-script, manager-jmx, manager-status"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <user username="deployer" password="deployer" roles="manager-script"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo '  <user username="tomcat" password="s3cret" roles="manager-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml
RUN echo "</tomcat-users>" >> /opt/tomcat/conf/tomcat-users.xml
RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!--&/;s/allow="127\\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/>/-->/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
RUN sed -i 's/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/<!--&/;s/allow="127\\\.\\d+\\.\\d+\\.\\d+|::1|0:0:0:0:0:0:0:1" \/>/-->/' /opt/tomcat/webapps/manager/META-INF/context.xml

WORKDIR /opt/tomcat/webapps
RUN curl -O -L http://13.233.56.231:8081/repository/sample-release/in/javahome/myweb/8.2.0/myweb-8.2.0.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
