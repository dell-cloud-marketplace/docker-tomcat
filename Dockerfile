FROM jolokia/java-jolokia:7

MAINTAINER Dell Cloud Market Place <Cloud_Marketplace@dell.com>

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install pwgen 

ENV TOMCAT_VERSION 8.0.9
ENV DEPLOY_DIR /maven

# Get and Unpack Tomcat
RUN wget http://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/ \
apache-tomcat-${TOMCAT_VERSION}.tar.gz -O /tmp/catalina.tar.gz
RUN tar xzf /tmp/catalina.tar.gz -C /opt
RUN ln -s /opt/apache-tomcat-${TOMCAT_VERSION} /opt/tomcat
RUN rm /tmp/catalina.tar.gz

# Jolokia config
ADD jolokia.properties /opt/jolokia/jolokia.properties

# Startup script
ADD run.sh /opt/apache-tomcat-${TOMCAT_VERSION}/bin/run.sh

VOLUME ["/opt/tomcat/logs", "/opt/tomcat/work"]
VOLUME ["/opt/tomcat/temp", "/tmp/hsperfdata_root"]

ENV CATALINA_HOME /opt/tomcat
ENV PATH $PATH:$CATALINA_HOME/bin

EXPOSE 8080 8778

CMD /opt/apache-tomcat-${TOMCAT_VERSION}/bin/run.sh
