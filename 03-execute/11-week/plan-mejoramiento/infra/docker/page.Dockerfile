# Sitio publico estatico. Contexto de construccion: raiz de plan-mejoramiento.
FROM nginx:alpine
COPY page/ /usr/share/nginx/html/
COPY infra/nginx/page.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
