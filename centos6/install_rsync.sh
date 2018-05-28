#wget https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz
wget https://8min.blob.core.windows.net/file/rsync-3.1.2.tar.gz
mkdir /data/etc/rsync -p 
tar xf rsync-3.1.2.tar.gz 
cd rsync-3.1.2
./configure --prefix=/data/etc/rsync 
make && make install 
mkdir /data/etc/rsync/conf
mkdir /data/etc/rsync/data 
cat > /data/etc/rsync/conf/rsync.conf <<EFO
pid file = /var/run/rsyncd.pid
log file = /var/log/rsync.log
log format = %t %a %m %f %b
timeout = 100
use chroot = yes
read only = no
uid = root
gid = root
port=22873  
[rsyncdata]   
path=/data/etc/rsync/data/  
list=yes
ignore error
auth users = rsync   
secrets file = /data/etc/rsync/conf/.rsync_server.pw 
EFO
echo "rsync:fgaogjp213gHSDQW-adg" > /data/etc/rsync/conf/.rsync_server.pw
chmod 600 /data/etc/rsync/conf/.rsync_server.pw  
/data/etc/rsync/bin/rsync --daemon --config=/data/etc/rsync/conf/rsync.conf  
