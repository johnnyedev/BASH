#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="phpinfo";
lsfunUSAGE="";
lsfunDESCRIP="Creates a phpinfo page.";
lsfunCAT="general";


function phpinfo() {


echo -e '

<?php
// Show all information, defaults to INFO_ALL
phpinfo();
?>

' > phpinfo.php;

echo -e "\n See PHP infomration here: \n $(pwd | cut -d '/' -f '5').wpengine.com/phpinfo.php";

}
