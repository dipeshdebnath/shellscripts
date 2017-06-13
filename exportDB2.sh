#!/bin/bash                                                                    
dataset_path=/home/dc/
cd ${dataset_path}
read TESTDBSCHEMA XCUSDILSCHEMA TESTDBTESTDBUSR TESTDBTESTDBPWD MFXCUSUSR MFXCUSPWD DATAHDB MAINFIP TESTDBIP < ./shellscript/config/CONF.TXT
 
database=$DATAHDB
user=$TESTDBTESTDBUSR
password=$TESTDBTESTDBPWD
schema=$TESTDBSCHEMA
table=MTY
 
getresults1()                                                                   
{                                                                              
 db2 "connect to ${1} user ${2} using ${3}"                                    
 db2 "set schema ${4}"                                                         
 db2 "export to TESTDBAfile of del select DIGITS(D_TG) as x,
DIGITS(EMP_ID) as x,
SUBSTR(EMP_F1,1,10) as x,
CASE WHEN FT2 IS NULL THEN 'x' ELSE FT2 END as x,
CASE WHEN Z_DT IS NULL THEN '0001-01-01' ELSE SUBSTR(VARCHAR_FORMAT(Z_DT,'YYYY-MM-DD'),1,10) END as x,
CASE WHEN M_DT IS NULL THEN '0001-01-01' ELSE SUBSTR(VARCHAR_FORMAT(M_DT,'YYYY-MM-DD'),1,10) END as x,
CASE WHEN TDC IS NULL THEN 'x' ELSE TDC END  as x
from MTY
where  D_TG IN (SELECT D_TG FROM Z_M) AND TFDT > CURRENT TIMESTAMP - 1 DAY "
                                                                  
}                                                                               
getresults1 X P E M
 
getresults2()                                                                   
{                                                                              
 db2 "connect to ${1} user ${2} using ${3}"                                    
 db2 "set schema ${4}"                                                         
 db2 "export to TESTDBAfile of del select DIGITS(D_TG) as x,
DIGITS(X_ID) as x,
SUBSTR(x_INF1,1,10) as x,
CASE WHEN FT2 IS NULL THEN 'x' ELSE FT2 END as x,
CASE WHEN Z_DT IS NULL THEN '0001-01-01' ELSE SUBSTR(VARCHAR_FORMAT(Z_DT,'YYYY-MM-DD'),1,10) END as x,
CASE WHEN M_DT IS NULL THEN '0001-01-01' ELSE SUBSTR(VARCHAR_FORMAT(M_DT,'YYYY-MM-DD'),1,10) END as x,
CASE WHEN TDC IS NULL THEN 'x' ELSE TDC END  as x
from MTY
where D_TG IN (SELECT D_TG FROM X_T) AND
AND D_TG > CURRENT TIMESTAMP - 1 DAY  AND D_TG < CURRENT TIMESTAMP "
                                                                  
}                                                                              
getresults2 X P E M
