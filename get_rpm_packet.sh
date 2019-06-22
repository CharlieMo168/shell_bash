#!/bin/bash

function ECHO
{
    echo -e "\033[1;32m$* \033[0m"
}

INSTALLED="/bin/"
# install wget
PATH=`whereis yumdownloader`
if [[ $PATH != *$INSTALLED* ]]
then
    ECHO "Install yumdownloader from yum"
    yum install -y yum-utils*
fi

ECHO "==============================================="
ECHO "Get rpm packet $1"
#yum install --downloadonly --downloaddir=./ $1
echo -e "yumdownloader $1"
`yumdownloader $1`

ECHO "==============================================="

#INSTALLED="/bin/"
## install wget
#WGET=`whereis wget`
#if [[ $WGET != *$INSTALLED* ]]
#then
#    ECHO "Install wget from yum"
#    yum install -y wget
#fi

