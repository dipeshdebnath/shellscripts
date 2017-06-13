#!/bin/bash                                                                     
dataset_path=/home/dc/
cd ${dataset_path}
read TESTDBSCHEMA XCUSDILSCHEMA TESTDBTESTDBUSR TESTDBTESTDBPWD MFXCUSUSR MFXCUSPWD DATAHDB MAINFIP TESTDBIP < ./shellscript/config/CONF.TXT
 
database=$DATAHDB
user=$TESTDBTESTDBUSR
password=$TESTDBTESTDBPWD
schema=$TESTDBSCHEMA
table=TRX
cat T333.DATA3 T333.DATA4 > T333.DATAAR
sort -u -t, -k1,1 T333.DATAAR > T333.DATAAR.UNIQ
awk -F"," '{print $1}' T333.DATAAR.UNIQ > LOADTEMPAR.DATA
 
getresults()                                                                    
{                                                                              
 db2 "connect to ${database} user ${user} using ${password}"                                    
 db2 "set schema ${schema}"     
                                                
db2 "import from LOADTEMPAR.DATA of del  insert into ${schema}.CXVVV"
 
}                                                                              
getresults  
 
 
