#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="logtop";
lsfunUSAGE="";
lsfunDESCRIP="Check log for top occurrence";
lsfunCAT="log";


function logTopChangeLog() {
echo "##########################################################
##		Changelog logtop			##
##							##
##							##
##########################################################
#  	Version = MAJOR.MINOR.PATCH
#  	MAJOR version when you add functionality that doesn't work with existing code
#	MINOR version when you add functionality that does work with existing code
#	PATCH version when you make bug fixes that works with existing code.
#
#
# August 13th 2016 -v2.7.2
# +Fixed minor bug with script name display on version check
#
# August 5th 2016 -v2.7.1
# +added staging log support
#
# August 3rd 2016 v2.6.1
# +Added support for empty log files
# +Added the flags (-v, -d, -c) for version, dependencies, changelog
#
# July 29th 2016 v2.5.0
# +Moved the Log date into it's own function at the bottom 
# +Added support for both apache and nginx logs, and it now displays what log you are checking
# +Added Referer to the list of options
# +Reduced the 2 case statements, one for Apache & Nginx, into one case statement, code just got super shortened
#  Which I put into it's own function as well.
#
# July 25th 2016 - v2.1.0
# +Renamed to logtop
# +Will now be for checking top hit httpcodes/requests/uas/ips/etc
#
# July 24th 2016 - v1.1.0
# +Added Log Start/End Date and coverted to CDT/CST to output 
# +Updated to get HTTP codes from most recent log only - renamed to chkcodes
#
# July 15th 2016 - v1.0.0
# +Basic Script - gets all HTTP codes from all logs - renamed to getcodes 
#
# NEED TO DO:
# Add color
# Add use of exit codes & account for standard error, and redirect std err to personal error log in home directory.
# Add error log checking and accaunt for standard error
# Add ability to check either the most recent log, # specified, or range of logs ie: 2-4 
"
}






logTOPname="logtop";
logTOPversion=v2.7.2;
logTOPdependicies="none";

#Define Colors & Formatting
#green='\e[0;32m';
#gray='\e[0;37m';
#red='\e[0;31m';
#yellow='\e[1;33m';
#blue='\e[0;34m';
#orange='\e[0;33m';
#wpengineBlue='\e[0;49;36m';
#endColor='\e[0m';
#bold=`tput bold`;
#normal=`tput sgr0`;


function logtop() {	
#Vars
        #Set variable for the install by grabbing from the current directory
        install=$(pwd|cut -d/ -f5);

#Start Function
	
	if [[ -z $1 ]]; 
	then
		echo -e 'Run from install directory\n';
		echo -e 'Usage: logtop <-a|as|c|d|h|n|v> <-codes|host|ip|referer|type|ua|uri>\n';
	elif [[ $1 == '-v' || $1 == '--version' ]];
	then
		echo -e '\nFunction' $logTOPname 'is on version: \n' $logTOPversion '\n';
	elif [[ $1 == '-c' || $1 == '--change-log' ]];
	then
		logTopChangeLog;
        elif [[ $1 == '-h' || $1 == '--help' ]];
        then
                logTopHelpMenu;
	elif [[ $1 == '-d' || $1 == '--dependencies' ]];
	then	
		echo -e '\nFunction' $logTOPname 'has the following dependent files: \n' $logTOPdependicies '\n';
	elif [[ $1 == '-a' ]]; 
	then
		logType="/var/log/apache2/${install}.access.log";
	
		if [[ -s $logType ]];
		then
		logTopMain $2;
		else
		echo -e "\nNo logs to show!\n";
		fi
        elif [[ $1 == '-as' || $1 == '-sa' ]];
        then
                logType="/var/log/apache2/staging-${install}.access.log";

                if [[ -s $logType ]];
                then
                logTopMain $2;
                else
                echo -e "\nNo logs to show!\n";
                fi		
       elif [[ $1 == '-n' ]];
        then
		logType="/var/log/nginx/${install}.apachestyle.log";
		
  	        if [[ -s $logType ]];
                then
                logTopMain $2;
                else
                echo -e "\nNo logs to show!\n";
                fi
       elif [[ $1 == '-ns' || $1 == '-sn' ]];
        then
                logType="/var/log/nginx/staging-${install}.apachestyle.log";

                if [[ -s $logType ]];
                then
                logTopMain $2;
                else
                echo -e "\nNo logs to show!\n";
                fi
	else
		echo -e '\nInvalid Input\n';
	fi
}

