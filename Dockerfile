FROM debian:9

ENV \
  GIT_GROUP="${GIT_GROUP:-www-data}"

RUN \
  apt-get update && \
  apt-get install -y gettext-base fcgiwrap git gitweb nginx && \
  rm -rf /var/lib/apt/lists/* && \
  echo "\ndaemon off;" >> /etc/nginx/nginx.conf && \
  chown -R www-data:www-data /var/lib/nginx && \
  mkdir -p /etc/gitweb/ && \
  cp /etc/gitweb.conf /etc/gitweb/ && \
  ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log

COPY nginx /etc/nginx/

VOLUME ["/etc/gitweb", "/etc/nginx/sites-enabled", "/var/lib/git", \
        "/var/lib/git-http"]

CMD \
  echo "FCGI_GROUP=${GIT_GROUP}" > /etc/default/fcgiwrap && \
  envsubst '$GITWEB_BASE_PATH' < /etc/nginx/default.tmpl > /etc/nginx/sites-enabled/default && \
  service fcgiwrap start && \
  exec nginx

EXPOSE 80
