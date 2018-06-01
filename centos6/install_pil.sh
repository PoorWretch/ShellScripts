#!/bin/bash 
yum install python-devel -y 
yum install -y libjpeg libjpeg-devel zlib zlib-devel freetype freetype-devel lcms lcms-devel
yum install -y python-imaging
wget wget http://effbot.org/downloads/Imaging-1.1.7.tar.gz 
tar xf Imaging-1.1.7.tar.gz
cd Imaging-1.1.7

### 
###


python setup.py install 
mv PIL PIL2 
python selftest.py

