FROM alpine:3.18

#ARG version=8.382.05.1
ARG version=20.0.2.9.1

RUN apk add --no-cache binutils

#slim build with jlink to keep jre size at a minimum
RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories && \
    apk add --no-cache amazon-corretto-20=$version-r0 binutils && \
    /usr/lib/jvm/default-jvm/bin/jlink --add-modules "$(java --list-modules | sed -e 's/@[0-9].*$/,/' | tr -d \\n)" --no-man-pages --no-header-files --strip-debug --output /opt/corretto-slim && \
    apk del binutils amazon-corretto-20 && \
    mkdir -p /usr/lib/jvm/ && \
    mv /opt/corretto-slim /usr/lib/jvm/java-20-amazon-corretto && \
    ln -sfn /usr/lib/jvm/java-20-amazon-corretto /usr/lib/jvm/default-jvm

ENV LANG C.UTF-8
ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

ARG APPLICATION_USER=appuser
RUN adduser --no-create-home -u 1000 -D $APPLICATION_USER && \
    mkdir /app && \
    chown -R $APPLICATION_USER /app
USER 1000

COPY --chown=1000:1000 ./jit/sample/jdk-8281677.java /app/jdk-8281677.java
WORKDIR /app

EXPOSE 8080
ENTRYPOINT [ "/usr/lib/jvm/default-jvm/bin/java", "/app/jdk-8281677.java" ]
#ENTRYPOINT/CMD [ "/jre/bin/java", "-jar", "/app/app.jar" ]

