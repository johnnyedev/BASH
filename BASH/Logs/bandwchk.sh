#!/bin/bash
#Author: Johnny Ellis


# Lsfun tags for indexing to list:
lsfunNAME="bandwchk";
lsfunUSAGE="";
lsfunDESCRIP="Used to get an idea of whats using bandwidth";
lsfunCAT="log";

# Written by Johnny Ellis

#Set Colors
bandwchkBLUE='\033[34;1m';
bandwchkNC='\033[0m';


function bandwchk() {

bandwchkDATA=$(awk -F'|' '{print $6, $10}' /var/log/nginx/$(pwd | cut -d '/' -f '5').access.log|sort|uniq -c|awk '{print "'${bandwchkBLUE}'" $1 * ($2 / 1024 / 1024) "'${bandwchkNC}'MB", "'${bandwchkBLUE}'"$2 / 1024 / 1024 "'${bandwchkNC}'MB", "'${bandwchkBLUE}'"$1 "'${bandwchkNC}'Requests", $4}' |sort -k 1.8 -rn| head -n10); 

bandwchkDATA2=$(awk -F'|' '{sum += ($6 / 1024 / 1024)}END{print "'${bandwchkBLUE}'"sum "'${bandwchkNC}'MB"}' /var/log/nginx/$(pwd | cut -d '/' -f '5').access.log);

echo -e '\n';
echo '-------------------------------------------------------';
echo -e 'Total Bandwidth From Current Log:';
echo '-------------------------------------------------------';
echo "$bandwchkDATA2";
echo -e '\n';
echo '-------------------------------------------------------';
echo -e 'Total BW | 1Req BW | #ofRequests | Requested'| column -t; 
echo '-------------------------------------------------------'; 
echo "$bandwchkDATA"

}
