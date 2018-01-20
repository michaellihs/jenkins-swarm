Automated Jenkins Setup
=======================

This repository contains a Docker Swarm setup to create an automated
Jenkins instance. See [https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/](https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/)


[TOC levels=1-3]: # " "
- [Automated Jenkins Setup](#automated-jenkins-setup)
    - [Init local Swarm](#init-local-swarm)
    - [Generate dummy image to get plugins](#generate-dummy-image-to-get-plugins)
    - [Building the Jenkins Master image](#building-the-jenkins-master-image)
    - [Building the Jenkins data image](#building-the-jenkins-data-image)
    - [Building the Jenkins config image](#building-the-jenkins-config-image)
    - [Building the nginx image](#building-the-nginx-image)
    - [Building all necessary images with Docker Compose](#building-all-necessary-images-with-docker-compose)
    - [Create Jenkins service with automated setup](#create-jenkins-service-with-automated-setup)
    - [Cleaning up afterwards](#cleaning-up-afterwards)
- [Documentation of the Jenkins image](#documentation-of-the-jenkins-image)
- [TODOs](#todos)
- [Further Resources](#further-resources)


Init local Swarm
----------------

    docker swarm init


Generate dummy image to get plugins
-----------------------------------

Start generic Jenkins container:

    docker service create --name jenkins -p 8081:8080 jenkins/jenkins:lts-alpine

Open Jenkins UI in browser:
    
    open http://localhost:8081

Read password from Jenkins container:

    ID=$(docker container ls -q -f "label=com.docker.swarm.service.name=jenkins")
     
    docker container exec -it $ID cat /var/jenkins_home/secrets/initialAdminPassword
    
Enter password to browser and install required plugins. Create an admin user with username `admin` and password `password`

Extract plugins with

    curl -u  "admin:password" "http://localhost:8081/pluginManager/api/json?depth=1" | jq -r '.plugins[].shortName' | tee plugins.txt

Shut down the service with

    docker service rm echo "admin" | docker secret create jenkins-user -
echo "admin" | docker secret create jenkins-pass -


Building the Jenkins Master image
---------------------------------

Create a Jenkins image with plugins from `plugin.txt`:

    docker image build --no-cache -t michaellihs/jenkins jenkins-master/

Optional: push image to Docker registry:

    docker image push michaellihs/jenkins


Building the Jenkins data image
-------------------------------

    docker image build -t michaellihs/jenkinsdata jenkins-data/


Building the Jenkins config image
---------------------------------

    docker image build -t michaellihs/jenkinsconf jenkins-conf/


Building the nginx image
------------------------

    docker build -t michaellihs/jenkinsnginx jenkins-nginx --no-cache


Building all necessary images with Docker Compose
-------------------------------------------------

    docker-compose -f jenkins.yml build --no-cache


Create Jenkins service with automated setup
-------------------------------------------

Create the Docker secrets used as Jenkins admin user username and password:

    echo "admin" | docker secret create jenkins-user -
    echo "password" | docker secret create jenkins-pass -

Deploy the stack:

    docker stack deploy -c jenkins.yml jenkins

Check running services:

    docker stack ps jenkins

Open UI in browser:

    open "http://localhost:8081"


Cleaning up afterwards
----------------------

    docker stack rm jenkins
    docker secret rm jenkins-user
    docker secret rm jenkins-pass


Documentation of the Jenkins image
==================================

Where is Jenkins installed?

* Jenkins home: `/var/jenkins_home`
* Jenkins configuration: `/var/jenkins_home/config.xml`
* Jenkins binary: `/usr/share/jenkins`


How can I see logs from containers

    docker logs <containerId>

How can I see logs from services in stacks

    docker stack services -q jenkins      # where 'jenkins' is the stack name
    docker service logs -f <SERVICE ID>


TODOs
=====

- [x] Add volume for (persistent) configuration
- [x] Add volume for (persistent) logfiles
- [ ] Provide and use a given Jenkins config
- [x] Configure Jenkins security to use local user database
- [ ] Provide a clean way to add script approvals
- [ ] Add Jenkins Agents
- [x] Add nginx reverse proxy
- [ ] Make port for nginx configurable (currently `8081`)
- [ ] Add SSL encryption
- [ ] Add tests


Further Resources
=================

- [Viktor Farcic's blog post](https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/)
- [Official Jenkins Docker images](https://github.com/jenkinsci/docker)
- [Groovy snippet to manage Jenkins users](https://gist.github.com/jnbnyc/c6213d3d12c8f848a385)
- [Reference for `tini` (init replacement)](https://github.com/krallin/tini)
- Riot Games Blog posts about Jenkins in Docker
  * [Putting Jenkins in a Docker Container](https://engineering.riotgames.com/news/putting-jenkins-docker-container)
  * [Docker & Jenkins - Data that persists](https://engineering.riotgames.com/news/docker-jenkins-data-persists)
  * [Jenkins, Docker, Proxies and Compose](https://engineering.riotgames.com/news/jenkins-docker-proxies-and-compose)
  * [Taking Control of your Docker Image](https://engineering.riotgames.com/news/taking-control-your-docker-image)
  * [Understanding Volumes in Docker](http://container-solutions.com/understanding-volumes-docker/)
