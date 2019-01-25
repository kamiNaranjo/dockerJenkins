FROM cloudbees/cloudbees-core-cm:latest

LABEL app-name="jenkins-sura-maestro"
LABEL version="1.0"
LABEL tag="kami/jenkins"

COPY init.groovy.d/ /opt/jenkins/ref/init.groovy.d

USER root

# add config file
COPY jenkins.yaml /opt/jenkins/ref/

# add environment variable to point to configuration file
ENV CASC_JENKINS_CONFIG /opt/jenkins/ref/jenkins.yaml

#Install plugin(s) that are not bundled by default
ENV JENKINS_UC http://jenkins-updates.cloudbees.com

# ENV JENKINS_UC http://updates.jenkins-ci.org/experimental/update-center.json
ADD https://raw.githubusercontent.com/jenkinsci/docker/master/install-plugins.sh /opt/jenkins/local/bin/install-plugins.sh
RUN chmod 755 /opt/jenkins/local/bin/install-plugins.sh

ADD https://raw.githubusercontent.com/jenkinsci/docker/master/jenkins-support /opt/jenkins/local/bin/jenkins-support
RUN chmod 755 /opt/jenkins/local/bin/jenkins-support

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /opt/jenkins/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# "this Jenkins environment is fully configured"
RUN echo 2.0 > /opt/jenkins/share/jenkins/ref/jenkins.install.UpgradeWizard.state

USER jenkins