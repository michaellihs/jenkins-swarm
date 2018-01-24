FROM debian:jessie
MAINTAINER Michael Lihs <mimi@kaktusteam.de>

# TODO fix issue that we have to pass uid in between Dockerfiles
# TODO originally this uid comes from the Jenkins Dockerfile
RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins

RUN mkdir -p /var/jenkins_home
RUN chown -R jenkins:jenkins /var/jenkins_home

VOLUME ["/var/jenkins_home"]

USER jenkins

CMD ["echo", "Config container for Jenkins"]