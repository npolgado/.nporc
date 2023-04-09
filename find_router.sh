#!/bin/bash
network=192.168.1.1/24
if [ "$#" -ne 1 ]; then echo Usage example: $0 aa:bb:cc:dd:ee:ff; exit 2; fi;
nmap -sP -T4 $network >& /dev/null
ip=$(arp -n | grep $1 | awk ' { print $1 }')
ping $ip -n -q -c 2 -i 0.2 -w 1 >& /dev/null
if [ $? -eq 0 ]; then
    echo Device is online \($ip\)
else
    echo Device is offline
    exit 1
fi;
