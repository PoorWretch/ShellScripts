#!/usr/bin/env python 
# -*- coding:utf-8 -*-

"""
纯文本文件发送
"""
import sys
import smtplib
from email.header import Header
from email.mime.text import MIMEText 
from abc import abstractmethod

class  Mail(object):
    """dohost, user_name, pwd, context, Subject, To, filename, file_path, port, nick_name, mail_adressring for  Mail"""
#   def __init__(self, host, user_name, pwd, context, Subject, To, filename, file_path, port, nick_name, mail_adress):
    def __init__(self, host, user_name, pwd, context, Subject, To, port, nick_name, mail_adress):
        """
        :param host: 邮件服务器地址
        :param user_name: 邮件登陆名
        :param pwd: 邮箱登陆密码
        :param context: 邮箱正文
        :param Subject: 邮箱主题
        :param To: 收件人
        :param From: 发件人
        """
        self.host=host
        self.user_name=user_name
        self.pwd=pwd
        self.context=context
        self.Subject=Subject
        self.To=To
#       self.filename=filename
#       self.file_path=file_path
        self.port=port
        self.nick_name=nick_name
        self.mail_adress=mail_adress
    
    @abstractmethod
    def send(self,**kwargs):
        """
        send mail to account 
        :param file:
        :return:
        """
        pass

class TextMail(Mail):
    """
    只有文本信息的邮件
    """
    def __init__(self,**kwargs):
        super(TextMail,self).__init__(**kwargs)
        self.mail_type='TEXT'

    @abstractmethod
    def send(self):
        #print("send_start")
        server=smtplib.SMTP(self.host,self.port)
        server.set_debuglevel(0)
        server.login(self.user_name,self.pwd)
        msg=MIMEText(self.context,'html','utf-8')
        msg['From']='{0}<{1}>'.format(self.nick_name,self.mail_adress,'utf-8')

        #主题要注意不能乱写，不然会被垃圾邮件
        msg['Subject']=Header(self.Subject,'utf-8').encode()
        msg['To']=','.join(self.To)
        try:
            server.sendmail(self.mail_adress,self.To,msg.as_string())
            print("mail has been successfully")
        except smtplib.SMTPException as e:
            print('邮件发送失败')
            print(e)

def send_mail(fromstmp,fromuser,frompwd,content,subject,touser):
    host=fromstmp
    fromuser=fromuser
    pwd=frompwd
    scontent=content
    subject=subject
    touser=touser
    nick_name="运维监控"
    b=TextMail(host=host,user_name=fromuser,pwd=pwd,context=content,Subject=subject,To=touser,port=25,nick_name=nick_name,mail_adress=fromuser)
    b.send()

if __name__ == '__main__':
    """
    设置发送邮箱信息
    """
    fromuser="xxx"
    frompwd="xxxx"
    fromstmp="smtp.qiye.163.com"
    touser = [str(sys.argv[1])]  #zabbix传过来的第一个参数
    subject = str(sys.argv[2])  #zabbix传过来的第二个参数
    content = str(sys.argv[3])  #zabbix传过来的第三个参数
    touser='xxx@126.com','xxx@126.com'
    send_mail(fromstmp,fromuser,frompwd,content,subject,touser)
