#!/bin/bash -x

# calculate the continuously execute logmanag.py time

LOG=cal_log_ouput.log
RESULT=cal_log_result.log
CONTINU=cal_log_continu.log

# select logmanag.py
grep logmanag -rn toplog_record_STDU* | awk -F ':' '{print $1,"+"$2};' > $LOG

# statistics the time continuous execute
awk -F '+' '
	NR==1{loglin=$2; count=0;} 
	NR>1{
		diff=$2-loglin; 
		if(diff<90&&diff>0)
			{count+=1; {print diff,"\t",count,"\t",$0}}
		else if(diff<0)
			{{print "\nlog file switch"}; count=0}
		else
			{count=0}
		loglin=$2
	}' $LOG  > $RESULT

# select the time greater than 1
awk -F '\t' '
	{
		if(1<$2)
			{print $0}
		
	}' $RESULT > $CONTINU

