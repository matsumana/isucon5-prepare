```
sudo mv -i /etc/mysql{,.org}
sudo mkdir /etc/mysql
sudo vim /etc/mysql/my.cnf
```

```
[client]
port            = 3306
socket          = /var/run/mysqld/mysqld.sock
default-character-set = utf8mb4

[mysql]
no-auto-rehash

[mysqld]
datadir = /var/lib/mysql
port            = 3306
socket          = /var/run/mysqld/mysqld.sock
skip-external-locking
key_buffer_size = 32M
max_allowed_packet = 300M
table_open_cache = 256
max_connections = 1024
max_connect_errors = 10000
sort_buffer_size = 1M
read_buffer_size = 1M
myisam_sort_buffer_size = 1M
thread_cache_size = 256
query_cache_size = 0
query_cache_type = 0
thread_concurrency = 8
tmp_table_size = 64M
max_heap_table_size = 64M
skip-name-resolve
character-set-server = utf8mb4
default-storage-engine=InnoDB
transaction_isolation = REPEATABLE-READ

innodb_strict_mode
innodb_data_file_path = ibdata1:10M:autoextend
innodb_data_home_dir = /var/lib/mysql
innodb_file_format = Barracuda
innodb_file_per_table
innodb_buffer_pool_size = 1GB
innodb_additional_mem_pool_size = 20M
innodb_write_io_threads = 4
innodb_read_io_threads = 4
innodb_thread_concurrency = 8
innodb_flush_log_at_trx_commit = 0
innodb_log_file_size = 128M
innodb_log_buffer_size = 16M
innodb_log_files_in_group = 2
innodb_flush_method=O_DIRECT
innodb_lock_wait_timeout = 120
loose-innodb_large_prefix = 1
loose-innodb_print_all_deadlocks = 1
innodb_io_capacity = 200

# slow query log
slow_query_log = 1
log_queries_not_using_indexes = 1
long_query_time = 0
slow_query_log_file = /var/lib/mysql/slow_query.log

# performance schema
performance_schema = 0

[mysqldump]
quick
max_allowed_packet = 300M

[myisamchk]
key_buffer = 8M
sort_buffer_size = 8M
read_buffer = 1M
write_buffer = 0M

[mysqld_safe]
log-error=/var/lib/mysql/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
open-files-limit = 8192
```
