#!/bin/bash


# Aliases for quicker use
alias j="jump"
alias mj="mjump"
alias mmj="mmail"
alias jt="jtunnel"

# Variables

jumpuser="jellis"


function jump () {

	if [[ -z $1 ]]; then
		ssh ${jumpuser}@unix.codero.com
	elif [[ -n $1 && -z $2 ]]; then
		ssh -t -o ProxyCommand="ssh ${jumpuser}@unix.codero.com nc $1 22" root@$1
	elif [[ -n $1 && -n $2 ]]; then
		ssh -t -o ProxyCommand="ssh ${jumpuser}@unix.codero.com nc $1 $2" root@$1
	else
		echo -e '\nSyntax Error'
	fi
}


function mjump () {

        if [[ -z $1 ]]; then
                ssh ${jumpuser}@managed.codero.com
        elif [[ -n $1 && -z $2 ]]; then
                ssh -t -o ProxyCommand="ssh ${jumpuser}@managed.codero.com nc $1 22" root@$1
        elif [[ -n $1 && -n $2 ]]; then
                ssh -t -o ProxyCommand="ssh ${jumpuser}@managed.codero.com nc $1 $2" root@$1
        else
                echo -e '\nSyntax Error'
        fi
}


function mmail () {

# Note you will need public key added to server
	if [[ -z $1 ]]; then
		ssh root@coderomail.com
	else
		echo -e '\nSyntax Error'
	fi
}


function jtunnel () {

	if [[ -z $1 ]]; then
		echo -e '\nUsage:\njtunnel <-u|-m> <local-port> <bind-port> [host] [port]\n\nFlags:\n-u = unix.codero.com\n-m = managed.codero.com\n\n<required>\n[optional]'

	elif [[ $1 == '-u' || $1 == '-m' && -z $2 ]]; then
		echo -e '\nSpecify <local-port> and <bind-port>'
                echo -e '\nUsage:\njtunnel <-u|-m> <local-port> <bind-port> [host] [port]\n\nFlags:\n-u = unix.codero.com\n-m = managed.codero.com\n\n<required>\n[optional]'	
	
	elif [[ $1 == '-u' || $1 == '-m' && -n $2 && -z $3 ]]; then
                echo -e '\nSpecify <bind-port>'  
		echo -e '\nUsage:\njtunnel <-u|-m> <local-port> <bind-port> [host] [port]\n\nFlags:\n-u = unix.codero.com\n-m = managed.codero.com\n\n<required>\n[optional]'

	elif [[ $1 == '-u' && -n $2 && -n $3 && -z $4 ]]; then
		#lets tunnel just unix.codero.com
	        ssh -L ${2}:localhost:${3} ${jumpuser}@unix.codero.com

	elif [[ $1 == '-u' && -n $2 && -n $3 && -n $4 && -z $5 ]]; then
		#lets tunnel through unix jbox to customers box on default 22
		ssh -t -o ProxyCommand="ssh -L ${2}:localhost:${3} ${jumpuser}@unix.codero.com nc $4 22" root@$4

        elif [[ $1 == '-u' && -n $2 && -n $3 && -n $4 && -n $5 ]]; then
                #lets tunnel through unix jbox to customers box on custom ssh port
                ssh -t -o ProxyCommand="ssh -L ${2}:localhost:${3} ${jumpuser}@unix.codero.com nc $4 $5" root@$4
	
        elif [[ $1 == '-m' && -n $2 && -n $3 && -z $4 ]]; then
                #lets tunnel just managed.codero.com
                ssh -L ${2}:localhost:${3} ${jumpuser}@managed.codero.com

        elif [[ $1 == '-m' && -n $2 && -n $3 && -n $4 && -z $5 ]]; then
                #lets tunnel through managed jbox to customers box on default 22
                ssh -t -o ProxyCommand="ssh -L ${2}:localhost:${3} ${jumpuser}@managed.codero.com nc $4 22" root@$4

        elif [[ $1 == '-m' && -n $2 && -n $3 && -n $4 && -n $5 ]]; then
                #lets tunnel through managed jbox to customers box on custom ssh port
                ssh -t -o ProxyCommand="ssh -L ${2}:localhost:${3} ${jumpuser}@managed.codero.com nc $4 $5" root@$4

	else
                echo -e '\nSyntax Error'
	fi
		
}


