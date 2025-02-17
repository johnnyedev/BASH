#!/bin/bash
#Author: Johnny Ellis


### Add the following 5 lines to script to make it load with lsfunG
# Lsfun tags for indexing to list:
#lsfunNAME=""; # Name of command
#lsfunUSAGE=""; # Syntax of commmand
#lsfunDESCRIP=""; # Description of command
#lsfunCAT=""; # Category to list under, see list, general, domain, log, security, migbackres, WIP

# Example
lsfunNAME="lsfun";
lsfunUSAGE="<no delimiters>";
lsfunDESCRIP="Used to list all custom functions";
lsfunCAT="list";

lsfunBLUE="\033[1;34m";
lsfunWHITE="\033[0;1m";
lsfunGRAY='\033[2;1m';
lsfunNC="\033[0m";

function lsfun () {
printf "\n${lsfunBLUE}T${lsfunWHITE}sunami Shell Functions:${lsfunNC}\n";

lsfunTITLES=("Lists" "General Troubleshooting" "Domains & DNS" "Load" "Logs" "Security" "Migration, Backups, & Restores");
lsfunTYPES=("list" "general" "domain" "load" "log" "security" "migbackres");
lsfunN=0;

for lsfunCATTYPE in ${lsfunTYPES[@]};
	do 
	printf "\n${lsfunBLUE}${lsfunTITLES[$lsfunN]}:${lsfunNC}\n";
	lsfunTYPE $lsfunCATTYPE;  
	lsfunGETTHEINFO; 
	((lsfunN++));
done;
}

function lsfunTYPE () {
lsfunMYLOCATION=$(echo $HOME | grep jellis_);
 
if [[ -z $lsfunMYLOCATION ]];
       then
        lsfunMYPATH='/Users/johnny.ellis/redshell/catapult/rsh_custom/';
       else
        lsfunMYPATH='/home/jellis_/rsh_custom/';
fi;

lsfunTYPE=$(grep -r 'lsfunCAT="'$1'"' $lsfunMYPATH* | cut -d':' -f1)
}

function lsfunGETTHEINFO () {
for lsfunLOOP in $lsfunTYPE ; 
	do 
	lsfunH=$(grep -rE 'lsfunNAME|lsfunUSAGE|lsfunDESCRIP' $lsfunLOOP --exclude="lsfun.sh") && 
	echo $lsfunH | awk -F'"' '{printf "%s %-15s %-20s %s\n", " ", $2, $4, "'${lsfunGRAY}'"$6"'${lsfunNC}'" }'; 
done;
}
