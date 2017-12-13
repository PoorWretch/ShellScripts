#!/bin/bash
## -------------------------------------------------------------------------------
# Script_name: check_app_mem.sh 
# Revision:    1.0.0
# Date:        2017/08/29
# Author:      youshumin
# --------------------------------------------------------------------------------
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
# set -x 
while getopts ":ap:s:c:g:h:" opt
do 
	case ${opt} in
	p)
	App_Name=${OPTARG} 
	;;
	s)
	num=${OPTARG}
	;;
	c)
	Check_Class=${OPTARG}
	;;
	a)
	continue
	;;
	*)
	echo "Usage: args [-a] [-p val] [-s val] [-c val]"
	echo "-a: means check all running app swap and mem size."
	echo "-p pid_num: means check the pid app swap and mem size."
	echo "-s num: means result sort num."
	echo "-c swap|mem: means check swap or mem."
	;;
esac
done
Script_name=$(basename "$0")
check_swap_size(){
	i=1
	if [ ! -n "${App_Name}" ];then
		App_Name=$(ls -l /proc | grep ^d | awk '{print $9}' | grep -v [^0-9])
	fi
	for Swap_Pid in ${App_Name};
	do
		if [ ${Swap_Pid} -eq 1 ];then
			continue;
		fi
		grep -q "Swap" /proc/${Swap_Pid}/smaps 2> /dev/null
		if [ $? -eq 0 ];then 
			Swap_Size=$(grep "Swap" /proc/${Swap_Pid}/smaps | gawk '{ sum+=$2;} END{print sum}')
			Swap_Size=${Swap_Size:=0}
			Swap_Proc_Name=$(ps aux | grep -w "${Swap_Pid}" | egrep -v "grep|${Script_name}" | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
		else
			continue
		fi
		PID[${i}]=${Swap_Pid}
		SIZE[${i}]=${Swap_Size}
		NAME[${i}]=${Swap_Proc_Name}
		i=${i}+1
	done
}

check_All_size(){
	i=1
	if [ ! -n "${App_Name}" ];then
		App_Name=$(ls -l /proc | grep ^d | awk '{print $9}' | grep -v [^0-9])
	fi
	for A_pid in ${App_Name};
	do
		if [ ${A_pid} -eq 1 ];then
			continue;
		fi
		grep -q "Rss" /proc/${A_pid}/smaps 2> /dev/null
		if [ $? -eq 0 ];then 
			P_Men_Size=$(grep "Rss" /proc/${A_pid}/smaps | gawk '{ sum+=$2;} END{print sum}')
			Swap_Size=$(grep "Swap" /proc/${A_pid}/smaps | gawk '{ sum+=$2;} END{print sum}')
			P_Men_Size=${P_Men_Size:=0}
			Swap_Size=${Swap_Size:=0}
			((A_Size=${P_Men_Size}+${Swap_Size}))
			A_Proc_Name=$(ps aux | grep -w "${A_pid}" | egrep -v "grep|${Script_name}" | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
		else
			continue;
		fi
		PID[${i}]=${A_pid}
		SIZE[${i}]=${A_Size}
		NAME[${i}]=${A_Proc_Name}
		i=${i}+1
	done
}

check_pmem_size(){
	i=1
	if [ ! -n "${App_Name}" ];then
		App_Name=$(ls -l /proc | grep ^d | awk '{print $9}' | grep -v [^0-9])
	fi
	for P_pid in ${App_Name};
	do
		if [ ${P_pid} -eq 1 ];then
			continue;
		fi
		grep -q "Rss" /proc/${P_pid}/smaps 2> /dev/null
		if [ $? -eq 0 ];then 
			P_Men_Size=$(grep "Rss" /proc/${P_pid}/smaps | gawk '{ sum+=$2;} END{print sum}')
			P_Men_Size=${P_Men_Size:=0}
			P_Proc_Name=$(ps aux | grep -w "${P_pid}" | egrep -v "grep|${Script_name}" | awk '{ for(i=11;i<=NF;i++){ printf("%s ",$i); }}')
		else
			continue;
		fi
		PID[${i}]=${P_pid}
		SIZE[${i}]=${P_Men_Size}
		NAME[${i}]=${P_Proc_Name}
		i=${i}+1
	done
}


format_data(){
	for((id=1;id<=${#PID[*]};id++))
	do
	    if [ ${SIZE[${id}]} -lt 1024 ];then
	        continue;
	    # elif [ ${SIZE[${id}]} -lt 1048576 ];then
	    else
	    	SWAP_SIZE=$(awk 'BEGIN{printf "%.2f\n",('${SIZE[${id}]}'/1024)}')
	    	printf "%s\t%-.2fMB\t%s\n" "${PID[${id}]}" "${SWAP_SIZE}" "${NAME[${id}]}"
	    # else
	    # 	SWAP_SIZE=$(awk 'BEGIN{printf "%.2f\n",('${SIZE[${id}]}'/1024/1024)}')
	    # 	printf "%-10s\t%15.2fGB\t%-5s\n" "${PID[${id}]}" "${SWAP_SIZE}" "${NAME[${id}]}"
	    fi
	done
}

avg_mult(){
	case ${Check_Class} in 
		swap)
		check_swap_size
		format_data
		;;
		mem)
		check_pmem_size
		format_data
		;;
		*)
		check_All_size 
		format_data
		;;
	esac
}
num=${num:=10}
printf "%s\t%s\t%s\n" "Pid" "Size" "Program name"
avg_mult | sort -n -k2 | tail -n${num}
 
