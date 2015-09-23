```
sudo apt-get install libevent-dev libperl-dev
mkdir -p $HOME/local/src
cd $HOME/local/src
curl -O http://www.memcached.org/files/memcached-1.4.24.tar.gz
tar xvf memcached-1.4.24.tar.gz
cd memcached-1.4.24
./configure --prefix=/usr/local/memcached
make
sudo make install
```

```
sudo vim /etc/init/memcached.conf
```

```
description "memcached"

env MEMCACHED=/usr/local/memcached/bin/memcached

start on runlevel [2345]
stop on runlevel [!2345]

pre-start script
  test -x $MEMCACHED || { stop; exit 0; }
end script

respawn
exec $MEMCACHED -d -p 11211 -U 0 -u nobody -m 256 -c 200000 -v -t 1 -C -B ascii
```

# supervisorで起動する場合

```
sudo apt-get install supervisor
sudo touch /etc/supervisor/conf.d/memcached.conf
sudo vim /etc/supervisor/conf.d/memcached.conf
```

```
[program:memcahed]
directory=/
command=/usr/local/memcached/bin/memcached -p 11211 -U 0 -u nobody -m 256 -c 200000 -v -t 1 -C -B ascii
autostart = true
```

```
sudo service supervisor restart
```
