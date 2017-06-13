#!/bin/bash
echo "###################### Start of GET data FROM  Server into FILE"
echo "###################### execution started @ " $(date "+%Y-%m-%d %H:%M:%S")
cd /home/dc/
read TESTDBSCHEMA XCUSDILSCHEMA TESTDBTESTDBUSR TESTDBTESTDBPWD MFXCUSUSR MFXCUSPWD DATAHDB  MAINFIP TESTDBIP < ./shellscript/config/CONF.TXT
ftp -n -i -v <<EOF
open $MAINFIP
user $MFXCUSUSR $MFXCUSPWD
cd /
 
get 'XCUST.L.DATA' TESTY.DATA
 
quit
<<EOF
if [ $? -gt 0 ]         
then
echo "###################### IMPORT command fails"
echo "######################$0 execution stopped UNCOMPLETED at " $(date "+%Y-%m-%d %H:%M:%S")
exit 99
fi
