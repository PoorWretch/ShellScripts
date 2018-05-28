#!/bin/bash 
yum -y install numactl.x86_64
yum -y install libaio-devel  
cd /data/
mkdir /data/etc/
wget https://8min.blob.core.windows.net/file/mysql_5.7.21.glibc2.12.tar.gz 
tar xf  mysql_5.7.21.glibc2.12.tar.gz 
mv mysql-5.7.21-linux-glibc2.12-x86_64 etc/mysql5.7.21
groupadd mysql
useradd -s /sbin/nologin -M -g mysql mysql
mkdir /data/mysql/one/
/data/etc/mysql5.7.21/bin/mysqld --initialize-insecure --basedir=/data/etc/mysql5.7.21 --datadir=/data/mysql/one  --user=mysql

mkdir  -p /data/etc/mysql5.7.21/.mysql/one 
cat >> /data/etc/mysql5.7.21./.mysql/one/one.cnf <<EFO 
[client]
#password   = your_password
port        = 13349
socket      = /data/etc/mysql5.7.21/.mysql/one/newsock

[mysqld]
port        = 13349
socket      = /data/etc/mysql5.7.21/.mysql/one/newsock
datadir = /data/mysql/one
slave-skip-errors = 1032,1062,1007,1050
skip-external-locking
key_buffer_size = 512M
max_allowed_packet = 16M
table_open_cache = 2048
sort_buffer_size = 8M
log_slave_updates=1
net_buffer_length = 8K
read_buffer_size = 8M
read_rnd_buffer_size = 512K
myisam_sort_buffer_size = 128M
thread_cache_size = 256
query_cache_size = 256M
tmp_table_size = 256M
performance_schema_max_table_instances = 500
character-set-server = utf8
init_connect='SET NAMES utf8'
explicit_defaults_for_timestamp = true
#skip-neonerking
max_connections = 10000
max_connect_errors = 100000
open_files_limit = 65535
log-bin=mysql-bin
binlog_format=row
server-id   = 456
expire_logs_days = 30
early-plugin-load = ""
default_storage_engine = InnoDB
innodb_file_per_table = 1
innodb_data_home_dir = /data/mysql/one
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = /data/mysql/one
innodb_buffer_pool_size = 2048M
innodb_log_file_size = 512M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 2
innodb_lock_wait_timeout = 50
log_error = /data/logs/mysql_one/newerr.log
pid_file = /data/etc/mysql5.7.21/.mysql/one/newpid
slow_query_log = 1
slow_query_log_file = /data/logs/mysql/one/newslow.log
long_query_time = 1
binlog-ignore-db=mysql
binlog-ignore-db=information_schema
binlog-ignore-db=performance_schema
replicate-ignore-db = mysql
replicate-ignore-db = information_schema
replicate-ignore-db = performance_schema
replicate-ignore-db = sys
bind-address=data1
auto_increment_increment = 3
auto_increment_offset = 3
innodb_read_io_threads = 8
innodb_write_io_threads = 8
[mysqldump]
quick
max_allowed_packet = 16M

[mysql]
no-auto-rehash

[myisamchk]
key_buffer_size = 512M
sort_buffer_size = 8M
read_buffer = 2M
write_buffer = 2M

[mysqlhotcopy]
interactive-timeout
EFO 

