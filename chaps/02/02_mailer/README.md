```
docker build -t dockerinaction_02mailer:1.0 .
docker images

docker run -d \
--name mailer \
dockerinaction_02mailer:1.0
```
