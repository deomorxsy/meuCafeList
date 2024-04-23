# This is the first stage. This image is used to compile the Rust application.
#FROM rust:bookworm as builder
FROM rust:1.77.1-alpine3.18 as builder
WORKDIR /app

COPY . .
COPY .env.docker .env
RUN apk update && apk add --upgrade "pkgconf" "openssl-dev" && \
    apk add --no-cache musl-dev && \
    wget -qO- https://github.com/trunk-rs/trunk/releases/download/v0.19.2/trunk-x86_64-unknown-linux-musl.tar.gz | tar -xzf- && \
    rustup target add wasm32-unknown-unknown && \
    rustup component add rustfmt && \
    rustup component add clippy-preview && \
    cargo install --path .
# Install the package in the current directory
CMD ["./target/release/app"]

#FROM debian:bookworm-slim
FROM alpine:3.18 as relay
#FROM rust:1.77.1-alpine3.18 as relay

#COPY --from=builder /usr/local/cargo/bin/app /usr/local/bin/app
WORKDIR /app

# will work with others, but not wasm-bindgen. Use trunk or others
COPY --from=builder /usr/local/cargo/bin/client /usr/local/bin/app
COPY --from=builder ["/app/index.html", "/app/Cargo.toml", "/app/Cargo.lock", "/app/dist/", "/app/trunk", "/app/.env", "/app/src/", "."]
COPY --from=builder /app/src/ ./src/

RUN apk add --no-cache musl-dev wasm-pack && \
    cargo update -p bumpalo@3.15.4 --precise 3.12.0 && \
    wasm-pack build --target nodejs

EXPOSE 8081

CMD ["./trunk", "serve", "--address", "0.0.0.0", "--port", "8081"]
#CMD ["wasm-pack", "build"]
#works
##./trunk serve --address 0.0.0.0 --port 8080
ENTRYPOINT ["/bin/sh"]

FROM node:21-alpine3.18

WORKDIR /app/
COPY --from=relay /app/pkg/ /app/pkg/

EXPOSE 8081

ENTRYPOINT ["/bin/sh"]
