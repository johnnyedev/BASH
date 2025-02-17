#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="diskinfo";
lsfunUSAGE="";
lsfunDESCRIP="Grabs useful information about a particular server";
lsfunCAT="migbackres";


function diskinfo () {



podNUM=$(hostname | cut -d'-' -f2);
installNUM=$(ls /nas/content/live | wc -l);
cpuNUM=$(wpephp server-option-get ${podNUM} 2>/dev/null | grep cpu 2>/dev/null | cut -d' ' -f15);
loadNUM=$(echo $cpuNUM / 2 | bc);
cpuUSE=$(sar -q | grep -iE 'am|pm' 2>/dev/null| awk '{print $5, $6, $7}' | grep -E "[${loadNUM}-9].[0-9]{2}|[1-9][0-9].[0-9]{2} 2>/dev/null");

dcINFO=$(wpephp server-option-get ${podNUM} 2>/dev/null | grep -i datacenter 2>/dev/null | cut -d' ' -f15);
phpVER=$(wpephp server-option-get ${podNUM} 2>/dev/null | grep php_apache_version 2>/dev/null | cut -d' ' -f15);

echo;
echo 'Cluster: ' $podNUM ' | Datacenter: ' $dcINFO ' | PHP Version: ' $phpVER;
echo;
echo 'Total Installs: ' $installNUM;
echo;
echo 'Disk Used: ';
df -h | grep -E '/$|/nas';
echo;
echo 'CPU ' $cpuNUM;
echo 'Showing Load Higher Than: ' $loadNUM;
echo;
echo $cpuUSE;
echo;


}
