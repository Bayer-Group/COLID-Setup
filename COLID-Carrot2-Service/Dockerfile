FROM node:14-alpine as build-phase

RUN apk update \
  && apk upgrade \
  && apk add --update openjdk11 tzdata curl unzip bash \
  && rm -rf /var/cache/apk/*
  
ADD carrot2-4.5.1.zip /var/lib/misc
RUN unzip /var/lib/misc/carrot2-4.5.1.zip

ENV PORT=8080
EXPOSE $PORT

WORKDIR /carrot2-4.5.1/dcs
RUN chmod +x dcs
CMD ./dcs

