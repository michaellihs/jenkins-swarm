FROM jenkins/jenkins:lts-alpine

# Create Jenkins Folders
USER root
RUN mkdir /var/log/jenkins && chown -R jenkins:jenkins /var/log/jenkins
RUN mkdir /var/cache/jenkins && chown -R jenkins:jenkins /var/cache/jenkins
RUN mkdir /var/jenkins_jobs && chown -R jenkins:jenkins /var/jenkins_jobs

USER jenkins
ENV JENKINS_OPTS="--handlerCountMax=300 --logfile=/var/log/jenkins/jenkins.log --webroot=/var/cache/jenkins/war"
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Copy init scripts to run upon Jenkins start
USER root
COPY init.groovy.d/ /usr/share/jenkins/ref/init.groovy.d/
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# TODO workaround until we fix download of plugins...
COPY plugins-cache/* /usr/share/jenkins/ref/plugins/
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/plugins
USER jenkins

# Copy list of plugins and install them when building the image
#RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# Copy configurations into place when building image
COPY plugin-config/ /usr/share/jenkins/ref/
COPY config/ /usr/share/jenkins/ref/

# Fix file permissions for /usr/share/jenkins/ref/
USER root
RUN chown -R jenkins:jenkins /usr/share/jenkins/ref/
USER jenkins

# Copy custom start script to run parametrization during container start
#COPY start-jenkins.sh /usr/local/bin/start-jenkins.sh
#ENTRYPOINT ["/usr/local/bin/start-jenkins.sh"]
#ENTRYPOINT ["/bin/sh"]