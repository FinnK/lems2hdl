package ie.nuigalway.lems2hdl;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;

public class VHDLConfiguration {

	//what platform are we on
	public String PLATFORM;
	//where is the fuse ISIM simulation compiler located
	public String FUSE_LOCATION;
	//what needs to be added to the path to execute Xilinx software
	public String PATH_addon;
	//where is the Xilinx ISE tool located
	public String XILINX;
	//where are the common LEMS files located
	public String COMMONFILEPATH;
	//where is the VL Parser/Wrapper located
	public String PARSERLOCATION;
	//where is the VL VLXPY application located
	public String DLXPYLOCATION;
	//where is Xilinx Planahead located
	public String XILINX_PLANAHEAD;
	//where are the existing projects saved
	public String WORKDIR;
	
	public String LD_LIBRARY_PATH;

	public String PYTHONPATH;
	
	public String WORKDIRSIM;
	
	public String XTCLSHLOCATION;
	
	
	
	
	public VHDLConfiguration()
	{
		 XILINX = "C:Xilinx\\14.6\\ISE_DS";
		 COMMONFILEPATH = "C:\\Users\\gebruiker\\Documents\\neuroML\\org.sielegans.neuronmodels\\LEMS Neuron Models\\LEMS Single Neuron Models";
		 PARSERLOCATION = "C:\\Users\\gebruiker\\dlm-parser-module";
		 DLXPYLOCATION = "C:\\Users\\gebruiker\\Documents\\neuroML\\LEMS2HDL\\Client-Side-Applications\\dlxpy";
		 WORKDIR = "work";
		 WORKDIRSIM = "worksim";
		 PLATFORM = "nt64";
		 PYTHONPATH = "/usr/bin/python";
		 expandConfiguration();
		 //saveDefaultVHDLConfiguration();
		 loadVHDLConfiguration();
	}
	
	private void expandConfiguration()
	{
		 PATH_addon = XILINX + File.separator + "ISE" + File.separator + "bin" + 
				 File.separator + PLATFORM + File.pathSeparator +
				 XILINX + File.separator + "ISE" + File.separator + "lib" + 
				 File.separator + PLATFORM + File.pathSeparator +
				 XILINX + File.separator + "ISE" + File.separator + "DocNav" + File.pathSeparator;
		 LD_LIBRARY_PATH = XILINX + File.separator + "ISE" + File.separator + 
				 "lib" + File.separator+ PLATFORM;
		 //FUSE_LOCATION = XILINX + "\\ISE\\bin\\nt64\\unwrapped\\fuse.exe";
		 XILINX_PLANAHEAD = XILINX + File.separator + "PlanAhead";
	}

	public void saveDefaultVHDLConfiguration()
	{
		Properties props = new Properties();
		props.setProperty("XILINX",XILINX);
		props.setProperty("COMMONFILEPATH",COMMONFILEPATH);
		props.setProperty("PARSERLOCATION",PARSERLOCATION);
		props.setProperty("DLXPYLOCATION",DLXPYLOCATION);
		props.setProperty("WORKDIR",WORKDIR);
		props.setProperty("FUSE_LOCATION",FUSE_LOCATION);
		props.setProperty("PLATFORM",PLATFORM);
		props.setProperty("PYTHONPATH",PYTHONPATH);
		props.setProperty("WORKDIRSIM",WORKDIRSIM);
		props.setProperty("XTCLSHLOCATION",XTCLSHLOCATION);
		
		

		try {
			FileOutputStream out = new FileOutputStream("LEMS2HDL.properties");
			props.store(out, "---No Comment---");
			out.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	public void loadVHDLConfiguration() 
	{
		Properties props = new Properties();
		try {
		FileInputStream in = new FileInputStream("LEMS2HDL.properties");
		props.load(in);
		in.close();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		XILINX = props.getProperty("XILINX");
		COMMONFILEPATH = props.getProperty("COMMONFILEPATH");
		PARSERLOCATION = props.getProperty("PARSERLOCATION");
		DLXPYLOCATION = props.getProperty("DLXPYLOCATION");
		WORKDIR = props.getProperty("WORKDIR");
		FUSE_LOCATION = props.getProperty("FUSE_LOCATION");
		PLATFORM =  props.getProperty("PLATFORM");
		PYTHONPATH = props.getProperty("PYTHONPATH");
		WORKDIRSIM =  props.getProperty("WORKDIRSIM");
		XTCLSHLOCATION = props.getProperty("XTCLSHLOCATION");
		
		expandConfiguration();
	}
	
}
