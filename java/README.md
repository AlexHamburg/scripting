## Run [heap-thread-dump.sh](heap-thread-dump.sh) inside docker container
```
docker exec -i <container_name> /bin/sh < heap-thread-dump.sh
```
or
```
docker exec <container_name> ./heap-thread-dump.sh
```
where *<container_name>* is full name of your container

## Copy dumps to local machine
```
sudo docker cp <container_name>:/threadDump.tdump .
sudo docker cp <container_name>:/heapDump.hprof .
```
where *<container_name>* is full name of your container