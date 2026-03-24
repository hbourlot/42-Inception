#!/bin/sh

set -eu

CERT_DIR="/etc/nginx/certs"
CERT_KEY="$CERT_DIR/inception.key"
CERT_CRT="$CERT_DIR/inception.crt"

mkdir -p "$CERT_DIR"

if [ ! -f "$CERT_KEY" ] || [ ! -f "$CERT_CRT" ]; then
	
	echo "Creating TLS certificate and key..."
	
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout "$CERT_KEY" \
		-out "$CERT_CRT" \
		-subj "/CN=localhost"
	chmod 600 "$CERT_KEY"
	chmod 644 "$CERT_CRT"

fi


exec nginx -g "daemon off;" # Making program as PID1

