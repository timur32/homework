#!/usr/bin/env bash

#curl -s https://yandex.ru/news/quotes/graph_2000.json > ./quotes.json

#set previous month by default
month=$(date +%m -d '1 month ago')

#Check requirements for enter correct month
if [ -z "$1" ] || ! [[ "$1" =~ ^[0-9]*$ ]] || [ "$1" -gt 12 ] || [ "$1" -lt 1 ]
then
  echo -e "\nYou must enter correct number of Month. Default result will generate for $(date -d "$month/01" +%B)."
  echo "Example: ./volatility.sh 03" 
  echo -e "Example: ./volatility.sh 5"
elif [[ "$1" =~ ^[0-9]+$ ]]
then
  if [[ "$1" =~ ^[0-9]$ ]]
  then
    month=0$1
  else
    month=$1
  fi
  echo -e "\nCalculate results for $(date -d "$month/01" +%B)".
else
  exit
fi

if [ -r quotes.json ]
then
  #Calculate mean rate for last 2 weeks
  echo -e "\nMean for last 14 days:" $(jq '.prices[][1]' quotes.json | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}')"\n"
  
  #Get min and max avalible year in file quotes.json
  yearreq=$(jq -r '.prices[][0] |= (. / 1000 | strftime("%Y")) | .prices[] | .[0]' quotes.json)
  minyear=$(echo "${yearreq[@]}"| head -n1)
  maxyear=$(echo "${yearreq[@]}"| tail -n1)

  for year in $(seq $minyear $maxyear)
  do
    jqreq=$(jq --arg Y $year --arg M $month -r '.prices[][0] |= (. / 1000 | strftime("%Y%m")) | .prices[] | select(.[] == $Y+$M)| .[1]' quotes.json)
    results+=$(echo "$jqreq" | awk -v year="$year" \
                               '{if (min=="") {min=$1; max=$1}; if($1>max) {max=$1}; if($1<min) {min=$1}} \
	                        END { if (min!="") {printf "Year:%5s Min:%10s Max:%10s Volatile:%10s |",\
			       	year, min, max, (max-min)/2}}')
  done
  printf '%s\n' "${results[@]}"  | sed 's@|@\n@g'
#     printf "Minimal volatile: \n"
printf '%s\n' "${results[@]}" | awk 'BEGIN {RS="|"} {{print $8};{if (min=="") {min=$8};if($8<min) {min=$8}} } END {print min}'
else
  echo "File quotes.json not exists"
  exit
fi
