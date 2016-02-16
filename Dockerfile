# image name lzh/glance-registry:liberty
FROM 10.64.0.50:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-01-07
ENV OPENSTACK_VERSION liberty
ENV BUID_VERSION 2016-02-16

RUN yum update -y && \
         yum install -y openstack-glance python-glance python-glanceclient && \
         rm -rf /var/cache/yum/*

RUN cp -rp /etc/glance/ /glance && \
         rm -rf /etc/glance/* && \
         rm -rf /var/log/glance/*

VOLUME ["/etc/glance"]
VOLUME ["/var/log/glance"]

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD glance-registry.ini /etc/supervisord.d/glance-registry.ini

ENTRYPOINT ["/usr/bin/entrypoint.sh"]