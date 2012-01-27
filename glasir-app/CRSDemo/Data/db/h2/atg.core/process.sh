#!/bin/bash


header=$(cat <<EOT
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog
xmlns="http://www.liquibase.org/xml/ns/dbchangelog"
xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
xmlns:ext="http://www.liquibase.org/xml/ns/dbchangelog-ext"
xsi:schemaLocation="http://www.liquibase.org/xml/ns/dbchangelog
 http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-2.0.xsd
 http://www.liquibase.org/xml/ns/dbchangelog-ext
 http://www.liquibase.org/xml/ns/dbchangelog/dbchangelog-ext.xsd">
    <changeSet id='changeset_atg_ootb' author='Marcus Pemer' context='all'>
        <preConditions>
            <not>
                <tableExists tableName='bogus_precondition_table'/>
            </not>
        </preConditions>

        <sql><\![CDATA[
EOT
)



doFile () {
  ATG=/work/atg/ATG10.0.2
  DIR=`dirname $2`
  FILE=`basename $2`
  MODULESTR=${DIR%%/sql/db_components/oracle}
  MODULE=${MODULESTR//\//.}
  INDEX=$1 
  FILENAME=$INDEX.$MODULE.$FILE.xml
  
  echo "$header" > $FILENAME
  cat $ATG/$DIR/$FILE >>$FILENAME
  echo "        </sql>" >>$FILENAME
  echo "        <rollback/>" >>$FILENAME
  #
  # TODO: Add reference to rollback script here
  #
  #echo "        </rollback>" >>$FILENAME

  echo "    </changeSet>" >>$FILENAME
  echo "</databaseChangeLog>" >>$FILENAME

  cat template.footer.sql.xml.will.not.run >>$FILENAME
}

index=$1
while read LINE
do
  doFile "00$index" "$LINE"
  let "index += 1"
done < $2
