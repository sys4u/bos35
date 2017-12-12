FROM tomcat:8.0.20-jre8
ARG VERSION
ARG WARFILE

TAG $VERSION

WORKDIR /

COPY ./catalina.sh /usr/local/tomcat/bin/catalina.sh
RUN chmod +x /usr/local/tomcat/bin/catalina.sh


##WARFILE is build-arg that input when image is built
RUN wget -P /usr/local/tomcat/webapps/ $WARFILE
RUN mv /usr/local/tomcat/webapps/admin*.war /usr/local/tomcat/webapps/admin.war
RUN unzip -d /usr/local/tomcat/webapps/admin /usr/local/tomcat/webapps/admin.war

EXPOSE 8009
EXPOSE 8080
