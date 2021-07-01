create schema minio.sample_schema;

use minio.sample_schema;

CREATE TABLE minio.sample_schema.sample_table(
             ->    combined_columns VARCHAR)
             -> WITH (
             ->   external_location = 's3a://customer-data-text/',
             ->   format = 'TEXTFILE',
             ->   skip_header_line_count=1);

CREATE TABLE minio.sample_schema.sample_table2(
             ->    id int, name VARCHAR, joined_at date)
             -> WITH (
             ->   external_location = 's3a://raw/',
             ->   format = 'PARQUET' );

-- Requires writable hive non-managed external tables. # hive.non-managed-table-writes-enabled=true
insert into minio.sample_schema.sample_table2(id, name, joined_at) values (1, 'Peter', now());             

-- Requires azure config in minio.properties
CREATE  TABLE date (
    DATEID DATE,
    DATE DATE,
    DATEDESCRIPTION VARCHAR(30),
    YEAR decimal(38,0),
    HALFYEAR decimal(38,0),
    HALFYEARNAME VARCHAR(100),
    QUARTER decimal(38,0),
    QUARTERNAME VARCHAR(100),
    MONTH decimal(38,0),
    MONTHNAME VARCHAR(100),
    WEEK decimal(38,0),
    DAY decimal(38,0),
    YEARQUARTER VARCHAR(100),
    YEARMONTH VARCHAR(100),
    YEARWEEK VARCHAR(100),
    DAYINMONTH decimal(38,0),
    DAYINWEEK decimal(38,0),
    DAYINWEEKNAME VARCHAR(100),
    ISLASTDAYINMONTH VARCHAR(100),
    STARTDATEINWEEK DATE,
    ENDDATEINWEEK DATE,
    ISLASTDAYINWEEK VARCHAR(100),
    SEASONNAME VARCHAR(100),
    ISPUBLICHOLIDAY VARCHAR(100),
    ISWEEKDAY VARCHAR(100),
    PREVIOUSMONTHLASTDATE DATE,
    NATURALKEY VARCHAR(100) ,
    LGEXE_ID decimal(38,0)
)   WITH (external_location = 'wasbs://raw@peterhlake.blob.core.windows.net/out/EDW_CF_POC/DIM_DATE/', format = 'parquet');