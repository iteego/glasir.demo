@Grapes([
  @Grab('com.h2database:h2:1.3.162'),
  @GrabConfig(systemClassLoader=true)
])

/*

Starts the H2 Console (web-) server, TCP, and PG server.
Usage: java org.h2.tools.Server <options>
When running without options, -tcp, -web, -browser and -pg are started.
Options are case sensitive. Supported options are:
[-help] or [-?]         Print the list of options
[-web]                  Start the web server with the H2 Console
[-webAllowOthers]       Allow other computers to connect - see below
[-webDaemon]            Use a daemon thread
[-webPort <port>]       The port (default: 8082)
[-webSSL]               Use encrypted (HTTPS) connections
[-browser]              Start a browser connecting to the web server
[-tcp]                  Start the TCP server
[-tcpAllowOthers]       Allow other computers to connect - see below
[-tcpDaemon]            Use a daemon thread
[-tcpPort <port>]       The port (default: 9092)
[-tcpSSL]               Use encrypted (SSL) connections
[-tcpPassword <pwd>]    The password for shutting down a TCP server
[-tcpShutdown "<url>"]  Stop the TCP server; example: tcp://localhost
[-tcpShutdownForce]     Do not wait until all connections are closed
[-pg]                   Start the PG server
[-pgAllowOthers]        Allow other computers to connect - see below
[-pgDaemon]             Use a daemon thread
[-pgPort <port>]        The port (default: 5435)
[-properties "<dir>"]   Server properties (default: ~, disable: null)
[-baseDir <dir>]        The base directory for H2 databases (all servers)
[-ifExists]             Only existing databases may be opened (all servers)
[-trace]                Print additional trace information (all servers)
The options -xAllowOthers are potentially risky.
For details, see Advanced Topics / Protection against Remote Access.
See also http://h2database.com/javadoc/org/h2/tools/Server.html

*/

import org.h2.tools.Server

Integer activePort = 9092
Server.main(["-tcp", "-tcpAllowOthers", "-tcpPort", activePort, "-baseDir", "glasir.db"] as String[])
//Server.main(["-help", "-tcpAllowOthers"] as String[])

println "** H2 database started on port $activePort..."

Thread.sleep(1000000)