function logTopMain() {

#Where all the work gets done

                        case $1 in
                                -codes|codes) #HTTP Codes
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'HTTP Codes: \n\t';
                                        cat $logType | awk '{print $9}' | sort | uniq -c | sort -rn | head;
                                        ;;
                                -host|host) #Hostname
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'Hostname(s): \n\t';
                                        if [[ $logType == /var/log/apache2/${install}.access.log ]]; then 
						echo -e "Apache does not contain hostname, traffic is served through Nginx";
						logType="/var/log/nginx/${install}.apachestyle.log";
						echo -e '\nDisplaying Output for: ' $logType '\n';
						cat $logType | awk '{print $2}' | sort | uniq -c | sort -rn;
					else
                                                cat $logType | awk '{print $2}' | sort | uniq -c | sort -rn;
					fi
                                        ;;
                                -ip|ip) #IP Address
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'IP Addresses: \n\t';
                                        cat $logType | awk '{print $1}' | sort | uniq -c | sort -rn | head;
                                        ;;
                                -uri|uri) #Requested URI
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'Requested URI: \n\t';
                                        cat $logType | awk '{print $7}' | sort | uniq -c | sort -rn | head;
                                        ;;
                                -referer|referer) #Referer
                                        echo -e '\nChecking Log: \n\t' $logType  '\n';
                                        logDateCal $logType;
                                        echo -e 'Referer(s): \n\t';
                                        cat $logType | awk '{print $11}' | sort | uniq -c | sort -rn | head;
                                        ;;
                                -type|type) #Request Type
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'Requested Type (GET,HEAD,POST,OPTIONS,TRACE): \n\t';
                                        cat $logType | awk '{print $6}' | sort | cut -d'"' -f2 | uniq -c | sort -rn;
                                        ;;
                                -ua|ua) #User Agent
                                        echo -e '\nChecking Log: \n\t' $logType '\n';
                                        logDateCal $logType;
                                        echo -e 'User Agents: \n\t';
                                        cat $logType | awk '{print $12}' | sort | cut -d'"' -f2 | uniq -c | sort -rn | head;
                                        ;;
                        esac
}

function logDateCal() {
#Function for getting Log Date Range and Displaying it

if [[ -z $1 ]];
then
        echo -e "Error Error"
else
logUsed=$1

#Start Time
	rawSUTC=$(awk -F"[\\\[ ,\\\] ]" 'NR==1{gsub("\\/","-"); sub("\\:","\t"); print $5$6}' "$logUsed")

	startUTC=$(TZ=UTC date -d"$rawSUTC" +'%I:%M%p %a %B-%d-%Y')
	startCST=$(TZ=America/Chicago date -d"$rawSUTC" +'%I:%M%p %a %B-%d-%Y')
	
#End Time
	rawEUTC=$(awk -F"[\\\[ ,\\\] ]" 'END{gsub("\\/","-"); sub("\\:","\t"); print $5$6}' "$logUsed")

        endUTC=$(TZ=UTC date -d"$rawEUTC" +'%I:%M%p %a %B-%d-%Y')
        endCST=$(TZ=America/Chicago date -d"$rawEUTC" +'%I:%M%p %a %B-%d-%Y')

#Print the Log Time Frame
        echo -e 'Log Time Frame: \n\tUTC: \t' $startUTC ' to ' $endUTC '\n\tCST/CDT:' $startCST ' to ' $endCST '\n';

fi
}


function logTopHelpMenu() {

echo "NAME
     logtop -- gather the most hits from log

SYNOPSIS
     logtop <-a|as|c|d|h|n|v> <-codes|host|ip|referer|type|ua|uri>

DESCRIPTION
	Logtop will show the output from the most recent log, display the time range of the log in UTC and CST/CDT. 	
    	
	One of the following are required:

	-a	Sets the log to the Apache access log.
	
	-as	Sets the log to the Apache Staging access log.	

	-n	Sets the log to the Nginx Apachestyle log.

	-c	Displays the changelog.

	-d	Displays any other files the script is dependent on.

	-h	Displays the help menu (what you are reading now).

	-v	Displays the scripts current version.

	Additionally the following options can be used:

	-codes	Displays the top HTTP status codes hit.

	-host	Displays the top hostnames used.

	-ip	Displays the top IP's that hit.

	-referer Displays the top referer's for the site.

	-type	Displays the top request types (GET, HEAD, POST, OPTIONS, TRACE).

	-ua	Displays the top user agents that hit.

	-uri	Displays the top page URI's that were hit.
"
}
