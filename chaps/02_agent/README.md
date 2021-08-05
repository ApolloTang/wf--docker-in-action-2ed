```
docker build -t dockerinaction_02agent:1.0 .
docker images

docker run -it \
--name agent \
--link web:insideweb \
--link mailer:insidemailer \
dockerinaction_02agent:1.0 
```

