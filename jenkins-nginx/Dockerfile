FROM centos:centos7
MAINTAINER Michael Lihs <mimi@kaktusteam.de>

RUN yum -y update; yum clean all && \
    yum -y install http://nginx.org/packages/centos/7/noarch/RPMS/nginx-release-centos-7-0.el7.ngx.noarch.rpm; yum -y makecache && \
    yum -y install nginx-1.8.0

COPY jenkins.conf /etc/nginx/conf.d/jenkins.conf
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8081

CMD ["nginx"]
