Script gets currency history and do something

Download currency rates from yandex and save to file

IF-block check source file for existence and reading
IF true:
  First, get data from file and calculate average currency for last 14 days.

  Next cycle FOR, that put varible year in json-request.
  JQ-request filter currency by year and month.
  Get min and max number by sortering.
  Calculate average number.
  Calculate volatile and collect them to string for analysis.
  Print min max and mean for each year.
  
  Print min volatile in March
IF false:
  exit
