#!/bin/bash

function ECHO
{
    echo -e "\033[1;32m$* \033[0m"
}

ECHO "Before set:"
ECHO `sysctl -p`

RM_DF=$((100*1024*1024))
RM_MX=`expr 200 \* 1024 \* 1024`
let WM_MX=200*1024*1024

ECHO ""
ECHO "set rmem_default = $RM_DF, rmem_max = $RM_MX, wmem_max = $WM_MX"

FILE="/etc/sysctl.conf"

#set mem
egrep "^net\.core\.rmem_default" $FILE > /dev/null
if [[ $? == '0' ]];then
	if [[ `egrep "^net\.core\.rmem_default" $FILE |awk -F '=' '{print $2}'` -ge $RM_DF ]];then :
	else sed -i "s/^net\.core\.rmem_default.*/net.core.rmem_default = $RM_DF/" $FILE
	fi
else
	echo net.core.rmem_default = $RM_DF >> $FILE
fi
egrep "^net\.core\.rmem_max" $FILE > /dev/null
if [[ $? == '0' ]];then
	if [[ `egrep "^net\.core\.rmem_max" $FILE |awk -F '=' '{print $2}'` -ge $RM_MX ]];then :
	else sed -i "s/^net\.core\.rmem_max.*/net.core.rmem_max = $RM_MX/" $FILE 
	fi
else
	echo net.core.rmem_max = $RM_MX >> $FILE
fi
egrep "^net\.core\.wmem_max" $FILE > /dev/null
if [[ $? == '0' ]];then
	if [[ `egrep "^net\.core\.wmem_max" $FILE |awk -F '=' '{print $2}'` -ge $WM_MX ]];then :
	else sed -i "s/^net\.core\.wmem_max.*/net.core.wmem_max = $WM_MX/" $FILE
	fi
else
	echo net.core.wmem_max = $WM_MX >> $FILE
fi

ECHO ""
ECHO "After set:"
ECHO `sysctl -p`
