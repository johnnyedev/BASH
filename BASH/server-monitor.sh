function monitor()
{
        echo ""
        # Data validation
        if [[ -z $1 || -z $2 ]]
        then
                echo -e "Usage: monitor [load limit] [time interval] (email address)\n"
                echo -e "   Load Limit: Trigger a warning for any load over this limit\n"
                echo -e "Time interval: Check the load every X seconds\n"
                echo -e "Email address: Send an email to this email address whenever the load goes over"
                echo -e "               the limit, a maximum of once per 5 minutes\n"
                return 1
        fi
        if (( "$2" < "10" ))
        then
                echo -e "There is a minimum time interval limit of 10 seconds to maintain server stability.\n"
                return 1
        fi
        # Initialize variables
        loadWatch=$1
        timeInterval=$2
        email=$3
        lastEmail=$(( $(date +%s) - 300 ))      # Last email time
        # Color definitions for output
        red='\x1b[0;31m'
        noc='\x1b[0m'
        pod=$(sudo cat /etc/cluster-id)
        type=$(sudo cat /etc/cluster-type)
        # Pod Environment
        if [[ $type =~ "pod" ]]
        then
                echo -e "Pod detected! Monitoring just this server...\n\n"
                echo -e "+----------+-------------------------+-------+--------+--------+--------+--------+"
                echo -e "|     TIME |                HOSTNAME |  502s |  504s  | Load-1 | Load-5 | Load15 |"
                echo -e "+----------+-------------------------+-------+--------+--------+--------+--------+"
                i=$(dig +short $(hostname).wpengine.com)
                while true; do
                        warning=0
                        node=$(hostname)
                        loadline=$(echo "$(awk -F"|" {'print $5'} /var/log/nginx/*.access.log 2>/dev/null | grep -c "^502$") $(awk -F"|" {'print $5'} /var/log/nginx/*.access.log | grep -c "^504$") $(uptime)")
                        loadDisplay
                        sleep ${timeInterval}
                done
                return 0
        # Cluster/HAPOD Environment
        elif [[ $type =~ "apache" || $type =~ "dbmaster" || $type =~ "mysql" || $type =~ "hapod" || $type =~ "utility" ]]
        then
                echo -e "Cluster or HAPOD detected! Monitoring all webheads/nodes...\n\n"
                    echo -e "+----------+---------------------------+-------+-------+--------+--------+--------+"
                while true; do
                        echo -e "|     TIME |                  HOSTNAME |  502s |  504s | Load-1 | Load-5 | Load15 |"
                        echo -e "+----------+---------------------------+-------+-------+--------+--------+--------+"
                        for h in $(grep "[a-z]*-${pod}" /etc/hosts | egrep -v "pub|lbmaster|storage" | awk {'print $2'}); do
                                node=$(grep ${h} /etc/hosts | head -1 | awk {'print $2'})
                                if [[ $node =~ "web" ]]
                                then
                                        loadline=$(sudo ssh -o "StrictHostKeyChecking=no" -o "LogLevel=quiet" ${h} 'echo "$(for s in $(ls /nas/content/live); \
                                        do cat /var/log/nginx/$s.access.log 2>/dev/null; done | egrep -c "\|502\|") $(for s in $(ls /nas/content/live); do cat /var/log/nginx/$s.access.log 2>/dev/null; done | egrep -c "\|504\|") $(uptime)"')
                                else
                                        loadline=$(sudo ssh -o "StrictHostKeyChecking=no" -o "LogLevel=quiet" ${h} 'echo "N/A N/A $(uptime)"')
                                fi
                                loadDisplay
                        done
                        echo -e "+----------+---------------------------+-------+-------+--------+--------+--------+"
                        sleep ${timeInterval}
                done
                return 0
        else
                echo -e "Server type not recognized.\tType: \"${type}\""
                return 1
        fi
        return 1
}
function loadDisplay()
{
        fot=$(echo ${loadline} | awk {'print $1'})
        fof=$(echo ${loadline} | awk {'print $2'})
        loadTime=$(echo ${loadline} | awk {'print $3'})
        loads=($(echo ${loadline} | awk -F": " {'print $2'} | awk -F", " {'print $1" "$2" "$3'}))
        warning=0
        emailmsg="${loads[0]} ${loads[1]} ${loads[2]}"
        for x in 0 1 2; do
                if [[ ${loads[x]} > $loadWatch ]]
                then
                        loads[x]="${red}${loads[x]}${noc}"
                        warning=1
                fi
        done
        if [[ ! -z ${email} && ${warning} == "1" && (( $(( ${lastEmail} + 300)) < $(date +%s) )) ]]
        then
                echo "Load Warning: ${emailmsg}" | mail -s "Load Warning (${node}): ${emailmsg}" ${email}
                lastEmail=$(date +%s)
        fi
        printf "| %8s | %25s | %5s | %5s | %6s | %6s | %6s |\n" "${loadTime}" "${node}" "${fot}" "${fof}" "$(echo -e ${loads[0]})" "$(echo -e ${loads[1]})" "$(echo -e ${loads[2]})"
}
