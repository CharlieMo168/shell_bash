#!/bin/bash

# This script is asking for solution time hop.

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


# record file
FILE=kafka_time_hop.txt
RESULT=kafka_time_hop_result.txt
echo "" > $RESULT

# get all kafka log
grep "_KAFKA_" -rn *.log | awk '{print $1}' > $FILE
ECHOI "$FILE has a total of `awk 'END{print NR}' $FILE` lines"

echo -e ""
echo -e "======================================"
ECHOI "Scan begin"

# get file first line
LAST=`awk 'NR==1' $FILE`

COUNT=0
# get file line except first
for line in `awk 'NR>1' $FILE `
do
    ((COUNT++))
    PRINT=$((COUNT%1000))
    if [ $PRINT == 0 ]
    then
        echo -e "$COUNT lines of record have been scanned"
    fi
    LAST_T=`echo $LAST | awk -F [ '{print $2}'`
    line_T=`echo $line | awk -F [ '{print $2}'`

    if [[ "$line_T" < "$LAST_T" ]]
    then
        echo -e ""
        ECHOI "There is a time hop" | tee -a $RESULT
        echo -e "$LAST" | tee -a $RESULT
        echo -e "$line" | tee -a $RESULT
        echo -e "" | tee -a $RESULT
        LAST=$line
    else
        LAST=$line
        continue
    fi
done
ECHOI "Scan finish"
echo -e "======================================"
echo -e ""

ECHOE "Scan result:(read from $RESULT)"
cat $RESULT

