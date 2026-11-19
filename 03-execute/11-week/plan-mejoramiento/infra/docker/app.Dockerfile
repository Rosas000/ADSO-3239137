# Aplicacion React: build con Node 22 y servido estatico con Nginx.
FROM node:22-alpine AS build
WORKDIR /build
COPY app/package.json ./
RUN npm install
COPY app/ ./
RUN npm run build

FROM nginx:alpine
COPY --from=build /build/dist /usr/share/nginx/html
COPY infra/nginx/app.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
