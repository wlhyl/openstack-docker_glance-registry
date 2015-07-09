# 环境变量
- GLANCE_DB: glance数据库IP
- GLANCE_DBPASS： glance数据库密码
- KEYSTONE_SERVER: keystone endpoint
- GLANCE_PASS: openstack glance用户 密码

# volumes:
- /opt/openstack/glance/: /etc/glance/
- /opt/openstack/log/glance/: /var/log/glance/
- /opt/openstack/images/: /var/lib/glance/images/