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

LOGNAME="stdu-sendbuf"
LOG=$LOGNAME".log"
MAXLOGSIZE=$((10*1024*1024))
MAXLOGNUM=20
IP=`ip a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | grep -v 172.* | awk '{print $2}' | awk -F / '{ print $1}'`
#IP=`/sbin/ifconfig -a | grep inet | grep -v 127.0.0.1 | grep -v inet6 | grep -v 172.* | awk '{print $2}' | tr -d "addr:"`
PORT=`kubectl get svc | grep webuas | awk '{print $5}' | awk -F "[:/]" '{print $2}'`
SPID="00"$((4000100000000000+${1:-1}))

PRINT="write log record:\n file\t\t:$LOG\n max log size\t:$MAXLOGSIZE\n max log number\t:$MAXLOGNUM\n IP\t:$IP\n port\t:$PORT\n SPID\t:$SPID"
echo -e ""
ECHOI $PRINT

while true
do
	echo -e "" >> $LOG
	echo -e "" >> $LOG
	echo -e "==============================================================================" >> $LOG
	echo -e "[TIME]:"`date +"%Y-%m-%d %H:%M:%S"` >> $LOG

	curl -X POST -d '{"Dst":{"Type":4,"ID":"'$SPID'"},"DomainRoad":false,"M":{"Type":"ComReq","C":{"ID":"C_STDU_QueryCellSets","Param":{"Detail":"true"}}}}' http://$IP:$PORT/api/v1/ags_transactions >> $LOG

	echo -e "" >> $LOG
	echo -e "==============================================================================" >> $LOG

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

	sleep 5
done


