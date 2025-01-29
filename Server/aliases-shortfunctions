

alias ..='cd ..'
alias ls='ls $LS_OPTS'
alias ll='ls $LS_OPTS -la'
alias l='ls $LS_OPTS -l'
alias grep='grep --color=auto'
alias bzip2='bzip2 --keep'
alias less='less -R -S -#2'
alias rmr='rm -r -I'
alias cpr='cp -r'
alias date='date -R'
alias colorless='ccze -A|less'
alias cl='colorless'
alias last='last -a|ccze -A'
alias syslog="tail -F /var/log/syslog|ccze -A"
alias sl="syslog"
alias ns="netstat --numeric-ports --numeric-hosts -atep|ccze -A"
alias tf='tail -F'
alias mcedit='mcedit -x'
alias me='mcedit'
alias diff='colordiff -y'
alias wget='wget -c'
alias rsync='rsync -ravz'
alias rsyncssh='rsync -e ssh'
alias lsmount='mount|sort|column -t|ccze -A'
alias update='sudo aptitude update && sudo aptitude upgrade'
alias nocomment='grep -Ev '\''^(#|$)'\'''
alias hg='history|grep '
alias tree='tree -C'
alias userinfo='getent passwd|column  -t -s: -n'
alias groupinfo='getent group|column  -t -s: -n'
alias ll="ls -lah"
alias thetime="date +'%r %a %d %h %y (Julian Date: %j)'"
alias weather='curl wttr.in/Austin+USA'
alias myip='curl ipinfo.io/ip'
alias myip2="curl icanhazip.com"
alias map='telnet mapscii.me'
alias joke='curl https://icanhazdadjoke.com;echo'
alias starwars='nc towel.blinkenlights.nl 23'
alias parrot='curl parrot.live;clear'
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
alias plz="fc -l -1 | cut -d' ' -f2- | xargs sudo"
alias ports="netstat -tulpn"
alias space="df -h"
alias used="du -ch -d 1"


# PS1
if [ $(/usr/bin/whoami) = 'root' ]; then
    PS1="${yellow}\u@\h${white}:${norm}\w${norm}${lred}#${norm} "
else
    PS1="${yellow}\u@\h${white}:${norm}\w${norm}\$ "
fi


dict() { curl 'dict://dict.org/d:'"$@" }



incognito() {
  case $1 in
	start)
	set +o history;;
	stop)
	set -o history;;
	*)
	echo -e "USAGE: incognito start - disable command history.
   	incognito stop  - enable command history.";;
  esac
}
