#!/bin/bash
 
### database schema
dataset_path=/home/dc/
cd ${dataset_path}
read TESTDBSCHEMA XCUSDILSCHEMA TESTDBTESTDBUSR TESTDBTESTDBPWD MFXCUSUSR MFXCUSPWD DATAHDB MAINFIP TESTDBIP < ./shellscript/config/CONF.TXT
database=$DATAHDB
user=$TESTDBTESTDBUSR
password=$TESTDBTESTDBPWD
schema=$XCUSDILSCHEMA
 
table=TESTTABLE
 
### script name
script_name=`basename $0`
script_path=`dirname $0`
 
execution started at " $(date "+%Y-%m-%d %H:%M:%S")
 
###datasets
 
dataset=`ls -1t ${dataset_path}TESTUNLOAD.DATA | head -1`
 
echo "................................Source file  = " ${dataset}
 
if [ ! -f "$dataset" ]
then
echo "execution stopped at " $(date "+%Y-%m-%d %H:%M:%S")
exit 100
fi 
 

export LANG=en_EN
 
### open database connection
db2 -m "TERMINATE"
 
if [ $? -gt 2 ]                                            #db2_error_code (0: success, 1: 0 rows selected, 2: warning, 4: DB2 or SQL error, 8: system error)
then
echo "execution stopped at " $(date "+%Y-%m-%d %H:%M:%S")
exit 99
fi
 
db2 -m "CONNECT TO ${database} USER ${user} USING ${password}"
 
if [ $? -gt 2 ]                                            #db2_error_code (0: success, 1: 0 rows selected, 2: warning, 4: DB2 or SQL error, 8: system error)
then
echo "execution stopped at " $(date "+%Y-%m-%d %H:%M:%S")
exit 99
fi
 
echo "connected to Database at " $(date "+%Y-%m-%d %H:%M:%S")
 
db2 "INGEST SET commit_count 10000"
db2 "INGEST SET commit_period 0"
 
echo "Ingesting ${schema}.${table} table started at " $(date "+%Y-%m-%d %H:%M:%S")
 
db2 -m "INGEST FROM FILE '${dataset}' FORMAT DELIMITED BY ','
      (
 
 
\$TESTTBL_IP_ID INTEGER EXTERNAL,
\$TESTTBL_TYPE CHAR(2),
\$TESTTBL_VALUE DECIMAL(19),
\$TESTTBL_UPD_DT TIMESTAMP 'yyyy-mm-dd-hh.mm.ss.uuuuuuuuuuuu',
\$TESTTBL_NO INTEGER EXTERNAL,
\$TESTTBL_DT2  DATE 'yyyy-mm-dd'
 
  )
                                RESTART OFF
  INSERT INTO ${schema}.${table}
  VALUES
  (
    
\$TESTTBL_IP_ID ,
\$TESTTBL_TYPE ,
\$TESTTBL_DT  ,
CAST(\$TESTTBL_VALUE AS DECIMAL(17,2)) ,
\$TESTTBL_UPD_DT   ,
\$TESTTBL_NO   ,
\$TESTTBL_DT2  
 
  )"
       
if [ $? -gt 2 ]                                            #db2_error_code (0: success, 1: 0 rows selected, 2: warning, 4: DB2 or SQL error, 8: system error)
then
echo "execution stopped at " $(date "+%Y-%m-%d %H:%M:%S")
exit 99
fi
countfile=$(wc -l < ${dataset})
countins="db2 -m 'SELECT COUNT(*) FROM ${schema}.${table} WITH UR'"
if[ $countfile -ne $countins ]
 echo " Load count does not match with records in file..Contact Support team immediately. "
 exit 99
fi
### end time
echo "execution completed at " $(date "+%Y-%m-%d %H:%M:%S")
 
 
