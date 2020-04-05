#!/bin/bash

#add the local virtual Address
#add the range virtual Address
#get the net card

var=""
number="2"
par=""
i=0
rpar=""
flag=0

while [ -n "$1" ]
do
    case "$1" in
    #set the local ip address
    "-l") par=$2
        number=$((RANDOM%254+1)) #GET THE RANDOM NUMBER
        while true
        do
            if [ ${number} -eq ${par:10} ]
            then
                ${number}=$[$RANDOM%254+1]
            else
            break
            fi
        done    

        echo "### Add the local virtual address is ${par:0:9}.${number}/24 ###"  
        par="${par:0:9}.${number}/24" 
        shift ;;

    #set the range ip address
    "-r") while [ ${i} -lt 4 ]
        do
            number=$((RANDOM%254+1)) #GET THE RANDOM NUMBER
            if [ -z ${rpar} ]
            then 
                rpar=${number}
            else
                rpar=${rpar}".${number}"
            fi
            let i++
        done    

        echo "### Add the range virtual address is ${rpar}/24 ###" 
        rpar="${rpar}/24" ;;

    #set the network card 
    "-c") var=$2
          shift ;;

    #del the virtual ip address
    "-d") par=$2
          /sbin/ip addr del ${par}/32 dev ${var}
          break ;;
    
    "-version") echo "Virtual Address version "1.0.0" 2020-03-17"  
                break | exit ;;
    "-restart") service network restart
                break ;;
    "-h") echo 
        echo "Base The Options: "
        #show the method how to use it
        echo "-l add the local ip address,such as -l 192.168.0.100"
        echo "-r add the range ip address,such as -r"
        echo "-c add the network card,such as ens33"
        echo "-d remove the virtual ip address,must use the last,such as -d 192.168.0.100"
        echo
        echo "Help Options: "
        echo "-h show the how to use the command" 
        echo "-v show the virtual ip address version"
        echo "-- end the operations"
        echo
        echo "Look at the local ip Addresss"
        
        shift   
        break ;;

    "--") shift
        break | exit;;

    *) echo "### Not found the command ###"  
       flag=-1 #change the statue code
       break | exit ;; 
    esac
    shift

    #add the virtual ip address
    #-z is mean ${par} is empty
    if [ -z ${rpar} ]
    then
        ip addr add ${par} dev ${var}
    else
        echo "${rpar}"
        ip addr add ${rpar} dev ${var}
    fi
done

#judge the successful code
if [ $? -ne 0 ]
then #error
    if [ ${flag} -eq "-1" ]
    then
        echo "### Error Operation ###"
    fi
else #success
    echo "### Successful ###"
    ip add
fi