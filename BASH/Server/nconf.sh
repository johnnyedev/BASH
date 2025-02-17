#!/bin/bash
#Author: Johnny Ellis

lsfunNAME="nconf";
lsfunUSAGE="<search term>";
lsfunDESCRIP="Search through the Nginx conf file for given string";
lsfunCAT="general";


function nconf() {

nconfINSTALL=$(pwd | cut -d '/' -f '5');

if [[ -z $1 ]]; 
	then
	echo -e '\nUsage: nconf <search term>';
elif [[ -n $1 ]];
	then
	grep -ni -A3 -B3 $1 /nas/config/nginx/$nconfINSTALL.conf; 
else
	echo -e '\nInvalid Input';
fi;


}
