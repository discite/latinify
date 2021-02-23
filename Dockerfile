FROM ekidd/rust-musl-builder:stable as builder

RUN USER=root cargo new --bin latinify
WORKDIR /latinify/
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release
RUN rm src/*.rs


ADD . ./

RUN rm ./target/x86_64-unknown-linux-musl/release/deps/latinify*
RUN cargo build --release



FROM alpine:latest
ARG APP=/usr/src/app

EXPOSE 8000

ENV TZ=Etc/UTC \
    APP_USER=appuser

RUN addgroup -S $APP_USER \
    && adduser -S -g $APP_USER $APP_USER

RUN apk update \
    && apk add --no-cache ca-certificates tzdata \
    && rm -rf /var/cache/apk/*

COPY --from=builder /home/rust/src/rust-docker-web/target/x86_64-unknown-linux-musl/release/latinify ${APP}/latinify

RUN chown -R $APP_USER:$APP_USER ${APP}

USER $APP_USER
WORKDIR ${APP}

CMD ["./latinify"]