
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

RUN mkdir -p /app/staticfiles /app/media

RUN chown -R nginx:nginx /app && chmod -R 755 /app
