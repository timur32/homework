#!/usr/bin/env bash

#function for print help
help() {
 cat <<EOF

Script will show established network connection or listening processes
[-h] [-l] [-s] -p process -n number

 -h  Print help
 -p  Specify process name by pid or name
     Example: -p firefox
 -n  Specify number of summary results
     Example: -n 10
 -s  Use sudo
 -l  Show listening processes

  Example: ./script.sh -p firefox -n 10
  Example: ./script.sh -p sshd -l

EOF
exit
}

#cycle for catch parameters
while [ -n "$1" ]
do
  case "$1" in
    -p) proc=$(echo "$2" | awk '{print tolower($0)}')
        flag+="o"
      shift ;;
    -n) results="$2"
	flag+="o"
      shift ;;
    -h) help ;;
    -s) sudo="sudo " ;;
    -l) flag+="l";;
     *) echo "$1 is not an option";;
  esac
  shift
done

#main function
getConnections () {
  # check minimal requirements varible
 if [ -z "${sudo}" ]
  then
    echo "  You didn't use argument -s SUDO. Without sudo you can't see all connections"
    sudo=''
  fi 
  if [ -z "${proc}" ]
  then
    echo "  You didnt enter PID or name. By default will be show all connections"
    proc=''
  fi
  if ! [[  "${results}" =~ ^[0-9]+$ ]]
  then
    echo "  You didnt enter number of results. Default number - 5"
    results=5
  fi


  #if varible contains flag o (organization) then use whois
  if [[ ${flag} =~ "o" ]]
  then
    echo "  Count Organization"
    requestIP=$(${sudo} netstat -tunp 2> /dev/null | awk -v proc=$proc '/'$proc'/ {print $5}' | cut -d: -f1)
    for ip in $requestIP
    do
      summ+=($(whois $ip | awk -F':' 'BEGIN{ORS="|"} /^OrgName/ {print $2;exit;}' ))
    done
    printf '%s' "${summ[@]}" | sed 's@|@\n@g' | sort | uniq -c | tail -n$results
  fi

  #if varible contains flag l (listen) then show listening process
  if [[ ${flag} =~ "l" ]]
  then
    echo "  Listening sockets"
    ${sudo} netstat -tunpl 2> /dev/null | awk -v proc=$proc '/'$proc'/ && /LISTEN/ {printf "%10s %10s %10s\n", $1,$4,$7}'| tail -n$results
  fi
  exit
}

#Call main function depend on flag
if [[ $flag =~ ([ol]) ]]
then
   getConnections
else
   help
fi

