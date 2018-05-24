#coding:utf-8

'''
Version: 1.0.0
Actor:youshumin
Date:2018/04/28
脚本需求--
  1.用户提供一个nginx日志路径 (目录)
  2.用户提供nginxnginx执行路径
  3.备份日志路径
  4.保留多久的存储日志文件或者空间 天和GB为单位
'''
#######
Nginx_Log_Dir="/data/logs/nginx"
Nginx_Pid_File="/data/etc/nginx/sbin/nginx"
Nginx_Bak_Dir="/data/logs/nginx_bak/"
Nginx_Bak_Day=30
Nginx_Bak_Max_Size=100
#######


import os,time,shutil
import tarfile,datetime
TIME_Secs=time.strftime("%Y%m%d%H%M%S",
                        time.localtime())
Time_Day=time.strftime("%Y%m%d",time.localtime())
POSSIBLE_TOPDIR=os.path.normpath(os.path.abspath(Nginx_Log_Dir))
Tmp_Work_File=os.path.normpath(os.path.join(POSSIBLE_TOPDIR,
                                            TIME_Secs))

## 移动nginx日志文件
def MvLog(Sour_Dir,Desc_dir):
    Need_Mv_File_List=os.listdir(Sour_Dir)
    os.mkdir(Desc_dir)
    for item in Need_Mv_File_List:
        shutil.move(os.path.join(Sour_Dir,item),
                    Desc_dir)

## 重新加载nginx日志文件
def ReloadNginxLog(Nginx_Sbin):
    Shell_Command="{0} -s reopen".format(Nginx_Sbin)
    if os.system(Shell_Command)==0:
        print "nginx 日志已经重新加载"

## 打包日志文件
def Tar_Log_File(Log_Path,Tar_Dir):
    Tar_Bak_Name=os.path.normpath(os.path.join(Tar_Dir,
                                               "web1_{0}.tar.gz".format(Time_Day)))
    Tar=tarfile.open(Tar_Bak_Name,"w:gz")
    Tar.add(Log_Path,arcname=os.path.basename(Log_Path))
    Tar.close()
    shutil.rmtree(Log_Path)

## 删除当前文件中最早创建的文件或检查最早创建的距离今天多久了
def Del_One_Old_File(Del_File_Dir,Check_Day=None):
    for root, dirs, files in os.walk(Del_File_Dir):
        files.sort(key=lambda fn: os.path.getctime(os.path.join(root, fn)))
    if Check_Day==True:
        OLd_File_Time_Day=datetime.datetime.fromtimestamp(os.path.getctime(os.path.join(root,
                                                                                        files[0]))).strftime("%Y%m%d")
        Time_Now=time.strftime("%Y%m%d",time.localtime())
        S_Day=int(Time_Now)-int(OLd_File_Time_Day)
        return S_Day
    else:
        os.remove(os.path.normpath(os.path.join(root,files[0])))

## 检测备份目录是都需要进行删除文件
def Check_Ture_Or_Flase(Nginx_Bak_Dir,Bak_Days,Bak_Size):
    Nginx_Bak_Dir = os.path.normpath(Nginx_Bak_Dir)
    Size = 0
    for root, dirs, files in os.walk(Nginx_Bak_Dir):
        Size += sum([os.path.getsize(os.path.join(root, name)) for name in files])
    Mb_Size = '%.2f' % float(Size / 1024.0 / 1024.0)
    Mb_Max_Bak_Size = '%.2f' % float(Bak_Size * 1024)
    Flat = Del_One_Old_File(Nginx_Bak_Dir, True) > Bak_Days or float(Mb_Size) > float(Mb_Max_Bak_Size)
    return Flat

## 删除文件入口
def Check_Bak_Dir(Nginx_Bak_Dir,Bak_Days,Bak_Size):
    Flat=Check_Ture_Or_Flase(Nginx_Bak_Dir,Bak_Days,Bak_Size)
    while Flat:
        Del_One_Old_File(Nginx_Bak_Dir)
        Flat = Check_Ture_Or_Flase(Nginx_Bak_Dir, Bak_Days, Bak_Size)
        if Flat==False:
            break


if __name__=="__main__":
    """
    MvLog 移动当前文件
    ReloadNginxLog 从新加载nginx日志
    Tar_Log_File 打包日志文件
    Check_Bak_Dir 检查日志备份目录，是否需要删除备份日志
    """
    MvLog(POSSIBLE_TOPDIR,Tmp_Work_File)
    ReloadNginxLog(Nginx_Pid_File)
    Tar_Log_File(Tmp_Work_File,Nginx_Bak_Dir)
    Check_Bak_Dir(Nginx_Bak_Dir,Nginx_Bak_Day,Nginx_Bak_Max_Size)
