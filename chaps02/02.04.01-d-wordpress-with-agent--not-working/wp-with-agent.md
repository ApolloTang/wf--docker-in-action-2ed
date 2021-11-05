Build image first:

```
cd <chapter>/02_agent
docker build -t dockerinaction_02agent:1.0 -f ./Dockerfile .

cd <chapter>/02_mailer
docker build -t dockerinaction_02mailer:1.0 -f ./Dockerfile .

docker images
REPOSITORY                TAG       IMAGE ID       CREATED          SIZE
dockerinaction_02agent    1.0       cc1c10a12a79   6 seconds ago    1.24MB
dockerinaction_02mailer   1.0       3a3ed6f4c035   23 minutes ago   1.24MB
``` 

The following scripte is the automation of above with Agent

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


MAILER_CID=$(docker create dockerinaction_02mailer:1.0)
docker start $MAILER_CID

AGENT_CID=$( \
docker create \
--link $WP_CID:insideweb \
--link $MAILER_CID:insidemailer \
dockerinaction_02agent:1.0 \
)
docker start $AGENT_CID

```

I could not get this script to work. With the following messages:

```
$ docker ps -a
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS                     PORTS                  NAMES
e85273a16315   dockerinaction_02agent:1.0      "/watcher/watcher.sh"    6 seconds ago    Exited (0) 4 seconds ago                          angry_mclean
d8abfee1dd4b   dockerinaction_02mailer:1.0     "/mailer/mailer.sh"      25 seconds ago   Up 24 seconds              33333/tcp              kind_wilson
3fb4cf4287dd   wordpress:5.0.0-php7.2-apache   "docker-entrypoint.s…"   44 seconds ago   Up 42 seconds              0.0.0.0:8000->80/tcp   priceless_margulis
864a7fc8d81b   mysql:5.7                       "docker-entrypoint.s…"   3 minutes ago    Up 3 minutes               3306/tcp, 33060/tcp    lucid_ardinghelli

$ docker run angry_mclean
Unable to find image 'angry_mclean:latest' locally
docker: Error response from daemon: pull access denied for angry_mclean, repository does not exist or may require 'docker login': denied: requested access to the resource is denied.
See 'docker run --help'.
```

I think it has something to do with the containder `WP_CID`, if I am running a simple iginx container like that in `02.03.02-a-container-dependencies` I don't have error.