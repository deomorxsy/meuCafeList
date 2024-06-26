FROM alpine:3.18 as base

#ARG version=8.382.05.1
#ARG version=22.0.0.37.1; builds, no maven
ARG version=21.0.2.14.1
# works with maven

#slim build with jlink to keep jre size at a minimum
RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-21=$version-r0 binutils && \
    /usr/lib/jvm/default-jvm/bin/jlink --add-modules "$(java --list-modules | sed -e 's/@[0-9].*$/,/' | tr -d \\n)" --no-man-pages --no-header-files --strip-debug --output /opt/corretto-slim && \
    apk del binutils amazon-corretto-21 && \
    mkdir -p /usr/lib/jvm/ && \
    mv /opt/corretto-slim /usr/lib/jvm/java-21-amazon-corretto && \
    ln -sfn /usr/lib/jvm/java-21-amazon-corretto /usr/lib/jvm/default-jvm
    # && \
    #chown 1000:1000


ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
#ENV JAVA_HOME="$(/usr/libexec/java_home -v 21)"
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

#ARG APPLICATION_USER=appuser
#RUN adduser --no-create-home -u 1000 -D $APPLICATION_USER && \
#    mkdir /app && \
#    chown -R $APPLICATION_USER /app

# ====== maven setup, new layer ======

FROM base as build

ENV MAVEN_VERSION 3.9.2
ENV MAVEN_HOME /usr/lib/mvn
#ENV PATH $MAVEN_HOME/bin:$PATH
ENV PATH=$PATH:$MAVEN_HOME/bin:$PATH

ARG APPLICATION_USER=appuser
RUN adduser --no-create-home -u 1000 -D $APPLICATION_USER && \
    mkdir -p /app && \
    chown -R $APPLICATION_USER /app

WORKDIR /app

COPY . .

RUN wget http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  tar -zxvf apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  rm apache-maven-$MAVEN_VERSION-bin.tar.gz && \
  mv apache-maven-$MAVEN_VERSION /usr/lib/mvn && \
  mvn validate && mvn compile exec:java -Dexec.mainClass="com.meucafelist.app.App" && \
  mvn test && \
  mvn package -f .

# ====================
#
# take from where the first stopped
FROM base as relay

ARG APPLICATION_USER=appuser
RUN adduser --no-create-home -u 1000 -D $APPLICATION_USER && \
    mkdir -p /app && \
    chown -R $APPLICATION_USER /app

USER 1000

#COPY --from=build --chown=1000:1000 ./server/src/main/java/com/meucafelist/app/App.java /app/App.java
# the name of the snapshot is defined in the pom.xml
COPY --from=build --chown=1000:1000 /app/target/server-1.0-SNAPSHOT.jar /app/App.jar
#COPY --from=build /app/target/server-1.0-SNAPSHOT.jar /app/App.jar
WORKDIR /app

EXPOSE 8080
#ENTRYPOINT/CMD [ "/jre/bin/java", "-jar", "/app/app.jar" ]
ENTRYPOINT [ "/usr/lib/jvm/default-jvm/bin/java", "-jar", "/app/App.jar" ]
#ENTRYPOINT [ "/usr/lib/jvm/default-jvm/bin/java", "/app/mcl.java" ]
##ENTRYPOINT [ "mvn", "compile" "exec:java", "-Dexec.mainClass=", "com.meucafelist.app", "-f", "./server/pom.xml", "-e"]



