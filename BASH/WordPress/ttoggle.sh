#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="ttoggle";
lsfunUSAGE="";
lsfunDESCRIP="Toggle default theme on/off";
lsfunCAT="general";




function ttoggle () {


	if [[ -e wp-content/themes/default-theme-test/ ]];
	then
        ### Removing twentyseventeen theme named default-theme-test ###	
	
		### Put original template/stylesheet back in place ###
		# Set Stylesheet back to what it was before we touched a thing.
		wp db query --skip-plugins --skip-themes "update "$curPrefix"options set option_value='$curStylesheet' where option_name='stylesheet';";

		# Set template back to what it was before we touched a thing.
		wp db query --skip-plugins --skip-themes "update "$curPrefix"options set option_value='$curTemplate' where option_name='template';";


		### Delete theme folder ###
		rm -r wp-content/themes/default-theme-test/;

		### Confirmation ###
		echo -e '\nTemplate:' $curTemplate'\nStylesheet:' $curStylesheet'\n';
		echo -e '\nTheme restored - Test theme removed\nRemember to purge cache';

	else
	### Setting twentyseventeen theme named default-theme-test ###


                ### Set Path ###
                curPATH="/nas/content/$(pwd | cut -d '/' -f '4')/$(pwd | cut -d '/' -f '5')/";

		### Get Table Prefix ###
		curPrefix=$(grep '$table_prefix' "$curPATH"wp-config.php | cut -d"'" -f2);

		### Current theme template ###
		curTemplate=$(wp db query --skip-plugins --skip-themes "select option_value from "$curPrefix"options where option_name='template';" | awk '{print $1}' | tail -n1);

		### Current theme Stylesheet ###
		curStylesheet=$(wp db query --skip-plugins --skip-themes "select option_value from "$curPrefix"options where option_name='stylesheet';" | awk '{print $1}' | tail -n1);

		### Get Latest version of twentyseventeen download link ###
  		dtsLINK=$(curl -s https://wordpress.org/themes/twentyseventeen/ | grep https://downloads.wordpress.org/theme/twentyseventeen | cut -d'"' -f2);
		dtsNAME=$(echo $dtsLINK | cut -d'/' -f5);
 
		### Download - Unzip - Rename - Clean up ###
		wget -q $dtsLINK $curPATH && sleep 1; unzip -qq "$curPATH"$dtsNAME && sleep 1; mv "$curPATH"twentyseventeen "$curPATH"default-theme-test && rm "$curPATH"$dtsNAME; 

		### Move to theme folder and activate ###
		mv "$curPATH"default-theme-test "$curPATH"wp-content/themes/ && wp theme activate default-theme-test --skip-plugins --skip-themes;

	fi



}
