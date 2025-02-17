#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="chkhttp";
lsfunUSAGE="<install>";
lsfunDESCRIP="Get status code and cluster for install";
lsfunCAT="migbackres";
lsfunVER="1.5";

function chkhttp () {


bold=`tput bold`;
normal=`tput sgr0`;
BASIC='\e[0;34m';
GOOD='\e[0;32m';
ALERT='\e[0;31m';
NC='\e[0m';


if [[ -z $1 ]]; then

echo -e '\nUsage: chkhttp install';
echo -e 'Usage: chkhttp install1 install2 install3 install4\n';

else

# Total Inputs
	echo -e '\nYou are checking the status of ' $# ' installs.\n';
	inpct=0;
	

	for site in $@; 
	do
# Total Inputs
	((inpct++));

# Get pod # the install is on
	cluster=$(php /nas/wp/www/tools/wpe.php option-get $site cluster 2>/dev/null);
        
# Check current response is
	response=$(curl -Lk --write-out %{http_code} --silent --output /dev/null $site.wpengine.com);

# Initialize our 401 try counter here (see line 66 or so)
	counter=0;
	
# unset basica(basic-auth) var so the flag doesn't show on sites that never return 401
	unset basica;

# Run our worker function
	chkhttp-worker;	
	
# end our loop
	done;

fi;
}


function chkhttp-worker () {

# Let's grab the basic auth user/pass we have
        user=$(wpephp option-get $site nginx_basic_auth 2>/dev/null| grep user 2>/dev/null| cut -d' ' -f7);
        pass=$(wpephp option-get $site nginx_basic_auth 2>/dev/null| grep password 2>/dev/null| cut -d' ' -f7);

# Let's grab the URL location just incase its not the install.wpengine.com domain
        location=$(curl -Lk --write-out %{url_effective} --silent --output /dev/null -u $user:$pass $site.wpengine.com|cut -d'/' -f3);

if [[ $response == '401' ]]; then

# Let's set a variable so that we know a 401 was hit
basica="basic-auth";

# Let's cURL again with the updated user:pass@location
	response=$(curl -Lk --write-out %{http_code} --silent --output /dev/null -u $user:$pass $location);

# Let's run the function again - but it may return a 401 again - if it does we don't want this to loop forever
	if [[ $counter -lt 3 ]]; then
		((counter++));
		chkhttp-worker;
	else
# Looks like they likely have their own auth setup
		echo -e "$inpct ${bold}Install:${normal} $site ${bold}Cluster:${normal} $cluster ${bold}Response:${normal} ${ALERT}$response ${BASIC}$basica-external${NC}" |awk '{printf "%-3s %s %-14s %s %-7s %s %s %s\n", $1,$2,$3,$4,$5,$6,$7,$8}';	
	
	fi;

# Let's do some checking if we get a 301 or 302
elif [[ $response == '301' || $response == '302' ]]; then

	response=$(curl -sSL -u $user:$pass $location 2>&1);

	echo -e "$inpct ${bold}Install:${normal} $site ${bold}Cluster:${normal} $cluster ${bold}Response:${NC}" |awk '{printf "%-3s %s %-14s %s %-7s %s %-s", $1,$2,$3,$4,$5,$6,$7}'; echo -en $response '\n';
	

# We have a 200 let's go ahead and update stdout
elif [[ $response == '200' ]]; then

	echo -e "$inpct ${bold}Install:${normal} $site ${bold}Cluster:${normal} $cluster ${bold}Response:${normal} ${GOOD}$response ${BASIC}$basica${NC}" | awk '{printf "%-3s %s %-14s %s %-7s %s %s %s\n", $1,$2,$3,$4,$5,$6,$7,$8}';

# We have something other than a 200 301 302 or 401
else
	
 echo -e "$inpct ${bold}Install:${normal} $site ${bold}Cluster:${normal} $cluster ${bold}Response:${normal} ${ALERT}$response ${BASIC}$basica${NC}" |awk '{printf "%-3s %s %-14s %s %-7s %s %s %s\n", $1,$2,$3,$4,$5,$6,$7,$8}';

fi;

};
