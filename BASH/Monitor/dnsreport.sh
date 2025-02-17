#!/bin/bash
#Author: Johnny Ellis

lsfunNAME="dnsreport";
lsfunUSAGE="<root domain>";
lsfunDESCRIP="Gathers DNS information, queries nameservers";
lsfunCAT="domain";


#Set Colors
dnsreportYELLOW='\033[33;1m';
dnsreportRED='\033[31;1m';
dnsreportBLUE='\033[34;1m';
dnsreportNC='\033[0m';


function dnsreport() {


if [[ -z $1 ]]; 
	then
	echo -e 'Usage: dnsreport example.com';

elif [[ -n $1 ]]; 
	then

#Check if www was provided, if it was, strip to root domain, all other subdomains proceed normally

dnsreportWWW=$(echo $1 | grep www.)

	if [[ -n $dnsreportWWW ]]; 
	then
	
	dnsreportDOMAIN=$(echo $1 | cut -d'.' -f2,3,4,5,6);
	
	dnsreportGETTHEINFO $dnsreportDOMAIN;
	
	else
	
	dnsreportDOMAIN=$1;
	dnsreportGETTHEINFO $dnsreportDOMAIN;
	
	fi;

else

echo -e '\nInvalid Input!\n';

fi

}


function dnsreportGETTHEINFO() {


# Check Who.is for Registrar Information
         printf "\n${dnsreportBLUE}Whois information:${dnsreportNC}\n";
         whois $1 | grep -E 'Registrar:|Registrar Name:|Registrar URL:|Updated Date:|Creation Date:|Expiration Date:' | tail -n5 | column -t | tr -s ' ';


# Current Name servers set
        printf "\n${dnsreportBLUE}Nameservers set:${dnsreportNC}\n";
        dig NS $1 +short;
	echo -e '\n-----------------------------';
# For each nameserver get DNS readout
       dnsreportNSLIST=$(dig NS $1 +short);
	
	for dnsreportI in $dnsreportNSLIST; 
	do 
	printf "\n${dnsreportBLUE}Nameserver:${dnsreportYELLOW} $dnsreportI${dnsreportNC}\n"; 
	dig +short $dnsreportI | whoip;
	printf "${dnsreportBLUE}\nDomain:${dnsreportYELLOW} $1${dnsreportNC}\n"; 
	dig +noall +answer +nocl +nottlid $1 @$dnsreportI; 
	printf "\n${dnsreportBLUE}Domain:${dnsreportYELLOW} www.$1${dnsreportNC}\n"; 
	dig +noall +answer +nocl +nottlid www.$1 @$dnsreportI; 
	echo -e '\n-----------------------------'; 
	done;

}
