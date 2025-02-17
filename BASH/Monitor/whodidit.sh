#!/bin/bash

# Lsfun tags for indexing to list:
lsfunNAME="whodidit";
lsfunUSAGE="";
lsfunDESCRIP="History of SSH commands used";
lsfunCAT="security";


function whodidit() {
if [[ -z $1 ]];
 then

# for loop through each log in order, if you wildcard you will get logs out of order
	for log in /var/log/messages /var/log/messages.1 /var/log/messages.?.gz /var/log/messages.1?.gz /var/log/messages.2?.gz /var/log/messages.3?.gz; 
		do 

# zcat to decompress, tac to reverse the order. If you don't tac you will get days ascending but hours descending or vice versa
	 	 zcat -f $log 2>/dev/null | tac;
 
# finish loop so that we have all logs outputed line by line in order
# regex grep to get shell commands run by users  
# sed to clean up noise and focus on user_ and root
# grep -v to remove lines with no command run / output
# uniq to remove duplicates at same hour/min/sec
	done | tac | egrep -a ' bash\[[0-9]+\]: [a-z]+_?:' | sed -re 's_bash\[([0-9])+\]\:\ __g' -e 's_pub-pod-__g' -e 's_\:\#011 _\:\ _g' | grep -v :$ | uniq;

else
	echo -e 'Invaild Input\nUsage: whodidit (as root)';
fi

}
