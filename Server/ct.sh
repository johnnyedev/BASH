#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="ct";
lsfunUSAGE="";
lsfunDESCRIP="Display current server time in UTC and CT";
lsfunCAT="general";

function ct () {

echo '--------------------------------' && 
(echo 'UTC |'; date "+%a %b %d %R:%S%p %Y") | paste -sd\ && 
echo '--------------------------------' && 
(echo 'UTC |'; date "+%a %b %d %I:%M:%S%p %Y") | paste -sd\ && 
echo '--------------------------------' && 
(echo 'CT  |'; TZ=America/Chicago date -d"`date`" "+%a %b %d %I:%M:%S%p %Y") | paste -sd\ && 
echo '--------------------------------';

}
