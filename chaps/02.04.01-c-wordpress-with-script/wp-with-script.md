### Wordpress with script




The following script is the automation wordpress with mysql

```
#!/bin/sh

DB_CID=$(docker create -e MYSQL_ROOT_PASSWORD=ch2demo mysql:5.7)
docker start $DB_CID


WP_CID=$( \
docker create \
--link $DB_CID:mysql \
-p 8000:80 \
--read-only \
-v /run/apache2/ \
--tmpfs /tmp \
wordpress:5.0.0-php7.2-apache \
)
docker start $WP_CID

```

```
% ./wp-with-script.sh
```

``` 
% docker ps -a
CONTAINER ID   IMAGE                           COMMAND                  CREATED              STATUS              PORTS                                   NAMES
cda11866acaa   wordpress:5.0.0-php7.2-apache   "docker-entrypoint.s…"   51 seconds ago       Up 48 seconds       0.0.0.0:8000->80/tcp, :::8000->80/tcp   magical_wright
450fda1fddaf   mysql:5.7                       "docker-entrypoint.s…"   About a minute ago   Up About a minute   3306/tcp, 33060/tcp                     objective_hamilton
```

```
% docker inspect --format "{{.State.Running}}" cda11866acaa
true

% docker inspect --format "{{.State.Running}}" 450fda1fddaf
true
```

### See result
[http://127.0.0.1:8000/wp-admin/install.php](http://127.0.0.1:8000/wp-admin/install.php)