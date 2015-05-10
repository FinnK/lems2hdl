package ie.nuigalway.lems2hdl;

import ie.nuigalway.lems2hdl.VHDLConfiguration;

import java.io.BufferedReader;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FilenameFilter;
import java.io.IOException;
import java.io.InputStream; 
import java.io.Reader;
import java.io.StringReader;
import java.nio.charset.Charset;
import java.security.DigestInputStream;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.lemsml.jlems.core.sim.ContentError;
import org.lemsml.jlems.core.type.ComponentType;
import org.lemsml.jlems.core.type.Lems;

public class VHDLUtils {

	public static boolean isAlive( Process p ) {
	    try
	    {
	        p.exitValue();
	        return false;
	    } catch (IllegalThreadStateException e) {
	        return true;
	    }
	}

	public static void createAndPrintDependancyTree(Lems lems) throws ContentError 
	{
		createAndPrintDependancyTree( lems,  null);
	}
	
	public static void createAndPrintDependancyTree(Lems lems, String startWith) throws ContentError 
	{
		createAndPrintDependancyTree( lems,  startWith,0);
	}
	
	public static void createAndPrintDependancyTree(Lems lems, String startWith, int level) throws ContentError
	{
		
		List<ComponentType> containedComponents = new ArrayList<ComponentType>();
		for (ComponentType entry : lems.getComponentTypes()) {
			if ((startWith == null && entry.eXtends == null) )
			{
				containedComponents.add(entry);
			}
			else if (startWith != null && entry.eXtends != null && entry.eXtends.matches((lems.getComponentTypeByName(startWith).getName())))
			{
				containedComponents.add(entry);
			}
		}
		
		for (ComponentType entry : containedComponents) {
			StringBuilder spacesSB = new StringBuilder();
			for (int i  = 0; i < level; i++)
			{
				spacesSB.append(" > ");
			}
			System.out.println(spacesSB.toString() + entry.name + " : "); //entry.addDynamics();
			createAndPrintDependancyTree( lems,  entry.getName(),  level + 1);
		}
	}
	

	public static void copyFile(File sourceFile, File destFile) throws IOException {
	    if(!destFile.exists()) {
	        destFile.createNewFile();
	    }

	    FileInputStream from = null;
	    FileOutputStream to = null;

	    try {
	    	from = new FileInputStream(sourceFile);
	    	to = new FileOutputStream(destFile);

	        byte[] buffer = new byte[4096];
	        int bytesRead;
	        while ((bytesRead = from.read(buffer)) != -1)
		          to.write(buffer, 0, bytesRead); // write
		      } 
	    finally {
	        if (from != null)
	          try {
	            from.close();
	          } catch (IOException e) {
	            ;
	          }
	        if (to != null)
	          try {
	            to.close();
	          } catch (IOException e) {
	            ;
	          }
	      }
	    
	  
	}

	public static byte[] getMD5ForFile(File file) throws NoSuchAlgorithmException, IOException
	{
		MessageDigest md = MessageDigest.getInstance("MD5");
		try {
			InputStream is = new FileInputStream(file.getAbsolutePath());
		  DigestInputStream dis = new DigestInputStream(is, md);
		  /* Read stream to EOF as normal... */
		  while (dis.read() != -1)
		  {}
		}
		catch (Exception e)
		{
			String error = e.getMessage();
		}
		byte[] digest = md.digest();
		return digest;
	}
	

	public static byte[] getMD5ForString(String data) throws NoSuchAlgorithmException, IOException
	{
		MessageDigest md = MessageDigest.getInstance("MD5");
		try {
		  InputStream is = new ByteArrayInputStream(data.getBytes(Charset.forName("UTF-8")));
		  DigestInputStream dis = new DigestInputStream(is, md);
		  /* Read stream to EOF as normal... */
		  while (dis.read() != -1)
		  {}
		}
		catch (Exception e)
		{
			String error = e.getMessage();
		}
		byte[] digest = md.digest();
		return digest;
	}
	
	public static byte[] getMD5ForDir(String directory,final String fileExt) throws NoSuchAlgorithmException, IOException
	{
		MessageDigest md = MessageDigest.getInstance("MD5");
		File dir = new File(directory);
		File [] files = dir.listFiles(new FilenameFilter() {
		    @Override
		    public boolean accept(File dir, String name) {
		        return name.endsWith(fileExt);
		    }
		});
		for (File file : files) {
		
			byte[] md5_file = getMD5ForFile(file);
			md.update(md5_file);		
		}		
		return  md.digest();
	}
	
	public static String lookForMatchingVHDLDirectory(VHDLConfiguration config, String thisDirectory) throws NoSuchAlgorithmException, IOException
	{
		
		byte[] md5_wanted = getMD5ForDir(thisDirectory,".vhdl");
		
		File dir = new File(config.WORKDIR);
		String[] directories = dir.list(new FilenameFilter() {
		  @Override
		  public boolean accept(File current, String name) {
		    return new File(current, name).isDirectory();
		  }
		});
		for (int i = 0; i < directories.length; i++)
		{
			File dir1 = new File(directories[i]);
			File dir2 = new File(thisDirectory);
			
			if (dir1.equals(dir2))
				continue;
			byte[] md5_this = getMD5ForDir(config.WORKDIR + File.separator + directories[i] + File.separator + "Synth_output",".vhdl");
			if (Arrays.equals(md5_this,md5_wanted)) 
			{
				File fileExisting = new File(config.WORKDIR + File.separator + directories[i] + File.separator + "Synth_output" + 
						File.separator + "dlm.bit");
				if (fileExisting.exists())
				{
					return directories[i];
				}
			}
		}
		return null;		
	}
	
	
}


