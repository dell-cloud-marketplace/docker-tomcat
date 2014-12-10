#!/bin/sh

ADMIN_PASSWORD=`pwgen -c -n -1 12`

cat >/opt/apache-tomcat-${TOMCAT_VERSION}/conf/tomcat-users.xml <<EOL
<?xml version="1.0" encoding="utf-8"?>
<tomcat-users>
  <role rolename="admin-gui"/>
  <role rolename="admin-script"/>
  <role rolename="manager-gui"/>
  <role rolename="manager-status"/>
  <role rolename="manager-script"/>
  <user name="admin" password="$ADMIN_PASSWORD"
    roles="admin-gui,admin-script,manager-gui,manager-status,manager-script"/>
</tomcat-users>
EOL

echo "========================================================================="
echo "You can now connect to this instance using:"
echo
echo "    user name: admin"
echo "    password : $ADMIN_PASSWORD"
echo
echo "========================================================================"

# If the webapps directory is empty (the user has specified a volume), copy the
# contents from the folder in tmp (which is created when the image was built).
WEBAPPS_HOME="/opt/tomcat/webapps"
WEBAPPS_TMP="/tmp/webapps"

if [ ! "$(ls -A $WEBAPPS_HOME)" ]; then
    cp -r $WEBAPPS_TMP/* $WEBAPPS_HOME
fi

# Enable SSL
CERT_PASSWORD=`pwgen -c -n -1 12`

# Generate Self-Signed SSL certificate in a new keystore
keytool -genkey -noprompt \
-alias selfsigned \
-dname "CN=www.dell.com, OU=MarketPlace, O=Dell, C=US" \
-keyalg RSA \
-storepass $CERT_PASSWORD \
-keypass $CERT_PASSWORD \
-validity 360 \
-keysize 2048 \
-keystore keystore.jks

# Uncomment SSL section in server.xml
# and insert SSL certificate information
sed -i '$!N;s/<!--\s*\n\s*<Connector port="8443"/<Connector port="8443" keyAlias="selfsigned" \
               keystoreFile="\/keystore.jks" keystorePass="'$CERT_PASSWORD'"/g;P;D' \
               /opt/apache-tomcat-${TOMCAT_VERSION}/conf/server.xml

sed -i '$!N;s/clientAuth="false" sslProtocol="TLS" \/>\n\s*-->/clientAuth="false" sslProtocol="TLS" \/>/g;P;D' \
/opt/apache-tomcat-${TOMCAT_VERSION}/conf/server.xml

/opt/tomcat/bin/catalina.sh run
