FROM rust:1.77.1-alpine3.18 as build

#
# build stage
#
WORKDIR /usr/src/mcl/
COPY . .
COPY .env.docker .env

#
#RUN apt-update && apt-get --yes install pkg-config libssl-dev \
#cargo install trunk --version 0.16.0 \
RUN apk update && apk add --upgrade "pkgconf" "openssl-dev" && \
    apk add --no-cache musl-dev && \
    wget -qO- https://github.com/trunk-rs/trunk/releases/download/v0.19.2/trunk-x86_64-unknown-linux-musl.tar.gz | tar -xzf- && \
    rustup target add wasm32-unknown-unknown && \
    rustup component add rustfmt && \
    rustup component add clippy-preview && \
    cargo install --path .

#
# deploy stage
#
#FROM gcr.io/distroless/cc-debian11 as relay
FROM alpine:3.18 as relay

ARG ARCH=aarch64

#WORKDIR /usr/src/mcl/

#COPY --from=build /usr/local/cargo/bin/mcl /usr/local/bin/mcl
COPY --from=build /usr/local/cargo/bin/client /usr/local/bin/mcl
#COPY --from=build /usr/src/mcl/.env /usr/local/bin/.env
COPY --from=build /usr/src/mcl/.env /.env


CMD ["mcl"]
#CMD ["cargo", "run"]
ENTRYPOINT [ "/bin/sh" ]

