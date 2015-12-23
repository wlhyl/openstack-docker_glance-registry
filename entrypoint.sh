#!/bin/bash

if [ -z "$GLANCE_DBPASS" ];then
  echo "error: GLANCE_DBPASS not set"
  exit 1
fi

if [ -z "$GLANCE_DB" ];then
  echo "error: GLANCE_DB not set"
  exit 1
fi

if [ -z "$GLANCE_PASS" ];then
  echo "error: GLANCE_PASS not set"
  exit 1
fi

if [ -z "$KEYSTONE_INTERNAL_ENDPOINT" ];then
  echo "error: KEYSTONE_INTERNAL_ENDPOINT not set"
  exit 1
fi

if [ -z "$KEYSTONE_ADMIN_ENDPOINT" ];then
  echo "error: KEYSTONE_ADMIN_ENDPOINT not set"
  exit 1
fi

CRUDINI='/usr/bin/crudini'

CONNECTION=mysql://glance:$GLANCE_DBPASS@$GLANCE_DB/glance

if [ ! -f /etc/glance/.complete ];then
    cp -rp /glance/* /etc/glance

    $CRUDINI --set /etc/glance/glance-registry.conf database connection $CONNECTION

    $CRUDINI --del /etc/glance/glance-registry.conf keystone_authtoken
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$KEYSTONE_INTERNAL_ENDPOINT:5000
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://$KEYSTONE_ADMIN_ENDPOINT:35357
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken username glance
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken password $GLANCE_PASS
    
    $CRUDINI --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
    $CRUDINI --set /etc/glance/glance-registry.conf paste_deploy config_file /usr/share/glance/glance-api-dist-paste.ini
    
    $CRUDINI --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
    
    touch /etc/glance/.complete
fi

chown -R glance:glance /var/log/glance/

/usr/bin/supervisord -n