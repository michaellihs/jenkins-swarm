FROM jenkins/jenkins:lts-alpine

# Create Jenkins Log Folder
USER root
RUN mkdir /var/log/jenkins
RUN mkdir /var/cache/jenkins
RUN chown -R jenkins:jenkins /var/log/jenkins
RUN chown -R jenkins:jenkins /var/cache/jenkins
USER jenkins

ENV JENKINS_OPTS="--handlerCountStartup=100 --handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Copy init scripts to run upon Jenkins start
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
USER root
RUN chown -R jenkins /usr/share/jenkins/ref/init.groovy.d/*
USER jenkins

# Copy list of plugins and install them when building the image
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy configurations into place when building image
USER root
RUN mkdir /usr/share/jenkins/ref/plugin-config && \
    chown -R jenkins:jenkins /usr/share/jenkins/ref/plugin-config && \
    mkdir /usr/share/jenkins/ref/config && \
    chown -R jenkins:jenkins /usr/share/jenkins/ref/config
USER jenkins
COPY plugin-config/ /usr/share/jenkins/ref/plugin-config/
COPY config/ /usr/share/jenkins/ref/config/

# Create directory for Jenkins jobs
USER root
RUN mkdir /var/jenkins_jobs && chown -R jenkins:jenkins /var/jenkins_jobs

# Copy custom start script to run parametrization during container start
#COPY start-jenkins.sh /usr/local/bin/start-jenkins.sh
#ENTRYPOINT ["/usr/local/bin/start-jenkins.sh"]