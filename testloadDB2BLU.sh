#--Script written by:Dipesh Debnath
#Purpose:Test whether loading is successful

#!/bin/bash
 
### database schema
dataset_path=/home/dc/
cd ${dataset_path}
read TESTDBSCHEMA XCUSDILSCHEMA TESTDBTESTDBUSR TESTDBTESTDBPWD MFXCUSUSR MFXCUSPWD DATAHDB MAINFIP TESTDBIP < ./shellscript/config/CONF.TXT
database=$DATAHDB
user=$TESTDBTESTDBUSR
password=$TESTDBTESTDBPWD
schema=$XCUSDILSCHEMA
dataset=`ls -1t ${dataset_path}INPUTFILE.DATA | head -1`
table=EMPDATA
export LANG=en_EN
 
### open database connection
db2 -m "TERMINATE"
 
if [ $? -gt 2 ]                                            #db2_error_code (0: success, 1: 0 rows selected, 2: warning, 4: DB2 or SQL error, 8: system error)
then
echo "##################################################################################################### TERMINATE command fails"
echo "#####################################################################################################$0 execution stopped UNCOMPLETED at " $(date "+%Y-%m-%d %H:%M:%S")
exit 99
fi
 
db2 -m "CONNECT TO ${database} USER ${user} USING ${password}"

countfile=$(wc -l < ${dataset})
countins=$(db2 -x "SELECT COUNT(*) FROM ${schema}.${table} WITH UR")
echo $countins
echo $countfile
if [ $countfile != $countins ]
then
 echo " Error. "
 exit 99
else
 echo " Success. "
 
 exit 0
fi
