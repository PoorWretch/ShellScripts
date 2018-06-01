#!/bin/bash
##
#同步某个文件的内容到另一台服务器上特定的文件夹,保障web服务器数据一定
#触发的时候  .log  .tmp  .aw[a-z] 结尾文件不触发
#并将同步的文件记录到日志文件
##
# eg:
# INOTIFY_EXCLUDE="/data/etc"
RSYNC_APP="tongbu1"
INOTIFY_EXCLUDE="xxxxxxx"
RSYNC_SCRIPTS="/data/etc/rsync_img.py"
RSYNC_LOG="/tmp/rsync_${RSYNC_SCRIPTS}.log"
INOTIFY_EXE="/data/etc/inotify/bin/inotifywait"

${INOTIFY_EXE} -mrq --exclude "(.log|.tmp|.sw[a-z])" --timefmt '%d-m%-%y %H:%M' --format '%w%f' -e modify,delete,create,attrib ${INOTIFY_EXCLUDE} | while read files
do
TIME=$(date +%Y%m%d%H%M%S)
python ${RSYNC_SCRIPTS} ${INOTIFY_EXCLUDE}/
echo "${TIME} ${files}" >> ${RSYNC_LOG}
done
