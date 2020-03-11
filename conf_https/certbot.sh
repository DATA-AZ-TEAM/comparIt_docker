certbot certonly \
  --dns-cloudflare \
  --dns-cloudflare-credentials ~/.secrets/certbot/cloudflare.ini \
  -d comparit.fr \
  -d www.comparit.fr \
  -d back.comparit.fr \
  -d analytics.comparit.fr
