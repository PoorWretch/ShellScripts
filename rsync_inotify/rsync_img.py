# coding:utf-8
"""
Doctor: youshumin
Version:1.0.0
Date:2018/04/28
Doctor: youshumin
"""
import time,os,stat
import sys
"""
Rsync_Remote_Host 远程同步主机
Rsync_User 同步使用用户
Rsync_Domain 远程同步使用域
Rsync_Pass 远程同步密码
Rsync_Port 远程同步密码
Local_Rsync_Bin 本地rsync执行文件路劲
Local_Rsync_Dir 本地同步目录
"""
Rsync_Remote_Host="10.148.0.3"
Rsync_User="rsync"
Rsync_Domain="rsyncimg"
Rsync_Pass="fgaogjp213gHSDQW-adg"
Rsync_Port=22873
Local_Rsync_Bin="/usr/bin/rsync"
Local_Rsync_Dir=sys.argv[1]

Time_Day=time.strftime("%Y%m%d",time.localtime())
Time_Hour=time.strftime("%Y%m%d%H",time.localtime())
POSSIBLE_TOPDIR=os.path.normpath(os.path.abspath(__file__))
Tmp_Pass_File="{0}_{1}.pw".format(POSSIBLE_TOPDIR,Time_Hour)
if os.path.exists(Tmp_Pass_File):
    file=open(Tmp_Pass_File,'r')
    file_contant=file.read()
    file.close()
    if Rsync_Pass==file_contant:
        pass
    else:
        Tmp_Pass_File="{0}.new".format(Tmp_Pass_File)

try:
    file=open(Tmp_Pass_File,'w')
    file.write(Rsync_Pass)
    file.close()
    os.chmod(Tmp_Pass_File,stat.S_IRUSR)
except:
    pass

Shell_Command="{0} -vzurtopg --port={1} --password-file={2} {6} {3}@{4}::{5} ".format(Local_Rsync_Bin,
                                                                         Rsync_Port,
                                                                         Tmp_Pass_File,
                                                                         Rsync_User,
                                                                         Rsync_Remote_Host,
                                                                         Rsync_Domain,
                                                                         Local_Rsync_Dir)
os.system(Shell_Command)
os.remove(Tmp_Pass_File)
