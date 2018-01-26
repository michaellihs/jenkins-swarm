#!/bin/bash

docker swarm init

echo "admin" | docker secret create jenkins-user -
echo "password" | docker secret create jenkins-pass -

docker build --no-cache -t michaellihs/jenkinsnginx jenkins-nginx/
docker build --no-cache -t michaellihs/jenkins jenkins-master/
docker build --no-cache -t michaellihs/jenkinsjobs jenkins-jobs/
docker build --no-cache -t michaellihs/jenkinsdata jenkins-data/
docker build --no-cache -t michaellihs/jenkinsconf jenkins-conf/

docker stack deploy -c jenkins.yml jenkins
