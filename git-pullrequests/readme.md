## Script use githab api, gets open pull-requests and their authors

### Example 1
```bash
$ ./script_git.sh https://github.com/angular/angular-cli
Opened PRs: 35

---Top contributors:---
5 clydin
4 renovate[bot]
3 alan-agius4
2 filipesilva
2 djencks

---Opened PRs with labels:---
5 clydin
4 renovate[bot]
3 alan-agius4
2 filipesilva
2 djencks
1 vltansky
1 spenceryue
1 santoshyadavdev
1 sacgrover
1 petebacondarwin
1 moczix
1 manekinekko
1 laurentgoudet
...
```
### Example 2
```bash
$ ./script_git.sh https://github.com/pi-hole/pi-hole 63a93171d4bd39856caac6c42a13141225725bf
Opened PRs: 20

---Top contributors:---
3 PromoFaux
2 jlagermann
2 andras-tim

---Opened PRs with labels:---
1 pemensik
1 jlagermann
1 CrAlMo
1 corbolais
```

## Script description

First IF-block checks existence of url-argument.

Second IF-block checks existence 2nd argument that contain user-token.

Parse argument for get user and repository

Check existence of specified repository

Make temporary file for collect data from all pages.

Get number of response pages use curl -I

Function request() that collect data to temp file

Cycle call function request() for each pages

Count opened PRS in specified repository

Print authors of more than 1 open PRs

Print number of PRs with labels

Delete temporary file
