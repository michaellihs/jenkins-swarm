FROM debian:jessie
MAINTAINER Maxfield Stewart

# Create the jenkins user
# TODO fix issue that we have to pass uid in between Dockerfiles
# TODO originally this uid comes from the Jenkins Dockerfile
RUN useradd -d "/var/jenkins_home" -u 1000 -m -s /bin/bash jenkins

# Create the folders and volume mount points
RUN mkdir -p /var/log/jenkins && chown -R jenkins:jenkins /var/log/jenkins

VOLUME ["/var/log/jenkins", "/var/jenkins_home"]

USER jenkins
CMD ["echo", "Data container for Jenkins"]