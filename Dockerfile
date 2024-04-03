FROM jenkins/jenkins:2.414.2-jdk11
USER root
ADD --chmod=0755 https://artifactory.prodwest.citrixsaassbe.net/repository/releases/goto-cert/goto-cert-setup/LATEST/goto-cert-setup-LATEST.sh /goto-cert-setup.sh
RUN /goto-cert-setup.sh
RUN apt-get update && apt-get install -y lsb-release python3-pip
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli
USER jenkins
RUN jenkins-plugin-cli --plugins "blueocean:1.25.3 docker-workflow:1.28"