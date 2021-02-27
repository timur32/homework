#!/usr/bin/env bash

curl -s https://yandex.ru/news/quotes/graph_2000.json > ./quotes.json


if [ -r quotes.json ]
then
  echo "Mean for last 14 days:" $(jq '.prices[][1]' quotes.json | tail -n 14 | awk -v mean=0 '{mean+=$1} END {print mean/14}')

  for year in {2015..2020}
  do
    jqreq=$(jq --arg Y $year --arg M "03" -r '.prices[][0] |= (. / 1000 | strftime("%Y%m")) | .prices[] | select(.[] == $Y+$M)| .[1]' quotes.json)
    min=$( echo "$jqreq" | sort | head -n1)
    max=$( echo "$jqreq" | sort | tail -n1)
    mean=$( echo "$jqreq" | awk -v mean=0 '{mean+=$1} END {print mean/NR}')
    volatile+=$( awk -v mean="$mean" -v min="$min" -v max="$max" -v year="$year" 'BEGIN{print year ,((mean-min)+(mean+max))/2,"|"}' )   
    printf 'Year:%5s Min:%10s  Max:%10s  Mean:%10s\n' $year $min $max $mean
  done
    echo -ne "\nMinimal volatile: "
    printf '%s\n' "${volatile[@]}" | sed 's@|@\n@g' | sort -nk 2 | head -n 2
else
  echo "File quotes.json not exists"
  exit
fi
