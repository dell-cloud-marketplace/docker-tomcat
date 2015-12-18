FROM dell/java-base-7:1.0
MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

# Set environment variable for package install
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y pwgen 

ENV TOMCAT_VERSION 8.0.9

# Get and unpack Tomcat.
RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/\
apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz && \
    tar xzf /tmp/catalina.tar.gz -C /opt && \
    ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat && \
    rm /tmp/catalina.tar.gz

# Make a copy of the webapps folder, in case an empty or non-existent host
# folder is specified for the (webapps) volume. We'll test for this in run.sh.
RUN cp -r /opt/tomcat/webapps /tmp/webapps

# Add the startup script
ADD run.sh /run.sh
RUN chmod +x /run.sh

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

# Environmental variables.
ENV ADMIN_PASS ""
ENV CERT_PASS ""

# Expose Tomcat ports
EXPOSE 8080 8443

VOLUME ["/opt/tomcat/logs", "/opt/tomcat/work", "/opt/tomcat/webapps"]

CMD ["/run.sh"]

