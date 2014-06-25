docker-centos-lemp
==================

Contains.
* Nginx
* MySQL
* PHP(php-fpm 5.5)

### 1. Set your timezone, loginaccount to Dockerfile

 - Dockerfile

   ```
   ENV TIMEZONE Asia/Tokyo
   ENV LOGINUSER guest
   ENV LOGINPW loginpassword
```

### 2. Build docker image

```sh
  # docker build -t centos:lemp .
  # docker images
  REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
  centos              lemp                0e15f4cf4d07        23 hours ago        562.9 MB
```

### 3. Run docker container

```sh
  # docker run -d -t -p 12812:2812 -p 10080:80 -p 10022:22 centos:lemp
  # docker ps -a
  CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                                                                   NAMES
  d2d958f98834        centos:lemp         /usr/bin/monit -I   2 hours ago         Up 2 hours          0.0.0.0:10022->22/tcp, 0.0.0.0:10080->80/tcp, 0.0.0.0:12812->2812/tcp   sick_hypatia
```

### 4. Access

###### monit
```
http://$DOCKER_HOST_IP:12812/
```

###### With Browser
Place your website to webroot(/var/www/html).
```
http://$DOCKER_HOST_IP:10080/
```

###### With ssh
```sh
  $ ssh -p 10022 -l guest $DOCKER_HOST_IP
```
