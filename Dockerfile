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

WORKDIR /opt/tomcat/webapps
RUN curl -O -L http://3.109.181.164:8081/repository/sample-release/in/javahome/myweb/8.2.0/myweb-8.2.0.war

EXPOSE 8080

CMD ["/opt/tomcat/bin/catalina.sh", "run"]
