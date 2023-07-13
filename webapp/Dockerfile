#Stage 1
FROM node:16-alpine as builder
WORKDIR /app/src
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install
COPY . .
RUN yarn build

#Stage 2
FROM nginx:latest
WORKDIR /usr/share/nginx/html
RUN rm -rf ./*
COPY --from=builder /app/src/build .
ENTRYPOINT [ "nginx", "-g", "daemon off;" ]
