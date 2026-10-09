# builder
FROM node:22-alpine3.24 AS builder
WORKDIR /app 
COPY app/package.json app/yarn.lock /app/
RUN yarn install 
COPY app/ .
RUN yarn build 

# runtime
FROM nginxinc/nginx-unprivileged:stable-alpine
USER root
RUN apk add --no-cache tiff=4.7.2-r0
USER nginx
WORKDIR /app
COPY --from=builder app/build /usr/share/nginx/html/
EXPOSE 8080




