#!/usr/bin/python
#coding:utf-8

'''
@author: youshumin

@contact: ysm0119@126.com

@file: xtrabackup.py

@time: 2018/5/21 下午7:59

@desc:

'''


###
backup_log_file="/data/mysql_bak/one/backup.log"
xtrabackup_sbin="/data/etc/percona/bin/innobackupex"
xtrabackup_cnf="/data/etc/mysql5.7.21/.mysql/one/one.cnf"
# xtrabackup_user="root"
# xtrabackup_passwd=""
xtrabackup_user="icoadmin"
xtrabackup_passwd="8a28-861f106f630c"
xtrabackup_sock="/data/etc/mysql5.7.21/.mysql/one/newsock"
xtrabackup_bakdir="/data/mysql_bak/one"
xtrabackup_bakday=10
xtrabackup_maxsize=200
xtrabackup_index="mysql"
###

pub_key="""
-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.14 (GNU/Linux)

mQENBFsCmKwBCADE8JFDOg5nedHEOcvk6wdzKcsjLlasbHFUgbA1zEy/My8l15wP
r6e5Oy5OCTQrWMiZnoUvgGxpOawyQK4kcQUn9OYPlIv84wf4X3NoHkxKujiAa+8U
LMxV+c1TEhGWPYQO4rVj/CCjXSkSx8Z7PBin4vaYtgXVJtSJt1hERC0XuheMlNcg
UF4x3q+hWm2OYr8Ye40+4wrUrwDjw0Q8dO2aIzlxe6SY/fO3BZgVFiF6MfMwkhJ6
41w6eSlX6uDvBJcnqOadInQA/IW9DhN8IlVrxpGUlKcmYZH8mEyXwMBz/uLZDksM
wcwrSpWGtCKemNULh7Xutz2zhn8Ku/+4ptDpABEBAAG0IHl1bmV4aW8gKEdvZCkg
PHNlcnZpY2VAeXVuZXguaW8+iQE9BBMBAgAoBQJbApisAhsDBQkB4TOABgsJCAcD
AgYVCAIJCgsEFgIDAQIeAQIXgAAKCRCIdGe3/SfLJ5SZB/YwMSJiVjzeeMHhRBlV
ZaGt160lVl615hZaZCu4BPCB06LHdAe8BNP9nG78PFzJwrMbz2l1CyFdGEItRnjK
OpaThhfLXy2FvVkn7CsR1b56/OHjpYMemHA/vzbcX5xIbvSFYRKtNw0Afx37v/oK
l/tWSKcP8dwCbyrma2vfzg8WIxFmFre6rTyK2H77zMdMcT+BTcqLjlp93wVSDH5M
bQtVTTcOJAcGMQy+QZxP4Ox5c90IcoYmkuflMpbclfujaS2eMY6B0LYnuiFawwj4
pHmNjUCCfbLuoYtVNf/BRUSEAlzm6IfoAhNHN1Iy598npW6dqoSnqB+JTQABIwcT
v+i5AQ0EWwKYrAEIAKG97oc8hySgT0oM3kwwWeCP3RtaMvOV7bInCeMAoJB9Uh/q
tjmX1QEoWI2fUYB7yx2XpkNpVbnGBa+FhQynRvarWGlXi3y8cp+w8SJQdWa+PRIq
Jt5PaniXjW3Bln6Ztqy0Dh2rwlggcU86dirgp55m1+M19LPzW7fNX083v3/vrEq0
vUVFHv+74wxnB/9jJWtQdfnKTVTifw7kGyO2nvWjMtX7sj+HWyYMJgwPxdkine8V
QmbuyMJ6bqCwcs4CEGFWi99Ig1I+sFn6PifoQpG7Xc1nWo+PRUQuqXTWPZG+SFrG
looWt1GVG/il9udkLzZxbYjrpZJ7TupBPE8Rez8AEQEAAYkBJQQYAQIADwUCWwKY
rAIbDAUJAeEzgAAKCRCIdGe3/SfLJzDTCACvLBuAmMT9olVxMIfwhBDSHI3wX/T5
rm9PExtHl1qDkwih67FMUl1Sjmoz4QatbnNbPchZm3QAC12Pg15QkhU62DkDijTj
HNG8uhY1geKWQICWsd8h1xF3l3/IvEn8+y1SMA+K8HdtBsO7ELXmFocoSGGr3zqm
dV+LmWonkrYtkdAemWW4g7HLd6GYoiZGRfCIR1YFPhXBErjJpxQE7YYW73XC7949
xhM1GQpbiOjPM4vE8sGRtmFeuyhfAztxzfPfqJkzSoJZ6d/QB1OMOrX8Y7DqBKGC
OflBW8LX8c1rMoLh/8A/DRhxt6pYVpH/Bo/7CXVHw/f38fr/n5trwxAd
=3n3n
-----END PGP PUBLIC KEY BLOCK-----
"""

