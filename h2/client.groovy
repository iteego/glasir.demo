@Grapes([
  @Grab('com.h2database:h2:1.3.162'),
  @GrabConfig(systemClassLoader=true)
])
import groovy.sql.Sql

boolean explicitCommits = true

String url = new File('jdbc.url').text.trim()

println ""
println "URL: $url"
println ""

def sql = Sql.newInstance(url, "sa", "sa", "org.h2.jdbcx.JdbcDataSource") //"org.h2.Driver")

if (!tableExists(sql, "test")) {
  println "'test' table not found, creating it, please rerun script to run some selects on it"
  int affected = sql.executeUpdate("CREATE TABLE if not exists test(ID INT AUTO_INCREMENT PRIMARY KEY, NAME VARCHAR(255)) ")

  if (explicitCommits) sql.commit()
  //println "table create affected ${affected}"
} else {
  println "Table exists!"
}

println "Inserting row into table 'test'"
def ins = sql.executeInsert("insert into test (name) values ('kalle')")
if (explicitCommits) sql.commit()
println "id values from insert: ${ins}"

println ""
println "Rows in table 'test' after insert:"
sql.eachRow("select * from test") { row ->
  println "ROW: " + row   
}

if (args.size() > 0) {
  println ""
  println "Arguments provided...sleeping indefinitely..."
  Thread.sleep(6000000)
}


////////////////////////////////////////////////////////////////
// exit here

def tableExists(sql, tableName) {
  boolean foundIt = false
  def rs = sql.connection.metaData.getTables(null, null, null, null)
  while (rs.next()) {
    if (rs.getString('TABLE_NAME').equalsIgnoreCase(tableName)) {
      foundIt = true
      break
    }
  }

  foundIt
}

/*
    <xa-datasource>
        <jndi-name>GlasirPublishingDS-h2</jndi-name>
        <xa-datasource-class>org.h2.jdbcx.JdbcDataSource</xa-datasource-class>
        <xa-datasource-property name="URL">jdbc:h2:../glasir.db/glasir_pub;AUTO_SERVER=TRUE;MODE=Oracle;DB_CLOSE_ON_EXIT=FALSE;DB_CLOSE_DELAY=-1;AUTOCOMMIT=OFF;LOCK_MODE=0;MVCC=TRUE;CACHE_SIZE=65536</xa-datasource-property>
        <min-pool-size>5</min-pool-size>
        <max-pool-size>100</max-pool-size>
        <idle-timeout-minutes>10</idle-timeout-minutes>
        <prepared-statement-cache-size>32</prepared-statement-cache-size>
        <security>
            <user-name>sa</user-name>
            <password>sa</password>
        </security>
    </xa-datasource>


*/