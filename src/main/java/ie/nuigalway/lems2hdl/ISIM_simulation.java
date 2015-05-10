package ie.nuigalway.lems2hdl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;

import org.lemsml.jlems.io.util.FileUtil;

public class ISIM_simulation {

	public static void runISIM(VHDLConfiguration config, String folderLocation) throws Exception
	{

		try {
			ProcessBuilder pb = new ProcessBuilder(config.FUSE_LOCATION,"-intstyle","ise","-incremental","-lib","secureip","-o",
					 "testbench_isim.exe",
					"-prj", "testbench.prj",
					"work.tb_simulation");
			File theDir = new File(folderLocation);
			pb.directory(theDir);
			Map<String, String> env = pb.environment();
	        // set environment variables
	        String path = env.get("Path");
	        path = config.PATH_addon + path;
	        env.put("Path", path);
	        env.put("XILINX", config.XILINX + "\\ISE");
			pb.redirectErrorStream(true);
			Process process = pb.start();
			InputStream is = process.getInputStream();
			InputStreamReader isr = new InputStreamReader(is);
			BufferedReader br = new BufferedReader(isr);
			String line;

			System.out.printf("--------------------------------------------------- \r\n");
			System.out.printf("Starting Testbench compilation:\r\n");

			int timeoutInSeconds = 60;
			long now = System.currentTimeMillis();
		    long timeoutInMillis = 1000L * timeoutInSeconds;
		    long finish = now + timeoutInMillis;
//		    while ( VHDLUtils.isAlive( process) && ( System.currentTimeMillis() < finish ) )
//		    {
//		        Thread.sleep( 10 );
//		    }
//		    if ( VHDLUtils.isAlive( process ) )
//		    {
//		        throw new InterruptedException( "Process timeout out after " + timeoutInSeconds + " seconds" );
//		    }
			while ((line = br.readLine()) != null) {
			  System.out.println(line);
			  Thread.sleep( 100 );
			}
			System.out.printf("Completed Testbench compilation. \r\n");
			System.out.printf("--------------------------------------------------- \r\n");
			
			ProcessBuilder pb2 = new ProcessBuilder( folderLocation +  File.separator +"testbench_isim.exe","-intstyle",
					"ise","-tclbatch", folderLocation+ File.separator + "isim.cmd");
			pb2.directory(theDir);
			Map<String, String> env2 = pb2.environment();
	        // set environment variables
	        String path2 = env2.get("PATH");
	        path2 = config.PATH_addon + path2;
	        env2.put("PATH", path2);
	        env2.put("XILINX", config.XILINX+ File.separator + "ISE");
	        env2.put("PLATFORM", config.PLATFORM);
	        env2.put("LD_LIBRARY_PATH", config.LD_LIBRARY_PATH);
	        
	        Process process2 = pb2.start();
			InputStream is2 = process2.getInputStream();
			InputStreamReader isr2 = new InputStreamReader(is2);

			

			System.out.printf("--------------------------------------------------- \r\n");
			System.out.printf("Starting testbench execution:\r\n");
			timeoutInSeconds = 3600;
			now = System.currentTimeMillis();
		    timeoutInMillis = 1000L * timeoutInSeconds;
		    finish = now + timeoutInMillis;
		    while ( VHDLUtils.isAlive( process2) && ( System.currentTimeMillis() < finish ) )
		    {
		        Thread.sleep( 10 );
		    }
		    if ( VHDLUtils.isAlive( process2 ) )
		    {
		        throw new InterruptedException( "Process timeout out after " + timeoutInSeconds + " seconds" );
		    }
			//while ((line2 = br2.readLine()) != null) {
			//  System.out.println(line2);
			//}
			System.out.printf("Finished testbench execution. \r\n");
			System.out.printf("--------------------------------------------------- \r\n");
			
			

			
			
			} catch (Exception  e) {
				// TODO Auto-generated catch block
				StringWriter sw = new StringWriter();
				PrintWriter pw = new PrintWriter(sw);
				e.printStackTrace(pw);
				throw new Exception("VHDL model ISIM simulation failed:\r\n" + sw.toString());
				//e.printStackTrace(); 
			}
		
	}
	
	
}
