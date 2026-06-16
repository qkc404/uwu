FROM teddysun/xray:latest AS xray-bin
FROM openresty/openresty:alpine

COPY --from=xray-bin /usr/local/bin/xray /usr/local/bin/xray
COPY trojan-go-config.json /etc/xray/config.json
COPY nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
COPY index.html /usr/share/nginx/html/index.html   # ADD THIS LINE
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

CMD ["/entrypoint.sh"]
