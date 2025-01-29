#!/bin/bash
#Author: Johnny Ellis

lsfunNAME="watchman";
lsfunUSAGE="";
lsfunDESCRIP="Get real time stats";
lsfunCAT="load";


function watchman ()
{
	if [[ -z $1 ]];
	then
	echo -e '\n Usage: watchman <install>';

	else
	
	# Set install
	install=${1};

	# Get log length
	logLENGTH=$(wc -l < /var/log/apache2/$install.access.log);
	logNLENGTH=$(wc -l < /var/log/nginx/$install.access.log);
	logELENGTH=$(wc -l < /var/log/apache2/error.log);
	logKLENGTH=$(wc -l < /var/log/apache-killed-by-wpe.log);	

	# Get Load
	getLOAD="uptime | cut -d' ' -f12-;";
	
	# Get Restarts, SIGTERM, Seg Faults, Evictions
	bucketNAME=$(php /etc/wpengine/bin/queues.php --account=all | grep -wo ${install});
	
	if [[ -z $bucketNAME ]]; 
	then
		bucketNAME=$(wpephp parent-record-get ${install} | grep 'account_name' | cut -d' ' -f7);
		getRSSE="echo; (echo -n 'Restarts: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep restart| wc -l; echo -n 'SIGTERM: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep SIGTERM| wc -l; echo -n 'SegFaults: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep Segmentation| wc -l; echo -n 'Total Evictions: '; php /etc/wpengine/bin/queues.php --account=all | grep -w $bucketNAME | cut -d'|' -f9) | xargs;";
	else
		getRSSE="echo; (echo -n 'Restarts: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep restart| wc -l; echo -n 'SIGTERM: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep SIGTERM| wc -l; echo -n 'SegFaults: '; tail -n+${logELENGTH} /var/log/apache2/error.log| grep Segmentation| wc -l; echo -n 'Total Evictions: '; php /etc/wpengine/bin/queues.php --account=all | grep -w $bucketNAME | cut -d'|' -f9) | xargs;";
	
	fi;
	
	# Get Log Size
	getnaeSIZE="(echo -n 'Log: Size Lines | Nginx: '; du -sh /var/log/nginx/${install}.access.log|cut -d'/' -f1; wc -l /var/log/nginx/${install}.access.log| cut -d'/' -f1; echo -n ' | Apache: '; du -sh /var/log/apache2/${install}.access.log|cut -d'/' -f1; wc -l /var/log/apache2/${install}.access.log| cut -d'/' -f1; echo -n ' | Error: '; du -sh /var/log/apache2/${install}.error.log|cut -d'/' -f1; wc -l /var/log/apache2/${install}.error.log|cut -d'/' -f1) | xargs;"

	# Get IP
	getIP="echo; echo 'IP:'; tail -n+${logLENGTH} /var/log/apache2/${install}.access.log | cut -d' ' -f1 | sort | uniq -c | sort -rn | head -n5;";	

	# Get UA 
	getUA="echo; echo 'User Agent: ' ; tail -n+${logLENGTH} /var/log/apache2/${install}.access.log | cut -d' ' -f12- | sort | uniq -c | sort -rn | head -n5;";

	# Get URI
	getURI="echo; echo 'URI: '; tail -n+${logLENGTH} /var/log/apache2/${install}.access.log | cut -d' ' -f7 | sort | uniq -c | sort -rn | head -n5;";

	# Get Referer
	getREF="echo; echo 'Referer: '; tail -n+${logLENGTH} /var/log/apache2/${install}.access.log | cut -d' ' -f11 | sort | uniq -c | sort -rn | head -n5;";

	# Get Codes 401, 403, 404, 444, 499, 500, 502, 503, 504
	getCODES="echo; echo 'Codes: '; tail -n+${logNLENGTH} /var/log/nginx/${install}.access.log |  grep -E '\|401\||\|403\||\|404\||\|444\||\|499\||\|502\||\|503\||\|504\|' | cut -d'|' -f5 | sort | uniq -c | sort -rn;";
		
	# Get Killed
	# Get Domains list
	domains=$(php /nas/wp/www/tools/wpe.php option-get-json $install domains | json_pp | grep -vE "\[|\]|\,|\"redirects\"" | cut -d'"' -f2 | grep -vE "\{|\}" | xargs | sed 's/\ /\|/g');	


	getKILL="echo; echo 'Killed: '; tail -n+${logKLENGTH} /var/log/apache-killed-by-wpe.log | grep -E $domains  | cut -d' ' -f8 | sort | uniq -c | sort -rn | head -n5;";

	# Get MySQL process
	getSQL="echo; echo 'MySQL: '; echo 'Id      User         Host/IP         DB       Time    Cmd    State Query';sudo mytop -b | grep ${install} | cut -d' ' -f2-;";


	# Run the watch command
	watch -tn 1 "evictVAL2=$(php /etc/wpengine/bin/queues.php --account=all | grep -w $bucketNAME | cut -d'|' -f9 | xargs); echo 'Install: '${install}; ${getLOAD} ${getRSSE} ${getnaeSIZE} ${getIP} ${getUA} ${getURI} ${getREF} ${getCODES} ${getKILL} ${getSQL}"

	fi

}
