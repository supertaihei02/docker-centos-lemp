FROM centos
MAINTAINER @supertaihei02

ENV TIMEZONE Asia/Tokyo
ENV LOGINUSER guest
ENV LOGINPW loginpassword

RUN echo ZONE="$TIMEZONE" > /etc/sysconfig/clock && \
    cp "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
RUN yum update -y && \
    rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm && \
    rpm -ivh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm

# system.
RUN yum -y --enablerepo=remi,remi-php55 install sudo openssh-server syslog
RUN sed -ri "s/^UsePAM yes/#UsePAM yes/" /etc/ssh/sshd_config
RUN sed -ri "s/^#UsePAM no/UsePAM no/" /etc/ssh/sshd_config
RUN mkdir -m 700 /root/.ssh
RUN useradd $LOGINUSER && echo "$LOGINUSER:$LOGINPW" | chpasswd
RUN echo "$LOGINUSER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/$LOGINUSER
RUN chkconfig sshd on

# nginx
RUN yum -y --enablerepo=remi install nginx
ADD nginx/default.conf /etc/nginx/conf.d/default.conf

# php5
RUN yum -y --enablerepo=remi,remi-php55 install php php-devel php-fpm php-pear php-gd php-mbstring
ADD php/www.conf /etc/php-fpm.d/www.conf
ADD php/app.ini /etc/php.d/app.ini

# mysql
RUN yum -y --enablerepo=remi,remi-php55 install mysql-server php-mysql
RUN service mysqld start && \
    /usr/bin/mysqladmin -u root password "$LOGINPW"

#monit
RUN yum -y --enablerepo=remi install monit
ADD monit/monit.nginx /etc/monit.d/nginx
ADD monit/monit.sshd /etc/monit.d/sshd
ADD monit/monit.php-fpm /etc/monit.d/php-fpm
ADD monit/monit.mysqld /etc/monit.d/mysqld
ADD monit/monit.conf /etc/monit.conf
RUN mkdir /var/monit && chmod -R 600 /etc/monit.conf

EXPOSE 22 80 2812

CMD ["/usr/bin/monit", "-I"]
