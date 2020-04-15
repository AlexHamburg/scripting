server {
  listen               443 ssl http2;
  server_name          example.com;
  ssl_certificate      /etc/letsencrypt/live/example.com/fullchain.pem;
  ssl_certificate_key  /etc/letsencrypt/live/example.com/privkey.pem;
  include              /etc/letsencrypt/options-ssl-nginx.conf;
  ssl_dhparam          /etc/letsencrypt/ssl-dhparams.pem;
  access_log           /var/log/nginx/access_backend.example.com.log;
  location / {
    proxy_pass    http://localhost:8080/;
    include       /etc/nginx/proxy.conf;
  }
}
