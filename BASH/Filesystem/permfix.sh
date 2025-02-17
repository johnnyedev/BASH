#!/usr/bin/env bash

# Script to quickly fix permissions

function permfix() 
{
 if [[ -z $1 ]]; then
	echo -e 'Usage: fixperms <path to directory>\nNote: This command is recurisve by default'

 elif [[ -n $1 ]]; then
	sudo -v
	sudo chown -R nobody:nobody $1
	sudo chmod -R 777 $1

 else
	echo -e 'Invalid Input'

 fi
}
