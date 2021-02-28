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
    min=$( echo "$jqreq" | sort | head -n1)
    max=$( echo "$jqreq" | sort | tail -n1)
    mean=$( echo "$jqreq" | awk -v mean=0 '{mean+=$1} END {print mean/NR}')
    volatile+=$( awk -v mean="$mean" -v min="$min" -v max="$max" -v year="$year" 'BEGIN{if (mean>0) print year ,((mean-min)+(mean+max))/2,"|"}' )   
    printf 'Year:%5s Min:%10s  Max:%10s  Mean:%10s\n' $year $min $max $mean
  done
    printf "\nYear Volatile\n"
    printf '%s\n' "${volatile[@]}"  | sed 's@|@\n@g'
    printf "Minimal volatile: "
    printf '%s\n' "${volatile[@]}" | sed 's@|@\n@g' | sort -nk 2 | head -n 2
else
  echo "File quotes.json not exists"
  exit
fi
