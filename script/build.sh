#!/bin/bash

docker build -t refman .
docker stop refman
docker rm refman
docker run -d -p 127.0.0.1:8013:8080 --link mysql:mysql --name refman refman
