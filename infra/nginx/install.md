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
sudo vim /usr/local/nginx/conf/nginx.conf
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

# TODO 終了前にログを無効化する
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

# TODO アプリに合わせて修正
    location ~ ^/(stylesheets|images)/ {
      open_file_cache max=100;

# TODO アプリに合わせて修正
      root /home/vagrant/isucon5-prepare/app/public;
    }
  }
}
```

# Upstartで起動する場合

```
sudo vim /etc/init/nginx.conf
```

```
# nginx

description "nginx http daemon"
author "George Shammas <georgyo@gmail.com>"

start on (filesystem and net-device-up IFACE=lo)
stop on runlevel [!2345]

env DAEMON=/usr/local/nginx/sbin/nginx
env PID=/var/run/nginx.pid

expect fork
respawn
respawn limit 10 5
#oom never

pre-start script
    $DAEMON -t
    if [ $? -ne 0 ]
        then exit $?
    fi
end script

exec $DAEMON
```

# systemdで起動する場合

```
sudo vim /lib/systemd/system/nginx.service
```

```
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network.target remote-fs.target nss-lookup.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t
ExecStart=/usr/local/nginx/sbin/nginx
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl enable nginx
sudo service nginx restart
```
