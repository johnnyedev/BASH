#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="chkrecent";
lsfunUSAGE="<#>";
lsfunDESCRIP="Check last modified files, default 10";
lsfunCAT="security";

# Written By Johnny Ellis


function chkrecent() {

if [[ -z $1 ]];
	then
		echo -e '\nchkrecent 100 - to see last 100 files';
		echo -e '\nLast modified files:\n';
		find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | sort -rn | head;
	else
		find . -type f -printf '%TY-%Tm-%Td %TT %p\n' | sort -rn | head -n$1 ;

fi;
}
