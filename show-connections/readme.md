## Script show information about current network activities.

### Example 1: Show Firefox connections
```bash
$./script.sh -p firefox -n 10
  Count Organization
      1 Amazon.com,Inc.
     11 AmazonTechnologiesInc.
      1 ANSCommunications,Inc
      3 GitHub,Inc.
     14 GoogleLLC
      1 MCICommunicationsServices,Inc.d/b/aVerizonBusiness
      3 TwitterInc.
```
### Example 2: Show listening processes
```bash
./script.sh  -l -s
Listening sockets
       tcp 0.0.0.0:22   467/sshd
      tcp6      :::22   467/sshd
```
## Description script
First function is help() print help message.
It can be call by -p parameter.
help() call automatically if you run script without any parameters.
 -h  Print help
 -p  Specify process name by pid or name
 -n  Specify number of summary results
 -l  Show listening processes

Next cycle WHILE that catch parameters from positional parameters.
CASE operator catch keys -p | -n | -h | -l and their parameters.

Inputed data collecting in varibles:
  proc - Name or PID of process. It convert to lowercase.
  results - Number of summary results
  flag - collect things to do in next function

Next function getConnections():

First operator IF check existing varible proc.
If proc not defined, define it like empty string.
Second operator IF check results by regexp.
If results not exists or consist letters, define it equal 5.

Next two IF-blocks checks "marks" in varible flag.
If exist "o" (organization), do request orgname by ip use whois.

Run NETSTAT, transmit data to AWK. AWK choose lines consist proc and
transmit ip:port to CUT, which cuts only IP-address.
Got destination IPs and send in cycle.
Cycle calls WHOIS for each IP, gets their OrgName and collect to array SUMM.
Print array SUMM, sort them, filter repeating lines and count them.

If exist "l" (listen), show processes that are in state of LISTEN
Run NETSTAT, transmit data to AWK. AWK choose lines consist proc and LISTEN.

Last IF condition check varible flag.
If flag consist "o" or "l", call main function getConnections.
Else call function help.

