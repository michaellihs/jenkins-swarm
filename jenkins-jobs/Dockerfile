FROM alpine
MAINTAINER Michael Lihs <mimi@kaktusteam.de>

# TODO fix issue that we have to pass uid in between Dockerfiles
# TODO originally this uid comes from the Jenkins Dockerfile
RUN adduser -h "/var/jenkins_home" -u 1000 -D -s /bin/bash jenkins

RUN mkdir -p /var/jenkins_jobs
RUN chown -R jenkins:jenkins /var/jenkins_jobs

VOLUME ["/var/jenkins_jobs"]

USER jenkins

CMD ["echo", "Config container for Jenkins"]