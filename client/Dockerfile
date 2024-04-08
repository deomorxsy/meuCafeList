FROM rust:1.77.1-alpine3.19 as builder

#
# build stage
#
WORKDIR /usr/src/mcl/
COPY . .
COPY .env.docker .env

#
#RUN apt-update && apt-get --yes install pkg-config libssl-dev \
#cargo install trunk --version 0.16.0 \
RUN apk update && apk install "pkgconf>2.2.0-r0" "openssl-dev>3.2.1-r1" \
    wget -qO- https://github.com/trunk-rs/trunk/releases/download/0.17.10/trunk-x86_64-unknown-linux-gnu.tar.gz | tar -xzf- \
    rustup target add wasm32-unknown-unknown \
    rustup component add rustfmt\
    rustup component add clippy-preview \
    cargo install --path .

#
# deploy stage
#
FROM gcr.io/distroless/cc-debian11

ARG ARCH=aarch64

COPY --from=build /usr/local/cargo/bin/mcl /usr/local/bin/mcl
COPY --from=build /usr/src/mcl/.env /.env


CMD ["mcl"]


