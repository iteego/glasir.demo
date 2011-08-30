/*
 * Copyright (c) 2011. Iteego.
 */

package com.iteego.db

import liquibase.resource.FileSystemResourceAccessor
import java.util.zip.ZipFile

/**
 * This class extends a Liquibase class and its job is to respond to
 * the getResourceAsStream( String file ) method with a file stream.
 *
 * We override the method and this class to allow it to respond with
 * a stream that is not based on an actual file. The stream comes from
 * data that was sent to this class in the constructor.
 *
 * User: mwangel
 * Date: 2011-03-03
 * Time: 09:48
 */
class CustomFileSystemResourceAccessor extends FileSystemResourceAccessor {
	String changeLogName
	List<FileNameAndXml> changeSets
	String baseDirectory = null

	public CustomFileSystemResourceAccessor( String baseDir, String changeLogName, List<FileNameAndXml> whatWeAreRollingBack ) {
		this.baseDirectory = baseDir
		this.changeLogName = changeLogName
		changeSets = new ArrayList<FileNameAndXml>()
		whatWeAreRollingBack.each { changeSets.add(it) }
	}

	/**
	* We have the xml data in memory and don't want to create an
	* actual file for it on actual disk so send out memory contents
	* and make it look like a file.
	* @param file Liquibase is looking for this file (relative to baseDirectory).
	* @return InputStream, or null if we don't have the data.
	* @throws IOException Like the original in Liquibase.
	*/
	public InputStream getResourceAsStream( String file ) throws IOException {
		// CustomFileSystemResourceAccessor was asked for file '$file'.
		File absoluteFile = new File(file);
		File relativeFile = (baseDirectory == null) ? new File(file) : new File(baseDirectory, file);

		if (absoluteFile.exists() && absoluteFile.isFile() && absoluteFile.isAbsolute()) {
				return new FileInputStream(absoluteFile);
		} else if (relativeFile.exists() && relativeFile.isFile()) {
				return new FileInputStream(relativeFile);
		} else {
			//------------------------------------------------------------
			// This is where we come in.
			//------------------------------------------------------------
			if( file.equals( this.changeLogName ) ) {
				// Asked for the main change log file.
				String text = XmlStreamHelper.createFakeChangeLogXml( changeSets )
				InputStream fakeFileStream = new ByteArrayInputStream( text.getBytes("UTF-8") )
				// Return a fake file stream for the change log file
				return fakeFileStream
			} else {
				// Asked for a specific change set.
				FileNameAndXml item = changeSets.find { it.getFileName().equals( file ) }
        if( item == null ) {
          // File name not found, check xml file names (for zip file content).
          item = changeSets.find { (it as XmlChange).xmlFileName.equals( file ) }
        }

				if( item != null ) {
					String text = XmlStreamHelper.createFakeChangeSetXml( item )
					InputStream fakeFileStream = new ByteArrayInputStream( text.getBytes("UTF-8") )
					// Return a fake file stream for a change set file.
					return fakeFileStream
				}
			}
			// Why is Liquibase asking this object for this file?
			return null
		}
  }


  public String getFileHash( String file ) {
    //System.err.println "getFileHash for $file, baseDirectory=$baseDirectory"
    if( file.equals( this.changeLogName ) ) {
      // Asked for the main change log file. This is not what we are after but sure:
      InputStream stream = getResourceAsStream( file )
      if( stream ) {
        String result = liquibase.util.MD5Util.computeMD5( stream )
        stream.close()
        return result
      }
      return null
    } else {
      // Asked for a specific change set.
      File dataFile = null

      // Simple (existing) xml?
      File relativeFile = (baseDirectory == null) ? new File(file) : new File(baseDirectory, file);
      if( relativeFile.exists() && relativeFile.isFile() ) {
        dataFile = relativeFile
      } else {
        // zip?
        FileNameAndXml item = changeSets.find { (it as XmlChange).xmlFileName.equals( file ) }
        if( item ) {
          if( (item as XmlChange).container != null )
            dataFile = (item as XmlChange).container
          else if( (item as XmlChange).file != null )
            dataFile = (item as XmlChange).file
        }
      }

      if( dataFile != null ) {
        InputStream stream = dataFile.newInputStream()
        String result = liquibase.util.MD5Util.computeMD5( stream )
        stream.close()
        //System.err.println "hash is $result"
        return result
      }
    }

    throw new FileNotFoundException( "File not found: \"${file}\"." )
  }

}

