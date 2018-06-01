#!/bin/bash 
cd /usr/local/src 
wget https://8min.blob.core.windows.net/file/inotify-tools-3.13.tar.gz 
mkdir /data/etc/inotify -p 
tar xf inotify-tools-3.13.tar.gz 
cd inotify-tools-3.13  && ./configure  --prefix=/data/etc/inotify && make  && make install 
mkdir /data/etc/inotify/scripts -p 

