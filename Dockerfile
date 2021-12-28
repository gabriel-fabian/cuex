FROM elixir:1.13.1-alpine

RUN apk update && \
    apk add \
    build-base