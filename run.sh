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
  <role rolename="manager-jmx"/>
  <user name="admin" password="$ADMIN_PASSWORD" roles="admin-gui,admin-script,manager-gui,manager-status,manager-script,manager-jmx"/>
</tomcat-users>
EOL

echo "========================================================================="
echo "You can now connect to this instance using:"
echo
echo "    user name: admin"
echo "    password : $ADMIN_PASSWORD"
echo
echo "========================================================================"

DIR=${DEPLOY_DIR:-/maven}
echo "Checking *.war in $DIR"
if [ -d $DIR ]; then
  for i in $DIR/*.war; do
     file=$(basename $i)
     echo "Linking $i --> /opt/tomcat/webapps/$file"
     ln -s $i /opt/tomcat/webapps/$file
  done
fi

# Use faster (though more unsecure) random number generator
export CATALINA_OPTS="$CATALINA_OPTS $(jolokia_opts) -Djava.security.egd=file:/dev/./urandom"
/opt/tomcat/bin/catalina.sh run
