#!/bin/bash 
yum install -y gcc cmake gcc-c++ tree lrzsz vim openssl ntpdate sysstat lsof nload wget chrony unzip
rm -f /etc/localtime
cp -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

cat > /etc/sysconfig/i18n <<EFO
LANG="en_US.UTF-8"
EFO

sed -i 's/^id:5:/id:3:/' /etc/inittab

LANG=en_US-UTF-8 
# for sun in `chkconfig --list|grep 3:on|awk '{print $1}'`;do chkconfig --level 3 $sun off;done
# for sun in crond rsyslog sshd network;do chkconfig --level 3 $sun on;done

echo "ulimit -SHn 102400" >> /etc/rc.local
cat >> /etc/security/limits.conf <<EFO
* soft nofile 102400 
* hard nofile 102400
* soft nproc 102400
* hard nproc 102400
EFO

echo "syntax on" >> /root/.vimrc
echo "set nu" >> /root/.vimrc
echo "set ts=4" >> /root/.vimrc

sed -i 's#exec /sbin/shutdown -r now#\#exec /sbin/shutdown -r now#' /etc/init/control-alt-delete.conf   
sed -i 's/SELINUX=enforcing/SELINUX=disabled/'  /etc/selinux/config
cat > /etc/modprobe.d/ipv6.conf << EOFI
alias net-pf-10 off
options ipv6 disable=1
EOFI

modprobe ip_conntrack
echo "modprobe ip_conntrack" >> /etc/rc.local
cp /etc/sysctl.conf{,_bak$(date +%Y%m%d)}
cat > /etc/sysctl.conf << EOF
net.ipv4.ip_forward = 0
net.ipv4.conf.default.rp_filter = 1
net.ipv4.conf.default.accept_source_route = 0
kernel.sysrq = 0
kernel.core_uses_pid = 1
kernel.msgmnb = 65536
kernel.msgmax = 65536
kernel.shmmax = 68719476736
kernel.shmall = 4294967296
net.ipv4.tcp_max_tw_buckets = 60000
net.ipv4.tcp_sack = 1
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_rmem = 4096 87380 4194304
net.ipv4.tcp_wmem = 4096 16384 4194304
net.core.wmem_default = 8388608
net.core.rmem_default = 8388608
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.netdev_max_backlog = 500000
net.core.somaxconn = 262144
net.ipv4.tcp_max_orphans = 3276800
net.ipv4.tcp_syncookies = 1
net.ipv4.tcp_max_syn_backlog = 262144
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_synack_retries = 1
net.ipv4.tcp_syn_retries = 1
net.ipv4.tcp_tw_recycle = 0
net.ipv4.tcp_tw_reuse = 0
net.ipv4.tcp_mem = 94500000 915000000 927000000
net.ipv4.tcp_fin_timeout = 1
net.ipv4.tcp_keepalive_time = 1200
net.ipv4.ip_local_port_range = 1024 65535
net.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_max = 25000000
net.netfilter.nf_conntrack_tcp_timeout_established = 180
net.netfilter.nf_conntrack_tcp_timeout_time_wait = 120
net.netfilter.nf_conntrack_tcp_timeout_close_wait = 60
net.netfilter.nf_conntrack_tcp_timeout_fin_wait = 120
vm.swappiness = 0
EOF
/sbin/sysctl -p
