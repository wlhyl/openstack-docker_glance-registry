#!/bin/bash
#set -e表示一旦脚本中有命令的返回值为非0，则脚本立即退出，后续命令不再执行;
#set -o pipefail表示在管道连接的命令序列中，只要有任何一个命令返回非0值，则整个管道返回非0值，即使最后一个命令返回0.

if [ -z "$GLANCE_DBPASS" ];then
  echo "error: GLANCE_DBPASS not set"
  exit 1
fi

if [ -z "$GLANCE_DB" ];then
  echo "error: GLANCE_DB not set"
  exit 1
fi

if [ -z "$KEYSTONE_SERVER" ];then
  echo "error: KEYSTONE_SERVER not set"
  exit 1
fi

if [ -z "$GLANCE_PASS" ];then
  echo "error: GLANCE_PASS not set"
  exit 1
fi

CRUDINI='/usr/bin/crudini'

CONNECTION=mysql://glance:$GLANCE_DBPASS@$GLANCE_DB/glance

if [ ! -f /etc/glance/.complete ];then
    cp -rp /glance/* /etc/glance
    chown glance:glance /var/log/glance/
    
    $CRUDINI --set /etc/glance/glance-api.conf database connection $CONNECTION

    $CRUDINI --del /etc/glance/glance-api.conf keystone_authtoken
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken auth_uri http://$KEYSTONE_SERVER:5000
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken auth_url http://$KEYSTONE_SERVER:35357
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken auth_plugin password
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken project_domain_id default
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken user_domain_id default
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken project_name service
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken username glance
    $CRUDINI --set /etc/glance/glance-api.conf keystone_authtoken password $GLANCE_PASS
    
    $CRUDINI --set /etc/glance/glance-api.conf paste_deploy flavor keystone
    
    $CRUDINI --set /etc/glance/glance-api.conf glance_store default_store file
    $CRUDINI --set /etc/glance/glance-api.conf filesystem_store_datadir /var/lib/glance/images/
    
    $CRUDINI --set /etc/glance/glance-api.conf DEFAULT notification_driver noop
    
    # 配置 /etc/glance/glance-registry.conf
    $CRUDINI --set /etc/glance/glance-registry.conf database connection $CONNECTION

    $CRUDINI --del /etc/glance/glance-registry.conf keystone_authtoken
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_uri http://$KEYSTONE_SERVER:5000
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_url http://$KEYSTONE_SERVER:35357
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken auth_plugin password
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken project_domain_id default
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken user_domain_id default
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken project_name service
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken username glance
    $CRUDINI --set /etc/glance/glance-registry.conf keystone_authtoken password $GLANCE_PASS
    
    $CRUDINI --set /etc/glance/glance-registry.conf paste_deploy flavor keystone
    
    $CRUDINI --set /etc/glance/glance-registry.conf DEFAULT notification_driver noop
    
    touch /etc/glance/.complete
fi

# 同步数据库
echo 'select * from images limit 1;' | mysql -h$GLANCE_DB  -uglance -p$GLANCE_DBPASS glance
if [ $? != 0 ];then
    su -s /bin/sh -c "glance-manage db_sync" glance
fi

/usr/bin/supervisord -n