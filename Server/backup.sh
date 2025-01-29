### Backups ###
echo 'Backing up configs...'
# Backup .bash_profile
rsync -zhr ~/.bash_profile ~/Documents/tsunami-shell/backup-configs/bash_profile-backup;

# Backup .vimrc
rsync -zhr ~/.vimrc ~/Documents/tsunami-shell/backup-configs/vimrc-backup;
echo -e 'Complete.\n';

# Backup custom functions
echo 'Backing up Tsunami Shell...';
rsync -zhr ~/redshell/catapult/rsh_custom/* ~/Documents/tsunami-shell/backup-scripts; 
echo -e 'Complete.\n';


# See if I'm at home:
amiHOME=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I | grep '\sSSID:' | sed 's/.*: //');

if [[ $amiHOME == "Tsunami2" ]];
	then
	#I'm at home!

 	# I don't want to rsync all this data everytime I open a new shell
 	# So let's incorporate red shells auto-update trick
	# Only run backup once every 3 hours.  Kudos to Dittmar

#     # This will return 1 or 0 (for True/False).
#     # 0 don't run backup
#     # 0 returns if file is less than 86400(24hours) old
#     # 1 run the backup
#     # 1 returns if file is more than 86400(24hours) old
     auto_backup_check=$(echo "$(date +%s)-$(stat -f "%a" /Users/johnny.ellis/Documents/tsunami-shell/auto-update-backup)>86400" | bc);
     if [[ $auto_backup_check -eq 0 ]]; then
       return;
     fi;
#     # This effectively resets the timer.
#     # So that if I just ran a backup, the timer won't still say It's been longer then 3 hours a    nd backup again
         touch /Users/johnny.ellis/Documents/tsunami-shell/auto-update-backup;



# Looks like I'm at home and it's been longer than 3 hours since last backup
	echo -e '\n\nBacking up tsunami-shell folder...';
	# Create our Mount Directory
	mkdir /Volumes/NAS;
	# Mount my home server
	mount -t smbfs //guest:@192.168.1.70/nas /Volumes/NAS;
	# Copy everything over
	rsync -zhr /Users/johnny.ellis/Documents/tsunami-shell/* /Volumes/NAS/files/Dev/backups/mac-wpengine;
	# Unmount
	umount /Volumes/NAS/;
	echo 'Complete.';
	echo -e '\n\n';

else
 	#I'm not at home, do nothing
	echo -e '\n\n';
fi;
