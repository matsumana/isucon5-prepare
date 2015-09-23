```
sudo apt-get install zlib1g-dev libssl-dev libpcre3-dev
mkdir -p $HOME/local/src
cd $HOME/local/src
curl -L -O http://nginx.org/download/nginx-1.8.0.tar.gz
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

worker_rlimit_nofile 40000;

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
    server unix:/tmp/app.sock;
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
# Stop dance for nginx
# =======================
#
# ExecStop sends SIGSTOP (graceful stop) to the nginx process.
# If, after 5s (--retry QUIT/5) nginx is still running, systemd takes control
# and sends SIGTERM (fast shutdown) to the main process.
# After another 5s (TimeoutStopSec=5), and if nginx is alive, systemd sends
# SIGKILL to all the remaining processes in the process group (KillMode=mixed).
#
# nginx signals reference doc:
# http://nginx.org/en/docs/control.html
#
[Unit]
Description=A high performance web server and a reverse proxy server
After=network.target

[Service]
Type=forking
PIDFile=/usr/local/nginx/logs/nginx.pid
ExecStartPre=/usr/local/nginx/sbin/nginx -t -q -g 'daemon on; master_process on;'
ExecStart=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;'
ExecReload=/usr/local/nginx/sbin/nginx -g 'daemon on; master_process on;' -s reload
ExecStop=/bin/kill -s QUIT `cat /usr/local/nginx/logs/nginx.pid`
TimeoutStopSec=5
KillMode=mixed

[Install]
WantedBy=multi-user.target
```

```
sudo systemctl daemon-reload
sudo systemctl enable nginx
sudo systemctl restart nginx
```
