FROM debian:bookworm

EXPOSE 443

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx openssl ca-certificates \
 && rm -rf /var/lib/apt/lists/*

ARG CERT_FOLDER=/etc/nginx/certs/
ARG CERTIFICATE=/etc/nginx/certs/certificate.crt
ARG KEY_PATH=/etc/nginx/certs/certificate.key
ARG COUNTRY=BR
ARG STATE=BA
ARG LOCALITY=Salvador
ARG ORGANIZATION=42
ARG UNIT=42
ARG COMMON_NAME=mavissar.42.fr

RUN mkdir -p "${CERT_FOLDER}" && \
    openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
      -out "${CERTIFICATE}" \
      -keyout "${KEY_PATH}" \
      -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${UNIT}/CN=${COMMON_NAME}"

COPY conf/nginx.conf /etc/nginx/
COPY conf/server.conf /etc/nginx/conf.d/

RUN mkdir -p /var/www/ && chown -R www-data:www-data /var/www/

CMD ["nginx", "-g", "daemon off;"]