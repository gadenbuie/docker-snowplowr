# snowflake + tidyverse + RStudio in docker

## Run

```
docker run -d --rm -p 6789:8787 -e PASSWORD="YOUR_PASSWORD" grrrck/snowplowr
```

Then navigate to `localhost:6789` and login as user `rstudio` with password `YOUR_PASSWORD`.

If you want to use a different report, change `6789` for another port number.

Oh, and use a better password, but remember it's just to login to the RStudio instance in the docker container.

## `.odbc.ini`

Create a new text file and save it as `.odbc.ini` in the home directory, most likely `/home/rstudio`.

Copy the lines below and update accordingly.

```
[snowflake]
Driver = SnowflakeDSIIDriver
Server = SNOWFLAKE_ACCOUNT_SUBDOMAIN.snowflakecomputing.com
UID = USER
PWD = PASSWORD
role = sysadmin
warehouse = USER_WAREHOUSE
database = DEFAULT_DATABASE
```

Note that you don't nede to include `role`, `warehouse` or `database`, but would need to run the required SNOW SQL to configure correctly.

## Connect

```r
library(DBI)
library(dplyr)
library(dbplyr)
library(odbc)

snow_con <- dbConnect(odbc(), "snowflake")
```

## Access tables

If you haven't used a database, include the DATABASE and SCHEMA in `dbplyr::in_schema("DATABASE.SCHEMA", "TABLE")`.

```r
tbl(snow_con, in_schema("SNOWFLAKE_SAMPLE_DATA.TPCH_SF10", "ORDERS")) %>% 
  count(O_ORDERSTATUS, O_ORDERPRIORITY) %>% 
  arrange(O_ORDERSTATUS, O_ORDERPRIORITY)

#> # Source:     lazy query [?? x 3]
#> # Database:   Snowflake 4.31.3[lion@Snowflake/]
#> # Groups:     O_ORDERSTATUS
#> # Ordered by: O_ORDERSTATUS, O_ORDERPRIORITY
#>    O_ORDERSTATUS O_ORDERPRIORITY       n
#>    <chr>         <chr>             <dbl>
#>  1 F             1-URGENT        1462766
#>  2 F             2-HIGH          1461800
#>  3 F             3-MEDIUM        1462276
#>  4 F             4-NOT SPECIFIED 1461756
#>  5 F             5-LOW           1460586
#>  6 O             1-URGENT        1464013
#>  7 O             2-HIGH          1461240
#>  8 O             3-MEDIUM        1459703
#>  9 O             4-NOT SPECIFIED 1461850
#> 10 O             5-LOW           1460658
#> # … with more rows
```
