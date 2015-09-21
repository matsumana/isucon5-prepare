```
sudo apt-get install zlib1g-dev libssl-dev libpcre3-dev
mkdir -p $HOME/local/src
cd $HOME/local/src
curl -O http://nginx.org/download/nginx-1.8.0.tar.gz
tar xvf nginx-1.8.0.tar.gz
cd nginx-1.8.0
./configure --with-cc-opt="-Wno-deprecated-declarations"
make
sudo make install
```

```
vim /etc/nginx/conf/nginx.conf
```

```
worker_processes  1;

events {
  worker_connections  10000;
}

http {
  log_format with_time '$remote_addr - $remote_user [$time_local] '
                       '"$request" $status $body_bytes_sent '
                       '"$http_referer" "$http_user_agent" $request_time';

#  access_log  off;
  access_log  /usr/local/nginx/logs/access.log with_time;
  error_log   /usr/local/nginx/logs/error.log;

  include     mime.types;
  sendfile    on;
  tcp_nopush  on;
  tcp_nodelay on;
  etag        off;
  upstream app {
    server unix:/dev/shm/app.sock;
  }

  server {
    location / {
      proxy_pass http://app;
    }
    location ~ ^/(stylesheets|images)/ {
      open_file_cache max=100;
      root /home/vagrant/perlapp/public;
    }
  }
}
```
