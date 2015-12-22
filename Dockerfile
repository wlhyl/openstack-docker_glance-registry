# image name lzh/glance-registry:liberty
FROM 10.64.0.50:5000/lzh/openstackbase:liberty

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-12-22
ENV OPENSTACK_VERSION liberty
ENV BUILD_VERSION 2015-12-22

RUN yum update -y
RUN yum install -y openstack-glance python-glance python-glanceclient
RUN yum clean all
RUN rm -rf /var/cache/yum/*

RUN cp -rp /etc/glance/ /glance
RUN rm -rf /etc/glance/*
RUN rm -rf /var/log/glance/*

VOLUME ["/etc/glance"]
VOLUME ["/var/log/glance"]

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD glance-registry.ini /etc/supervisord.d/glance-registry.ini

ENTRYPOINT ["/usr/bin/entrypoint.sh"]