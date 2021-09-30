
## 2.2

section 2.2 (page 25)

```
docker run -d --name namespaceA busybox:1.29 /bin/sh -c "sleep 30000"
```
``` 
docker run -d --name namespaceB busybox:1.29 /bin/sh -c "nc -l 0.0.0.0 -p 80" 
```
`namespaceA and namespaceB` are the container's name.

(page 26)

```
% docker ps
CONTAINER ID   IMAGE          COMMAND                  CREATED          STATUS          PORTS     NAMES
70ba7dfdc22e   busybox:1.29   "/bin/sh -c 'sleep 3…"   43 seconds ago   Up 42 seconds             namespaceA
d7b6acda5681   busybox:1.29   "/bin/sh -c 'nc -l 0…"   2 minutes ago    Up 2 minutes              namespaceB
```
---
Use `docker exec` to run `ps` command in each container:

```
% docker exec namespaceA ps
PID   USER     TIME  COMMAND
    1 root      0:00 sleep 30000
    7 root      0:00 ps
```

```
% docker exec namespaceB ps
PID   USER     TIME  COMMAND
    1 root      0:00 nc -l 0.0.0.0 -p 80
    8 root      0:00 ps
```