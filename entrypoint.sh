#!/bin/sh
set -e

echo "[$(date)] Starting Xray..."
/usr/local/bin/xray run -c /etc/xray.json 2>&1 &

echo "[$(date)] Waiting for Xray to initialize..."

for port in 10000 10001 10002 10003 10004 10005 10006 10007; do
    echo "Waiting for port $port..."
    while ! nc -z 127.0.0.1 $port 2>/dev/null; do
        sleep 1
    done
    echo "Port $port ready"
done

echo "[$(date)] All ports ready. Starting OpenResty..."
exec /usr/local/openresty/bin/openresty -g 'daemon off;'
