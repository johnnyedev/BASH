#!/bin/bash
#Author: Johnny Ellis

lsfunNAME="lsvim";
lsfunUSAGE="";
lsfunDESCRIP="Vim cheatsheet";
lsfunCAT="list";

#Set Colors
lsvimBLUE='\033[34;1m';
lsvimGRAY='\033[0;2m';
lsvimNC='\033[0m';


# Notes:
# To get nice formatting for this I put into a file formatted as:
# h  -  moves the cursor one character to the left
# Then used the command below to format it as it's written below
# cat vimcheatsheet.txt | awk -F'-' '{printf "%-35s %-1s \n", "printf \" "$1, $2"\\n\"\;"}'


lsvim ()
{
    if [[ -n $1 ]]; then
        printf 'Usage: lsvim\n';
    else

printf "\n${lsvimBLUE}Vim Cheatsheet:${lsvimNC}             \n";

printf "\n${lsvimBLUE}Main:${lsvimNC}                       \n";
printf " Command Mode                  use the ESCAPE key to enter command mode.\n";
printf " Insert Mode                   use the i key to enter insert mode to type text.\n";
printf " Last Line Mode                use : to iniate, then run command.\n";

printf "\n${lsvimBLUE}Navigation:${lsvimNC}                 \n";
printf " h                             moves the cursor one character to the left\n";
printf " j                             moves the cursor down one line\n";
printf " k                             moves the cursor up one line\n";
printf " l                             moves the cursor one character to the right\n";
printf " 0                             moves the cursor to the beginning of the line\n";
printf " $                             moves the cursor to the end of the line\n";
printf " ^                             moves the cursor to the first non empty character of the line\n";
printf " w                             move forward one word (next alphanumeric word)\n";
printf " W                             move forward one word (delimited by a white space)\n";
printf " 5w                            move forward five words\n";
printf " b                             move backward one word (previous alphanumeric word)\n";
printf " B                             move backward one word (delimited by a white space)\n";
printf " 5b                            move backward five words\n";
printf " G                             move to the end of the file\n";
printf " gg                            move to the beginning of the file\n";
printf " (                             jumps to the previous sentence\n";
printf " )                             jumps to the next sentence\n";
printf " {                             jumps to the previous paragraph\n";
printf " }                             jumps to the next paragraph\n";
printf " [[                            jumps to the previous section\n";
printf " ]]                            jumps to the next section\n";
printf " []                            jump to the end of the previous section\n";
printf " ][                            jump to the end of the next section\n";

printf "\n${lsvimBLUE}Insertion:${lsvimNC}                  \n";
printf " a                             insert text after the cursor\n";
printf " A                             insert text at the end of the line\n";
printf " i                             insert text before the cursor\n";
printf " o                             begin a new line below the cursor\n";
printf " O                             begin a new line above the cursor\n";
printf " :r [filename]                 insert the file [filename] below the cursor\n";
printf " :r ![command]                 execute [command] and insert its output below the cursor\n";

printf "\n${lsvimBLUE}Deletion:${lsvimNC}                   \n";
printf " x                             delete character at cursor\n";
printf " dw                            delete a word\n";
printf " d0                            delete to the beginning of a line\n";
printf " d$                            delete to the end of a line\n";
printf " d)                            delete to the end of sentence\n";
printf " dgg                           delete to the beginning of the file\n";
printf " dG                            delete to the end of the file\n";
printf " dd                            delete line\n";
printf " 3dd                           delete three lines\n";

printf "\n${lsvimBLUE}Copy/Paste:${lsvimNC}                 \n";
printf " yy                            copy current line into storage buffer\n";
printf " [\"x]yy                        copy the current lines into register x\n";
printf " p                             paste storage buffer after current line\n";
printf " P                             paste storage buffer before current line\n";
printf " [\"x]p                         paste from register x after current line\n";
printf " [\"X]P                         paste from register x before current line\n";

printf "\n${lsvimBLUE}Undo/Redo:${lsvimNC}                  \n";
printf " u                             undo the last operation\n";
printf " CTRL+r                        redo the last undo\n";

printf "\n${lsvimBLUE}Search & Replacement:${lsvimNC}       \n";
printf " r{text}                       replace the character under the cursor with {text}\n";
printf " R                             replace characters instead of inserting them\n";
printf " /search_text                  search document for search_text going forward\n";
printf " ?search_text                  search document for search_text going backward\n";
printf " n                             move to the next instance of the result from the search\n";
printf " N                             move to the previous instance of the result\n";
printf "\%\s/original/replacement        search for the first occurrence of the string 'original' and replace it with 'replacement'\n";
printf "\%\s/original/replacement/g      search and replace all occurrences of the string 'original' with 'replacement'\n";
printf "\%\s/original/replacement/gc     search for all occurrences of the string 'original' but ask for confirmation before replacing them with 'replacement'\n";

printf "\n${lsvimBLUE}Bookmarks:${lsvimNC}                  \n";
printf " m {a z A Z}                   set bookmark {a z A Z} at the current cursor position\n";
printf " :marks                        list all bookmarks\n";
printf " \`{a z A Z}                    jumps to the bookmark {a z A Z}\n";

printf "\n${lsvimBLUE}Select Text:${lsvimNC}                \n";
printf " v                             enter visual mode per character\n";
printf " V                             enter visual mode per line\n";
printf " Esc                           exit visual mode\n";

printf "\n${lsvimBLUE}Modify Selected Text:${lsvimNC}       \n";
printf " ~                             switch case\n";
printf " d                             delete a word\n";
printf " c                             change\n";
printf " y                             yank\n";
printf " >                             shift right\n";
printf " <                             shift left\n";
printf " !                             filter through an external command\n";

printf "\n${lsvimBLUE}Save & Quit:${lsvimNC}                \n";
printf " :q                            quits Vim but fails when file has been changed\n";
printf " :w                            save the file\n";
printf " :w new_name                   save the file with the new_name filename\n";
printf " :wq                           save the file and quit Vim\n";
printf " q!                            quit Vim without saving the changes to the file\n";
printf " ZZ                            write file, if modified, and quit Vim\n";
printf " ZQ                            same as :q! quits Vim without writing changes\n";

    fi
}