import os,time,shutil,tarfile,datetime
Time_Day=time.strftime("%Y%m%d",time.localtime())


def Bak_Full_Mysql(sbin,cnf,user,passwd,sock,backup_path,file_name):
    xtrabackup_bakdir=os.path.normpath(os.path.abspath(backup_path))
    Tmp_Work=os.path.normpath(os.path.join(xtrabackup_bakdir
                                           ,Time_Day))
    if not os.path.exists(Tmp_Work):
        os.mkdir(Tmp_Work)
    cmd="{0} --defaults-file={1} --user={2} --password={3} --socket={4} --no-timestamp {5}".format(sbin,cnf,user,passwd,sock,Tmp_Work)
    import commands
    bak_result=commands.getstatusoutput(cmd)[0]
    if bak_result == 0:
        with open(backup_log_file,'a+') as logfile:
            logfile.write("{0} backup mysql ok\n".format(time.strftime("%Y%m%d%H%M%S",time.localtime())))
            logfile.close()
    else:
        with open(backup_log_file,"a+") as logfile:
            logfile.write("{0} backup mysql error!!\n".format(time.strftime("%Y%m%d%H%M%S",time.localtime())))
            logfile.close()
    Tar_Log_File(Tmp_Work,backup_path,file_name)

def Tar_Log_File(log_path,tar_path,file_name):
    backup_path_file=os.path.normpath(os.path.join(tar_path,
                                               "{1}_{0}.tar.gz".format(Time_Day,file_name)))
    Tar=tarfile.open(backup_path_file,"w:gz")
    Tar.add(log_path,arcname=os.path.basename(log_path))
    Tar.close()
    shutil.rmtree(log_path)
    gpg_encrypt(backup_path_file)

def gpg_encrypt(gpgfile):
    pub_key_file=os.path.normpath(os.path.join(
        os.path.abspath(gpgfile),
        "../",
        "pub.key"
    ))
    if not os.path.exists(pub_key_file):
        with open(pub_key_file,"a+") as f:
            f.write(pub_key)
            f.close()
    cmd="gpg --import {0}".format(pub_key_file)
    import commands
    gpg_inport_result=commands.getstatusoutput(cmd)[0]
    os.remove(pub_key_file)
    cmd="gpg -e --always-trust -r yunexio {0}".format(gpgfile)
    bak_result=commands.getstatusoutput(cmd)[0]
    if bak_result == 0:
        with open(backup_log_file,"a+") as logfile:
            logfile.write("{0} gpg ok!!\n".format(time.strftime("%Y%m%d%H%M%S",time.localtime())))
            logfile.close()
        os.remove(gpgfile)
    else:
        with open(backup_log_file,"a+") as logfile:
            logfile.write("{0} gpg error!!\n".format(time.strftime("%Y%m%d%H%M%S",time.localtime())))
            logfile.close()
    shutil.rmtree("/root/.gnupg")

if __name__ == "__main__":
    Bak_Full_Mysql(xtrabackup_sbin,xtrabackup_cnf,xtrabackup_user,xtrabackup_passwd,xtrabackup_sock,xtrabackup_bakdir,xtrabackup_index)

