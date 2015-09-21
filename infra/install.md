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
