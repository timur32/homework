#!/usr/bin/env bash

url="https://yandex.ru/news/quotes/graph_2000.json"
#Check HTTP 
checkurl=$(curl -o /dev/null -Isw '%{http_code}' $url)
if [[ $checkurl == 200 ]]
then
  curl -s $url > ./quotes.json 
else
  echo "Bad link to file. Please check $url HTTP-code: $checkurl"
  exit
fi

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
  echo -e "\nMean for last 14 days:" $(jq '.prices[][1]' quotes.json | tail -n 14 |\
	   awk -v mean=0 '{mean+=$1} END {print mean/14}')"\n"
  
  #Get min and max avalible year in file quotes.json
  yearreq=$(jq -r '.prices[][0] |= (. / 1000 | strftime("%Y")) | .prices[] | .[0]' quotes.json)
  minyear=$(echo "${yearreq[@]}"| head -n1)
  maxyear=$(echo "${yearreq[@]}"| tail -n1)

  for year in $(seq $minyear $maxyear)
  do
    #Get rates for specified month and year
    jqreq=$(jq --arg Y $year --arg M $month -r '.prices[][0] |= (. / 1000 | strftime("%Y%m")) |
	                                        .prices[] | select(.[] == $Y+$M)| .[1]' quotes.json)
    #search min max rate and calculate volatile
    results+=$(echo "$jqreq" | awk -v year="$year" \
                               '{if (min=="") {min=$1; max=$1}; if($1>max) {max=$1}; if($1<min) {min=$1}} \
	                        END { if (min!="") {printf "Year:%5s Min:%10s Max:%10s Volatile:%10s |",\
			       	year, min, max, (max-min)/2}}')
  done
  #Print results collected in cycle above
  printf '%s\n' "${results[@]}"  | sed 's@|@\n@g'
  #Search min volatile and print it
  printf '%s' "${results[@]}" | awk 'BEGIN {RS="|"} \
                                {if (min=="") {min=$8;year=$2};if($8<min) {min=$8;year=$2}} \
				END {printf "Minimal volatile in %s = %s\n",year,min}'
else
  echo "File quotes.json not exists"
  exit
fi
