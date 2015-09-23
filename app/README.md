# 依存モジュール インストール

```
sudo apt-get install libmysqld-dev
~/local/perl-5.22/bin/carton install
```

# アプリ起動

## Gazelle

```
~/local/perl-5.22/bin/carton exec start_server --path /tmp/app.sock --backlog 16384 -- plackup -s Gazelle --max-workers=4 --max-reqs-per-child 500000 --min-reqs-per-child 400000 -E production -a app.psgi
```

## Starlet

```
~/local/perl-5.22/bin/carton exec start_server --path /tmp/app.sock --backlog 16384 -- plackup -s Starlet --workers=4 --max-reqs-per-child 500000 --min-reqs-per-child 400000 -E production -a app.psgi
```

# supervisorで起動する場合

```
sudo touch /etc/supervisor/conf.d/isucon_perl.conf
sudo vim /etc/supervisor/conf.d/isucon_perl.conf
```

```
[program:isucon_perl]
; パスは適宜修正
directory=/home/vagrant/isucon5-prepare/app
command=/home/vagrant/local/perl-5.22/bin/carton exec start_server --path /tmp/app.sock --backlog 16384 -- plackup -s Gazelle --max-workers=4 --max-reqs-per-child 500000 --min-reqs-per-child 400000 -E production -a app.psgi
user=vagrant
stdout_logfile=/tmp/isucon.perl.log
stderr_logfile=/tmp/isucon.perl.log
autostart=true
```

```
sudo service supervisor restart
sudo supervisorctl restart isucon_perl
```
