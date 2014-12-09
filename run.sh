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

/opt/tomcat/bin/catalina.sh run
