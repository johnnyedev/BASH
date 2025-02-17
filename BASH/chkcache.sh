#!/bin/bash
#Author: Johnny Ellis

# Lsfun tags for indexing to list:
lsfunNAME="chkcache";
lsfunUSAGE="";
lsfunDESCRIP="Find cache files or folders";
lsfunCAT="general";



function chkcache() {
	find . -name "*cache*"
}
