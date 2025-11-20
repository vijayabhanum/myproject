FROM nginx:alpine

RUN rm /etc/nginx/conf.d/defaults.conf

COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf

COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /app/static /app/media

RUN chown -R nginx:nginx /app

EXPOSE 80 443

HEALTHCHECK --interval=30s --timeout=3s \
  CMD wget --quiet --tries=1 --spider http://localhost/health/ || exit 1

CMD ["nginx", "-g", "daemon off;"]
