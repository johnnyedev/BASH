# Tested on CentOS boxes with Plesk and cPanel
 
echo -e "\n\nKernel Last Updated: `grep Updated: /var/log/yum.log | grep -i kernel | tail -1 | awk '{print $1, $2, $3}'`\nLast Reboot: `last reboot|awk '{print $5, $6, $7, $8}'|head -n 1`\n"; 
echo -e "OS Version: `cat /etc/*release* | grep release | uniq`\n";
if [ -f /usr/local/cpanel/cpanel ];
 then echo -e "\ncPanel Version: `/usr/local/cpanel/cpanel -V`\nLatest Is: 74\n"; 
elif [ -f /usr/local/psa/.release ]; 
 then echo -e "\nPlesk Version: `plesk version | grep Product | grep -P "Plesk".*|awk -F\: '{print $2}'`\nLatest Is:      Plesk Onyx 17.8\n"; 
 fi;  
 
DIAGMEM="`free -m | grep "Mem"`" ; 
echo -e "Memory Usage -\nTotal Memory: `echo $DIAGMEM|awk '{print $2/1024}'| grep -oP "[0-9].*\.[0-9]"`GB\nUsed Memory: `echo $DIAGMEM|awk '{print $3/1024}'| grep -oP "[0-9].*\.[0-9]"`GB\nFree Memory: `echo $DIAGMEM|awk '{print $4/1024}'| grep -oP "[0-9].*\.[0-9]"`GB\nAvailable Memory: `echo $DIAGMEM|awk '{print $7/1024}'| grep -oP "[0-9].*\.[0-9]"`GB\n";
echo -e "Physical Cores: $(grep ^cpu\\scores /proc/cpuinfo | uniq |  awk '{print $4}')\nHyper Threaded Cores: `grep -c ^processor /proc/cpuinfo`\n";
HIU=`sar | awk '{print $9}'| grep -o "[0-9].*" | sort -n | head -n 1`; 
echo -e "Today's Average CPU Usage -\nCPU Idle: `sar | awk '{print $9}'| grep -o "[0-9].*" | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'`%\nCPU Used: `sar | awk '{print $9}'| grep -o "[0-9].*" | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'|awk '{print (100 - $1)}'`%\nHighest Usage: `sar | awk '{print $9}'| grep -o "[0-9].*" | sort -n | head -n 1 | awk '{print ( 100 - $1 ) }'`% at `sar | grep $HIU | awk '{print $1, $2}'`\n";
HIO=`sar -f /var/log/sa/sa$(date|awk '{print $3}'|awk '{print ( $1 - 1 ) }'|sed 's/\<[0-9]\>/0&/') | awk '{print $9}'| grep -o "[0-9].*" | sort -n | head -n 1`; 
echo -e "Yesterday's Average CPU Usage -\nCPU Idle: `sar -f /var/log/sa/sa$(date|awk '{print $3}'|awk '{print ( $1 - 1 ) }'|sed 's/\<[0-9]\>/0&/') | awk '{print $9}'| grep -o "[0-9].*" | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'`%\nCPU Used: `sar -f /var/log/sa/sa$(date|awk '{print $3}'|awk '{print ( $1 - 1 ) }'|sed 's/\<[0-9]\>/0&/') | awk '{print $9}'| grep -o "[0-9].*" | awk '{ sum += $1; n++ } END { if (n > 0) print sum / n; }'|awk '{print (100 - $1)}'`%\nHighest Usage: `sar -f /var/log/sa/sa$(date|awk '{print $3}'|awk '{print ( $1 - 1 ) }'|sed 's/\<[0-9]\>/0&/') | awk '{print $9}'| grep -o "[0-9].*" | sort -n | head -n 1 | awk '{print ( 100 - $1 ) }'`% at `sar -f /var/log/sa/sa$(date|awk '{print $3}'|awk '{print ( $1 - 1 ) }'|sed 's/\<[0-9]\>/0&/') | grep $HIO | awk '{print $1, $2}'`\n" ; df -h | awk '{print $1 " Used: "$3 "/" $2, $5" Used"}'|grep -v Filesystem|column -t | sort -rnk 4 | grep -v "0%.*Used";
echo -e "\nInternet Speeds (This may take a minute): ";
echo -e "`curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python - | grep "Download\|Upload"`\n"; 
echo -e "Zabbix Agent Check:\n`service zabbix-agent status`\n"
 
# Example output

# Kernel Last Updated: Jul 14 04:00:37
# Last Reboot: Fri Jun 15 02:11
 
# OS Version: CentOS release 6.10 (Final)
 
# Plesk Version:  Plesk Onyx 17.8.11 Update #15
# Latest Is:      Plesk Onyx 17.8
 
# Memory Usage -
# Total Memory: 31.3GB
# Used Memory: 30.5GB
# Free Memory: 0.7GB
# Available Memory: 19.4GB
 
# Physical Cores: 6
# Hyper Threaded Cores: 24
 
# Today's Average CPU Usage -
# CPU Idle: 91.0359%
# CPU Used: 8.9641%
# Highest Usage: 20.08% at 12:30:02 AM
 
# Yesterday's Average CPU Usage -
# CPU Idle: 90.188%
# CPU Used: 9.812%
# Highest Usage: 19.99% at 08:20:01 AM
 
# /dev/sda1  Used:  166M/485M  36%  Used
# /dev/sda3  Used:  185G/912G  22%  Used
# /dev/sdb1  Used:  262G/5.0T  6%   Used
# tmpfs      Used:  4.0K/16G   1%   Used
 
# Internet Speeds (This may take a minute):
# Download: 91.63 Mbit/s
# Upload: 111.51 Mbit/s
 
# Zabbix Agent Check:
# zabbix_agentd (pid  23079) is running...
