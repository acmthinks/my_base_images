FROM alpine:latest
RUN apk update && apk upgrade && apk add curl && apk add --update nodejs npm && mkdir -p /usr/src/app
WORKDIR /usr/src/app
RUN npm init --yes
RUN npm install express
