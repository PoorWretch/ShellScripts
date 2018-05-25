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
port=22873  #修改默认端口
[rsyncdata]   # 客户端需要的使用名字  需要同步多个就在
path=/data/etc/rsync/data/    # 同步到的目录
list=yes
ignore error
auth users = rsync   # 同步使用的用户
secrets file = /data/etc/rsync/conf/.rsync_server.pw  #同步使用的密码
EFO
echo "rsync:fgaogjp213gHSDQW-adg" > /data/etc/rsync/conf/.rsync_server.pw
chmod 600 /data/etc/rsync/conf/.rsync_server.pw  
/data/etc/rsync/bin/rsync --daemon --config=/data/etc/rsync/conf/rsync.conf  
if  $? == 0;then
    echo "Install Rsync OK!"
    echo "Rsync user: rsync"
    echo "Rsync project: rsyncdata"
    echo "Rsync port: 22873"
    echo "Rsync Passwd: rsync:fgaogjp213gHSDQW-adg"
fi

