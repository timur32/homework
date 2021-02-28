## Script gets currency history from yandex, calculate volatile and etc.
### Usage:
  volatility.sh <Number of month>

### Example: Calculate volatile for February
````bash
$ ./volatility.sh 2

Calculate results for February.

Mean for last 14 days: 89.6257

Year: 2014 Min:         0  Max:            Mean:          
Year: 2015 Min:     68.61  Max:    77.515  Mean:   72.8649
Year: 2016 Min:     81.84  Max:    90.269  Mean:   85.8178
Year: 2017 Min:      60.4  Max:     64.76  Mean:   62.1779
Year: 2018 Min:   68.5725  Max:    71.505  Mean:   70.2216
Year: 2019 Min:     74.09  Max:    75.275  Mean:    74.729
Year: 2020 Min:      68.7  Max:     73.82  Mean:   69.9228
Year: 2021 Min:     88.77  Max:    91.785  Mean:   89.9739

Year Volatile
2015 77.3174 
2016 90.0323 
2017 64.3579 
2018 71.6878 
2019 75.3215 
2020 72.4828 
2021 91.4814 

Minimal volatile: 
2017 64.3579 
````
## Script description
Download currency rates from yandex and save to file

Set previous month by default

IF-block checks if entered number of month is correct

IF-block check source file for existence and reading
IF true:
  First, get data from file and calculate average currency for last 14 days.
  Get min and max year in downloaded file from yandex.

  Next cycle FOR, that put varible year in json-request.
  JQ-request filter currency by year and month.
  Get min and max number by sortering.
  Calculate average number.
  Calculate volatile and collect them to string for analysis.
  Print min max and mean for each year.
  
  Print volatile in each year.
  Print min volatile in specified month.
IF false:
  exit
