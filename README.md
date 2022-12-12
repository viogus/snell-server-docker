# Snell Server Docker


This image is based on Alpine Linux image, which is only a 9MB image, and contains Snell Server (**v4.0.0**).



Docker Pull Command: `docker pull ghcr.io/viogus/snell-server`

---

## Display Conf

```sh
docker exec snell-server cat /etc/snell/snell-server.conf
```

---

## Usage Example

Here is an example configuration of Docker and Docker Compse.

### Docker Run

```Docker
docker run -d --name snell-server --restart always \
-p 1002:12345 -e PSK="5G0H4qdf32mEZx32t" -e OBFS="tls" ghcr.io/viogus/snell-server-docker
```

### Compose

```docker
version: '3'
services:
  server:
    image: ghcr.io/viogus/snell-server-docker
    container_name: snell-server
    logging:
      driver: "json-file"
      options:
        max-size: "1g"
    environment:
      PSK: 5G0H4qdf32mEZx32t
      OBFS: tls
    tty: true
    restart: always
    ports:
      - 1002:12345
    volumes:
      - ./conf:/etc/snell
```
---

## Related Link

* https://github.com/surge-networks/snell
