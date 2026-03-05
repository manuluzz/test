FROM alpine:3.19 AS builder

#cria uma variável que aceita um link externo
ARG DOWNLOAD_URL="https://wltech.com.br/wp-content/uploads/2019/03/Docker.png"

RUN apk add --no-cache curl

WORKDIR /app

#salva a imagem que vem da url descrita no arquivo "imagem.jpg"
RUN curl -fSL "${DOWNLOAD_URL}" -o imagem.jpg

#imagem final
FROM nginx:alpine3.19

RUN apk add --no-cache curl && \
    rm -rf /usr/share/nginx/html/*

COPY --from=builder /app/imagem.jpg /usr/share/nginx/html/

COPY index.html /usr/share/nginx/html/index.html

HEALTHCHECK --interval=30s --timeout=3s \
  CMD curl -f http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]