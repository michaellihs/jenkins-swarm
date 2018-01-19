FROM alpine
MAINTAINER Michael Lihs <mimi@kaktusteam.de>

# TODO fix issue that we have to pass uid in between Dockerfiles
# TODO originally this uid comes from the Jenkins Dockerfile
RUN adduser -h "/var/jenkins_home" -u 1000 -D -s /bin/bash jenkins

RUN mkdir -p /var/log/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins

VOLUME ["/var/log/jenkins"]

USER jenkins

CMD ["echo", "Data container for Jenkins"]
