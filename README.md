# 环境变量
- GLANCE_DB: glance数据库IP
- GLANCE_DBPASS： glance数据库密码
- KEYSTONE_INTERNAL_ENDPOINT: keystone internal endpoint
- KEYSTONE_ADMIN_ENDPOINT: keystone admin endpoint
- GLANCE_PASS: openstack glance用户 密码

# volumes:
- /opt/openstack/glance/: /etc/glance/
- /opt/openstack/log/glance/: /var/log/glance/
- /opt/openstack/images/: /var/lib/glance/images/

# 启动glance-registry
```bash
docker run -d --name glance-registry \
    -v /opt/openstack/glance/:/etc/glance/ \
    -v /opt/openstack/log/glance/:/var/log/glance/ \
    -e GLANCE_DB=10.64.0.52 \
    -e GLANCE_DBPASS=123456 \
    -e KEYSTONE_SERVER=10.64.0.52 \
    -e GLANCE_PASS=glance \
    --entrypoint=/bin/bash \
    10.64.0.50:5000/lzh/glance-registry:kilo
```