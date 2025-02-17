#!/bin/bash
# Written by Johnny Ellis & Jeffrey Crane

function bandwchk() {
  unset -v bandwchkDATA bandwchkDATA bandwchkDATA3
  checksitepath

  if [ "$1" = "all" ] ; then
    nginxaccesslogpath="zcat -f /var/log/nginx/${sitepath}.access.log /var/log/nginx/${sitepath}.access.log.*"
  else
    if [ -z "$1" ] ; then
      nginxaccesslogpath="cat /var/log/nginx/${sitepath}.access.log"
      bandwchk-log-timeframe "${nginxaccesslogpath}"
    elif [ "$1" = "1" ] ; then
      nginxaccesslogpath="cat /var/log/nginx/${sitepath}.access.log.1"
      bandwchk-log-timeframe "${nginxaccesslogpath}"
    elif [ "$1" -ge "2" ] && [ "$1" -le "8" ] ; then
      nginxaccesslogpath="zcat /var/log/nginx/${sitepath}.access.log.${1}.gz"
      bandwchk-log-timeframe "${nginxaccesslogpath}"
    fi
  fi

  bandwchkDATA=$(${nginxaccesslogpath} | awk -F'|' '{print $6, $10}' | sort | uniq -c | awk '{print "'${blue}'" "  "$1 * ($2 / 1024 / 1024) "'${NC}'MB", "'${blue}'"$2 / 1024 / 1024 "'${NC}'MB", "'${blue}'"$1 "'${NC}' Requests", $4}' | sort -k 1.8 -rn | head -n10 | awk '{printf "%s %-20s %-29s %-2s %-14s %s\n", $1,$2,$3,$4,$5,$6}')

  bandwchkDATA2=$(${nginxaccesslogpath} | awk -F'|' '{sum += ($6 / 1024 / 1024)}END{print "'${blue}'""  "sum "'${NC}' MB"}')
  bandwchkDATA3=$(${nginxaccesslogpath} | awk -F'|' '{sum += ($6 / 1024 / 1024 / 1024)}END{print "'${blue}'""  "sum "'${NC}' GB"}')

  printf "\n"
  printf "+------------------------------------------------------+\n"
  printf "|  Total Bandwidth From Current Log:                   |\n"
  printf "+------------------------------------------------------+\n"
  printf "$bandwchkDATA2\n"
  printf "$bandwchkDATA3\n\n"
  printf "+---------------+----------------+------------------+----------------------------+\n"
  printf "| Total BW      |  1Req BW       |    #ofRequests   |      Requested             |\n"
  printf "+---------------+----------------+------------------+----------------------------+\n"
  printf "$bandwchkDATA\n\n"

}

function bandwchk-log-timeframe() {

  #timeframe
  nginxaccesstime="$(${1} | head -1 | cut -d" " -f1) - $(${1} | tail -1 | cut -d" " -f1)"

  echo -e "\n${yellow}Checking these files:${NC}"
  echo -e "   ${1}"
  echo -e "        ${green}Timeframe (UTC): ${nginxaccesstime}${NC}"

}
