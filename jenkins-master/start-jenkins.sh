#! /bin/bash

set -e
set -x

whoami

JENKINS_JOBS='/var/jenkins_jobs/jobs'
JENKINS_SHARE='/usr/share/jenkins/ref'

if [ ! -d "${JENKINS_JOBS}" ]; then
  mkdir -p ${JENKINS_JOBS}
  chown -R jenkins:jenkins ${JENKINS_JOBS}
fi

cp -a ${JENKINS_SHARE}/config/* ${JENKINS_HOME}/
cp -a ${JENKINS_SHARE}/plugin-config/* ${JENKINS_HOME}/

ls -la /usr/local/bin/

/sbin/tini -s -- /usr/local/bin/jenkins.sh
