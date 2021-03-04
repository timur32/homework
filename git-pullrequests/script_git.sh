#!/usr/bin/env bash

if [ -z "$1" ]
then
  echo "  You didnt enter github URL. You must run script with argument."
  echo "  Example: ./script_git.sh https://github.com/user/repository"
  exit
fi

#parse url for get user and repository
userrep=$(echo $1 | sed -e's@^http[s]\?://github.com/@@g')
user=$(echo $userrep | awk -F"/" '{print $1}')
repo=$(echo $userrep | awk -F"/" '{print $2}')

#Check HTTP response
checkrepo=$(curl -o /dev/null -Isw '%{http_code}' https://api.github.com/repos/$user/$repo)
if ! [[ $checkrepo == 200 ]]
then
  echo "You entered URL to non-existent repository! HTTP-code: $checkrepo"
  exit
fi

#Make temporary file
temp=$(basename $0)
TMPFILE=$(mktemp /tmp/${temp}.XXXXXX) || exit 1

#Get number of pages that api will give
head="Accept: application/vnd.github.v3+json" 
pages=$(curl -s -I -H $head https://api.github.com/repos/$user/$repo/pulls?state=open | grep '^link:' | sed -e 's@^link:.*page=@@g' -e 's@>.*$@@g')

#Data from each page collect to temp file
function request {
  echo -n $(curl -sH $head https://api.github.com/repos/$user/$repo/pulls?page="$1"&state=open) >> $TMPFILE
}

#Request each page api-response
if [ -z "$pages" ]
then
  request "1"
else
for p in $(seq 1 $pages)
  do
    request "$p"
  done
sed -i 's@\]\[@,@g' $TMPFILE
fi
srcfile=$(cat $TMPFILE | jq '')

#Count how many PRs
openedPRs=$(echo $srcfile | jq '[.[] | if has ("title") then 1 else 0 end ]  | add')
echo "Opened PRs:" $openedPRs

#Print authors of more than 1 open PRs
printf "\n---Top contributors:---\n"
echo $srcfile | jq -r '.[].user.login' | sort | uniq -c | sort -r | awk '{if ($1>1) printf "%s %s\n",$1,$2}'

#Print number of PRs with labels
printf "\n---Opened PRs with labels:---\n"
echo $srcfile | jq -r '.[] | select (.labels | length > 0 ) | .user.login' | sort | uniq -c | sort -r |\
       	awk '{printf "%s %s\n",$1,$2}'

rm $TMPFILE
exit
