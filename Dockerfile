# image name lzh/glance-registry:kilo
FROM registry.lzh.site:5000/lzh/openstackbase:kilo

MAINTAINER Zuhui Liu penguin_tux@live.com

ENV BASE_VERSION 2015-08-12
ENV OPENSTACK_VERSION kilo


ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get dist-upgrade -y
RUN apt-get -t jessie-backports install glance-registry -y
RUN apt-get clean

RUN env --unset=DEBIAN_FRONTEND

RUN cp -rp /etc/glance/ /glance
RUN rm -rf /etc/glance/*
RUN rm -rf /var/log/glance/*

VOLUME ["/etc/glance"]
VOLUME ["/var/log/glance"]

ADD entrypoint.sh /usr/bin/entrypoint.sh
RUN chmod +x /usr/bin/entrypoint.sh

ADD glance-registry.conf /etc/supervisor/conf.d/glance-registry.conf

ENTRYPOINT ["/usr/bin/entrypoint.sh"]