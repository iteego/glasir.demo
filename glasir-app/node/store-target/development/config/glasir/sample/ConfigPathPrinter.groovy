package glasir.sample

import atg.nucleus.GenericService;
import atg.nucleus.Nucleus;
import atg.nucleus.ServiceException;
import java.util.jar.*;

import java.io.File;

public class ConfigPathPrinter extends GenericService {

    public final String DATA_IMPORT_FOLDER_NAME = "data-import"
    public final String DB_MIGRATION_FOLDER_NAME = "db-migrations"

    doStartService () throws ServiceException {

        Nucleus nucleus = getNucleus

        File[] configPath = nucleus?.getConfigPath
        configPath?.each {
            File path = (File) it

            // only deal with directories for now, implement jar files some other rainy day
            if (path.isDirectory) {
                path.eachDirRecurse {
                    File child = (File) it
                    if (child.name.toLowercase.endsWith(DATA_IMPORT_FOLDER_NAME)) {
                        // This is a data import folder. Investigate further...

                        // this path may be under or outside of a repository definition
                        // check if there is a Repository with the same name as the parent folder
                        String childNucleusPath = child.path.substring( path.path.length,
                                path.path.length-DATA_IMPORT_FOLDER_NAME.length )

                        if (isLoggingDebug) {
                            logDebug("Extracted nucleus path = $childNucleusPath")
                        }

                        Object repo = resolveName(childNucleusPath)

                        if (repo?.class instanceof atg.repository.Repository) {
                            // This is a non-versioned repository, the files under the directory
                            // are assumed to be import files for that repository

                            child.eachFileRecurse {
                                File importFile = (File) it
                                //importXMLorRegularFileNonVersioned(importFile)
                            }
                        }

                        else if (repo?.class instanceof atg.adapter.version.VersionRepository) {
                            // This is a non-versioned repository, the files under the directory
                            // are assumed to be import files for that repository
                            // be imported in a versioned context

                            //
                            // change set contains attribute
                            // that looks like
                            // versioned="yes", versioned="no",


                            child.eachFileRecurse {
                                File importFile = (File) it
                                //importXMLorRegularFileVersioned(importFile)
                            }

                        }

                        else {
                            // The parent folder is not the representation of a repository, look for a manifest file


                        }
                    }
                    else if (child.name.toLowercase.endsWith(DB_MIGRATION_FOLDER_NAME)) {
                        // This is a sql change set folder. Do our thing...

                    }

                }
            }



            try{
                JarFile jarFile = new JarFile(file);
                Enumeration em = jarFile.entries();
                for (Enumeration em1 = jarFile.entries(); em1.hasMoreElements();) {
                    JarEntry entry = (JarEntry) em1.nextElement();

                    System.out.println(em1.nextElement());
                }
            }
            catch(ZipException ze){
                System.out.println(ze.getMessage());
                System.exit(0);
            }
        }
    }

}
