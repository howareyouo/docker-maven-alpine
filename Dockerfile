FROM openjdk:8-jdk-alpine

RUN apk add --no-cache curl tar bash openssh procps

ARG MAVEN_VERSION=3.6.1
ARG USER_HOME_DIR="/root"
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries

ARG DOCKER_CLI_VERSION=18.09.6
ARG DOCKER_CLI_BINARY_URL=https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER_CLI_VERSION}.tgz

RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && curl -fsSL -o /tmp/docker.tgz ${DOCKER_CLI_BINARY_URL} \
  && tar -xzf /tmp/docker.tgz -C /tmp \
  && mv /tmp/docker/docker /usr/bin/ \
  && rm -rf /var/cache/apk/* /tmp/*\
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

COPY mvn-entrypoint.sh /usr/local/bin/mvn-entrypoint.sh
COPY settings-docker.xml /usr/share/maven/ref/

ENTRYPOINT ["/usr/local/bin/mvn-entrypoint.sh"]
CMD ["mvn"]
