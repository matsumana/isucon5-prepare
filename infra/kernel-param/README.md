```
sudo sh -c 'cat << EOF >> /etc/sysctl.conf
net.ipv4.tcp_max_tw_buckets = 2000000
net.ipv4.ip_local_port_range = 10000 65000
net.core.somaxconn = 32768
net.core.netdev_max_backlog = 8192
net.ipv4.tcp_tw_reuse = 1
net.ipv4.tcp_tw_recycle = 1
net.ipv4.tcp_fin_timeout = 10
fs.file-max = 6815744
EOF'
```

```
sudo /sbin/sysctl -p
```

```
sudo sysctl -a | grep net.ipv4.tcp_max_tw_buckets
sudo sysctl -a | grep net.ipv4.ip_local_port_range
sudo sysctl -a | grep net.core.somaxconn
sudo sysctl -a | grep net.core.netdev_max_backlog
sudo sysctl -a | grep net.ipv4.tcp_tw_reuse
sudo sysctl -a | grep net.ipv4.tcp_tw_recycle
sudo sysctl -a | grep net.ipv4.tcp_fin_timeout
sudo sysctl -a | grep fs.file-max
```
