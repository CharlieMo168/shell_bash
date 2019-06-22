#!/bin/bash -x

# hightlight INFO
function ECHOI()
{
    echo -e "\033[1;32m[INFO]$* \033[0m"
}

# print the execute command 
export PS4='\033[1;32m +{$BASH_SOURCE:$LINENO:${FUNCNAME[0]}} [EXEC CMD]: \033[0m'

# default replace STDU
PNAME=${1:-STDU}

cd ../usr/bin
cp $PNAME $PNAME"-bak-`date +%Y-%m-%d_%H-%M-%S`"
curl -O 192.168.131.38:10080/bin/$PNAME"_d"
mv -f $PNAME"_d" $PNAME
chmod +x $PNAME

ECHOI "====================================================="
cd -
./stopAll.sh
sleep 0.5
./background.sh $PNAME

ECHOI "====================================================="
ls -l ../usr/bin
sleep 1
ps -ef
