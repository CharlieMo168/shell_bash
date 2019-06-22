#!/bin/bash

# hightlight INFO
function ECHOI()
{
    echo -e "\033[1;32m[INFO]$* \033[0m"
}

# hightlight ERROR
function ECHOE()
{
    echo -e "\033[1;31m[ERR]$* \033[0m"
}

# default monitor STDU
PNAME=${1:-STDU}
# sleep time, default 3s
SLEEP_T=${2:-3}
LOGNAME="toplog_record_$PNAME"
LOG=$LOGNAME".log"
MAXLOGSIZE=$((10*1024*1024))
MAXLOGNUM=20

if [ ! $1 ]
then
    ECHOI "monitor the default program $PNAME, sleep time $SLEEP_T"
    ECHOI "if you want to monitor other program, please usage : $0 [program name] [sleep time]"
else    
    ECHOI "monitor the program $PNAME, sleep time $SLEEP_T"
fi
 
# get pid
PID=`ps -ef | grep -v grep | grep -w $PNAME | grep zookeeper | awk '{ print $2}'`
# KAF_PID=`ps -ef | grep kafka | grep java | grep server.properties | awk '{ print $2}'`

PRINT="write log record:\n file\t\t:$LOG\n PID\t\t:$PID\n max log size\t:$MAXLOGSIZE\n max log number\t:$MAXLOGNUM"
echo -e ""
ECHOI $PRINT

# PID is more than one
if [ "${#PID[@]}" -gt "1" ]
then
    echo -e "${#PID[@]}"
    ECHOE    "Search result is more than one, exit!"
    echo -e "Search result is more than one, exit!" >> $LOG
    exit 1
fi

if [ ! $PID ]
then
    echo -e ""
    ECHOE "$PNAME not found, exit"
    exit 1
fi

while true
do
    echo -e "" >> $LOG
    echo -e "" >> $LOG
    echo -e "==============================================================================" >> $LOG
    echo -e "[TIME]:"`date +"%Y-%m-%d %H:%M:%S"` >> $LOG

# NULL will exit
#   if [ -z "$PID" ]
#   then
#       echo -e "Process Exited!" >> $LOG
##      echo -e "KAFKA docker Exited!" >> $LOG
#       break
#   fi

#   top -p $PID,$PID2 -n 1 -b | grep CPU -A 2 >> $LOG
#   top -H -n 1 -b | grep "PID" -B 6 -A 15 >> $LOG
    top -Hp $PID -n 1 -b | grep "PID" -B 6 -A 7 >> $LOG

    echo -e "" >> $LOG

#   yum install -y sysstat
    sar -n DEV 1 1 >> $LOG

#    echo -e "" >> $LOG
#    pstack $PID >> $LOG

#   yum install -y dstat
#   dstat -N eth0 3

#   docker stats --no-stream | grep CONTAINER >> $LOG
#   docker stats --no-stream | grep $(docker ps -a | grep kafka | awk '{ print $1}') >> $LOG
#   docker stats --no-stream CONTAINER >> $LOG

    echo -e "==============================================================================" >> $LOG

    # rename log file
    LOGSIZE=`ls -l $LOG | awk '{ print $5 }'`
    if [ $LOGSIZE -gt $MAXLOGSIZE ]
    then
        echo -e "" >> $LOG
        mv $LOG $LOGNAME"_`date +%Y-%m-%d_%H-%M-%S`".log
    fi

    # delete log file when greater than max log num
    LOGNUM=`ls -l | grep $LOGNAME"_" | wc -l`
    if [ $LOGNUM -gt $MAXLOGNUM ]
    then
        let DELNUM=LOGNUM-MAXLOGNUM;
        ls -lt | grep $LOGNAME"_" | awk '{print $9}' | head -n $DELNUM | xargs rm -f
    fi

    sleep $SLEEP_T
done


