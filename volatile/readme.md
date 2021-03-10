## Script gets currency history from yandex, calculate volatile and etc.
### Usage:
  volatility.sh \<Number of month\>

### Example: Calculate volatile for February
````bash
$ ./volatility.sh 2

Calculate results for February.

Mean for last 14 days: 89.377

Year: 2015 Min:     68.61 Max:    77.515 Volatile:    4.4525 
Year: 2016 Min:     81.84 Max:    90.269 Volatile:    4.2145 
Year: 2017 Min:      60.4 Max:     64.76 Volatile:      2.18 
Year: 2018 Min:   68.5725 Max:    71.505 Volatile:   1.46625 
Year: 2019 Min:     74.09 Max:    75.275 Volatile:    0.5925 
Year: 2020 Min:      68.7 Max:     73.82 Volatile:      2.56 
Year: 2021 Min:     88.77 Max:    91.785 Volatile:    1.5075 

Minimal volatile in 2019 = 0.5925
````
## Script description
IF-block checks download rates-files
   Download currency rates from yandex and save to file

Set previous month by default

IF-block checks if entered number of month is correct

IF-block check source file for existence and reading
IF true:
  First, get data from file and calculate average currency for last 14 days.
  Get min and max year in downloaded file from yandex.

  Next cycle FOR, that put varible year in json-request.
  JQ-request filter currency by year and month.
  Calculate min, max, volatile and collect them to string for analysis.

  Print min max and volatile for each year.
  
  Print MIN volatile of specified month of all years.
IF false:
  exit
