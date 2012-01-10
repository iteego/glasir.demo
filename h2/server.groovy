@Grapes([
  @Grab('com.h2database:h2:1.3.162'),
  @GrabConfig(systemClassLoader=true)
])

import org.h2.tools.Server

Integer activePort = 9092
Server.main(["-tcp", "-tcpAllowOthers"] as String[])

println "** H2 database started on port $activePort..."

Thread.sleep(1000000)