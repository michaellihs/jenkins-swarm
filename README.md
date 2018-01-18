Automated Jenkins Setup
=======================

This repository contains a Docker Swarm setup to create an automated
Jenkins instance. See [https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/](https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/)


[TOC levels=1-3]: # " "
- [Automated Jenkins Setup](#automated-jenkins-setup)
    - [Init local Swarm](#init-local-swarm)
    - [Generate dummy image to get plugins](#generate-dummy-image-to-get-plugins)
    - [Preparing the image](#preparing-the-image)
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

    curl -s -k "http://admin:admin@localhost:8080/pluginManager/api/json?depth=1" \
      | jq -r '.plugins[].shortName' | tee plugins.txt

Shut down the service with

    docker service rm jenkins


Preparing the image
-------------------

Create a Jenkins image with plugins from `plugin.txt`:

    docker image build -t michaellihs/jenkins .

Optional: push image to Docker registry:

    docker image push michaellihs/jenkins


Create Jenkins service with automated setup
-------------------------------------------

Create the Docker secrets used as Jenkins admin user username and password:

    echo "admin" | docker secret create jenkins-user -
    echo "admin" | docker secret create jenkins-pass -

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


How can I see logs

    docker logs <containerId>


TODOs
=====

- [ ] Add volume for (persistent) configuration
- [ ] Add volume for (persistent) logfiles
- [ ] Add volume for (persistent) job configuration
- [ ] Provide and use a given Jenkins config
- [x] Configure Jenkins security to use local user database
- [ ] Provide a clean way to add script approvals


Further Resources
=================

- [Viktor Farcic's blog post](https://technologyconversations.com/2017/06/16/automating-jenkins-docker-setup/)
- [Official Jenkins Docker images](https://github.com/jenkinsci/docker)
- [Groovy snippet to manage Jenkins users](https://gist.github.com/jnbnyc/c6213d3d12c8f848a385)
- [Reference for `tini` (init replacement)](https://github.com/krallin/tini)
