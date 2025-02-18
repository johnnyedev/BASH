#!/bin/bash
# Author johnnyedev

# This script assumes it will be run as root from (/root/user_script2.sh) 
# and have access to /var/log/ and /tmp directories
# However if running as a local user, these variables can be uncommented/updated to run as non-root

 current_user_log=./current_users
 user_changes_log=./user_changes
 usr_tmp_log=./usrpasswd.tmp
 md5_tmp_log=./md5passwd.tmp


# If above local log locations have been uncommented, then the corresponding log variable below needs to be commented to prevent override
#current_user_log=/var/log/current_users
#user_changes_log=/var/log/user_changes
#usr_tmp_log=/tmp/usrpasswd.tmp
#md5_tmp_log=/tmp/md5passwd.tmp

# function to get user:home_dir
function usrpasswd () {

        # Read contents of /etc/passwd line by line and filter/echo out to user:home_dir
        while read i
                do

                # Store users and home directories in seperate variables
                user_list=$(echo $i | cut -d':' -f1)
                user_home=$(echo $i | cut -d':' -f6)

                # Echo them out as one line
                echo $user_list:$user_home

        done</etc/passwd
}


# function to convert user:home_dir to md5hash
function md5passwd () {

        # Generate user:home_dir output
        usrpasswd > $usr_tmp_log

        # Convert to MD5 hash
        while read i
                do

                echo -n $i | md5sum | cut -d' '  -f1

        done<$usr_tmp_log

        # Cleanup tmp file
        rm $usr_tmp_log
}

# function to see if any changes have occured
function md5diff () {

        # Generate new temporary MD5 hash of current /etc/passwd user:home_dir
        md5passwd > $md5_tmp_log
        # Compare temp file just created with the existing current_users log
        my_diff=$(diff $md5_tmp_log $current_user_log)

        # If there are no changes then do nothing
        if [[ -z $my_diff  ]]; then

# comment the echo to remove vebose output
echo 'no changes'

                # Cleanup temporary MD5 hash file
                rm $md5_tmp_log

        # If there are changes, update the current_user and user_changes logs
        else

# comment the echo to remove vebose output
echo "diff found"

                # User our Temporary MD5 hash file to update current_user log
                cat $md5_tmp_log > $current_user_log
                # Cleanup temporary MD5 hash file
                rm  $md5_tmp_log

# comment the echo to remove vebose output
echo "create/update user_changes log"

                # Get current date in formate of DATE & TIME
                my_date=$(date -d"`date`" +'%B-%d-%Y %I:%M%p')
                # Update our user_changes log with DATE & Time + note that change occured
                echo $my_date changes occured >> $user_changes_log
        fi
}

#####  MAIN  #####

# current_users log already exists
if [[ -s $current_user_log ]]; then

        # Check if any hashes change
        md5diff
# current_users log does not exist
else
        # Create our current_users md5 log file via our md5passwd function
        md5passwd  > $current_user_log
        
# comment the echo to remove vebose output
echo "created current_user log"

fi
