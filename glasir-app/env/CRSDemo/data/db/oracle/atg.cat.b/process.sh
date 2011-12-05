#!/bin/bash

doFile () {
  ATG=/work/atg/ATG10.0.2
  DIR=`dirname $2`
  FILE=`basename $2`
  MODULESTR=${DIR%%/sql/db_components/oracle}
  MODULE=${MODULESTR//\//.}
  INDEX=$1 
  FILENAME=$INDEX.$MODULE.$FILE.xml
  
  cp template.header.sql.xml.will.not.run $FILENAME
  cat $ATG/$DIR/$FILE >>$FILENAME
  cat template.footer.sql.xml.will.not.run >>$FILENAME
}

index=$1
while read LINE
do
  doFile "00$index" "$LINE"
  let "index += 1"
done < $2
