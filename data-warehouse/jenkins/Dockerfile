FROM jenkins/jenkins:2.516.3-jdk21

# install docker
USER root
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

USER jenkins

# disable setup wizard
ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

# Setup Configuration as Code (CasC)
ENV CASC_JENKINS_CONFIG="/var/jenkins_home/casc_configs/jenkins.yaml" 
COPY --chown=jenkins:jenkins ./config/jenkins.yaml /var/jenkins_home/casc_configs/jenkins.yaml

# Install Jenkins plugins
COPY --chown=jenkins:jenkins ./config/plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
