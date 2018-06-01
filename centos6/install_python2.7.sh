#!/usr/bin/env bash
cd /usr/local/src
yum install -y zlib-devel bzip2 bzip2-devel readline-devel sqlite sqlite-devel openssl-devel xz xz-devel
mkdir install_python2.7
cd install_python2.7
wget https://8min.blob.core.windows.net/file/Python-2.7.14.tgz
#wget https://www.python.org/ftp/python/2.7.14/Python-2.7.14.tgz
tar xf Python-2.7.14.tgz
cd Python-2.7.14
./configure --prefix=/usr/local/python27
make -j2 && make install
mv /usr/bin/python /usr/bin/python_old
ln -s /usr/local/python27/bin/python /usr/bin/python
sed -i 's/\/usr\/bin\/python/\/usr\/bin\/python_old/' /usr/bin/yum
echo "export PATH=/usr/local/python27/bin:$PATH" >> /etc/profile
source /etc/profile
cd /usr/local/src/ && wget https://bootstrap.pypa.io/get-pip.py && /usr/local/python27/bin/python get-pip.py
ln -s /usr/local/python27/bin/pip /usr/bin/
