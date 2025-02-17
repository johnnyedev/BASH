#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="nofsp";
lsfunUSAGE="";
lsfunDESCRIP="Adds no force strong passwords to mu-plugins.";
lsfunCAT="general";


function nofsp() {

    if [[ -e wp-content/mu-plugins/nofsp.php ]] && [[ -e wp-config.php ]]; then
        
	echo -ne '\nAlready installed, would you like to remove it? [y|n]: '; 
	read delfil;

		if [[ $delfil == "y" || $defill == "Y" ]]; then
			
		 rm -v wp-content/mu-plugins/nofsp.php;

		else
		 
		 unset delfil;	
		 echo -e '\nNo action taken. nofsp still installed.\n';

		fi
    else

        cp -v /opt/nas/www/support-scripts/nofsp.php ./wp-content/mu-plugins/nofsp.php;

    fi

}
