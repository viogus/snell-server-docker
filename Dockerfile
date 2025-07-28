FROM --platform=$BUILDPLATFORM tonistiigi/xx:latest AS xx

FROM --platform=$BUILDPLATFORM frolvlad/alpine-glibc:alpine-3.16 AS build


ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG SNELL_SERVER_VERSION=5.0.0

COPY --from=xx / /
RUN xx-info env 
RUN case "${TARGETPLATFORM}" in \
    "linux/amd64") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-amd64.zip" ;; \
    "linux/arm64") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-aarch64.zip" ;; \
    "linux/arm/v7") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-armv7l.zip" ;; \
    "linux/386") wget --no-check-certificate -O snell.zip "https://dl.nssurge.com/snell/snell-server-v${SNELL_SERVER_VERSION}-linux-i386.zip" ;; \
    *) echo "unsupported platform: ${TARGETPLATFORM}"; exit 1 ;; \
    esac
RUN if [ -f snell.zip ]; then unzip snell.zip && rm -f snell.zip; fi 


FROM frolvlad/alpine-glibc:alpine-3.16

WORKDIR /app/
COPY --from=build /snell-server /app/snell-server
COPY entrypoint.sh /app/


RUN chmod +x /app/snell-server && \
    chmod +x /app/entrypoint.sh

ENV LANG=C.UTF-8
ENV TZ=Asia/Shanghai
ENV PORT=6180
ENV IPV6=false
ENV PSK=

LABEL version="${SNELL_SERVER_VERSION}"

ENTRYPOINT ["/app/entrypoint.sh"]
