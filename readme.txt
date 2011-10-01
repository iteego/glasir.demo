
You must change some things to customize glasir.bootstrap 
if it is in the "mycompany/mybrand/h2" mode.

1. 
Edit the database connection settings in the file 
"servers/jboss/storefront/development/deploy/atg-ds.xml"

2.
Change the settings for glasir.db (ATG_DB) in the file
"atg_db/config/com/iteego/db/LiquibaseService.properties"
to use a set of database changes that matches your database by editing the values in the hash 
table property "directoryToJndiMap".

3.
To change the name of the install unit "mycompany" you must change
the directory name and the value of the "company" property in the 
file "buildtools/include/environment.glasir".

4.
To change the name of the root module "mybrand", change the directory 
name and the value of the "brand" property in the
file "buildtools/include/environment.glasir".

token change my Marcus - testing new certificate
