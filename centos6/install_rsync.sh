#wget https://download.samba.org/pub/rsync/src/rsync-3.1.2.tar.gz
wget https://8min.blob.core.windows.net/file/rsync-3.1.2.tar.gz
mkdir /data/etc/rsync -p 
tar xf rsync-3.1.2.tar.gz 
cd rsync-3.1.2
./configure --prefix=/data/etc/rsync 
make && make install 
mkdir /data/etc/rsync/conf
