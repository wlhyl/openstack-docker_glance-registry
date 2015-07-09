# 环境变量
- GLANCE_DB: glance数据库IP
- GLANCE_DBPASS： glance数据库密码
- KEYSTONE_SERVER: keystone endpoint
- GLANCE_PASS: openstack glance用户 密码

# volumes:
- /opt/openstack/glance/: /etc/glance/
- /opt/openstack/log/glance/: /var/log/glance/
- /opt/openstack/images/: /var/lib/glance/images/

# 启动glance
docker run -d --name glance -p 9292:9292 \
    -v /opt/openstack/glance/:/etc/glance/ \
    -v /opt/openstack/log/glance/:/var/log/glance/ \
    -v /opt/openstack/images/:/var/lib/glance/images/ \
    -e GLANCE_DB=10.64.0.52 \
    -e GLANCE_DBPASS=123456 \
    -e KEYSTONE_SERVER=10.64.0.52 \
    -e GLANCE_PASS=glance \
    --entrypoint=/bin/bash \
    10.64.0.50:5000/lzh/glance:kilo