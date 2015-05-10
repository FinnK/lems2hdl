package ie.nuigalway.lems2hdl;


import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.channels.FileChannel;

import org.lemsml.export.vhdl.VHDLWriter;
import org.lemsml.export.vhdl.VHDLWriter.Method;
import org.lemsml.export.vhdl.VHDLWriter.ScriptType;
import org.lemsml.jlems.core.expression.ParseError;
import org.lemsml.jlems.core.logging.E;
import org.lemsml.jlems.core.run.ConnectionError;
import org.lemsml.jlems.core.run.RuntimeError;
import org.lemsml.jlems.core.sim.ContentError;
import org.lemsml.jlems.core.sim.LEMSException;
import org.lemsml.jlems.core.sim.ParseException;
import org.lemsml.jlems.core.sim.Sim;
import org.lemsml.jlems.core.type.Attachments;
import org.lemsml.jlems.core.type.BuildException;
import org.lemsml.jlems.core.type.Component;
import org.lemsml.jlems.core.type.ComponentType;
import org.lemsml.jlems.core.type.Exposure;
import org.lemsml.jlems.core.type.Lems;
import org.lemsml.jlems.core.type.LemsCollection;
import org.lemsml.jlems.core.type.Target;
import org.lemsml.jlems.core.xml.XMLException;
import org.lemsml.jlems.io.IOUtil;
import org.lemsml.jlems.io.logging.DefaultLogger;
import org.lemsml.jlems.io.out.FileResultWriterFactory;
import org.lemsml.jlems.io.out.StringBuilderResultWriter;
import org.lemsml.jlems.io.out.StringBuilderResultWriterFactory;
import org.lemsml.jlems.io.reader.JarResourceInclusionReader;
import org.lemsml.jlems.io.util.FileUtil;
import org.lemsml.jlems.viz.datadisplay.SwingDataViewerFactory;
import org.lemsml.export.vhdl.VHDLWriter;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.UUID;

public class Main {

	
	
	public static void main(String[] args)
	{
		if (args.length < 3)
		{
			System.out.println("incorrect number of arguments, usage is :");
			System.out.println("lems2hdl filename.xml neuron_model isim");
			return;
		}
	       System.out.println("Working Directory = " +
	               System.getProperty("user.dir"));
		File commonFile ;
		JarResourceInclusionReader jrir ;
		VHDLConfiguration config = new VHDLConfiguration();
		commonFile = new File(args[0]);//"Ex0_iafCell_simple_7_synapses.xml");
		jrir = new JarResourceInclusionReader(commonFile);
		try {
			//System.out.println("args[2].matches(\"isim\")" + (args[2].matches("isim") ? "true" : "false") );
			Main.runAndConvertSingleNeuronModel(config,jrir.read(),args[2].matches("isim"),
				null,0.5,0.00005);
		} catch (Exception e) {
			// TODO Auto-generated catch block 
			e.printStackTrace();
		}
		
	}
	
	public static Map<String, String> runAndConvertSingleNeuronModel( VHDLConfiguration config,
			String lemsModel, boolean simulateVHDL, String name,
			double simTime, double simTimeStep) throws IOException, RuntimeError, ParseException, BuildException, XMLException, Exception
	{
		 Map<String, String> returnValues = new HashMap<String, String>();
		 
		 String neuronName = "neuron_model";
		 
		 String projectID =  UUID.randomUUID().toString();
		 String randomFolder = config.WORKDIR + "/" + projectID;
		 if (name != null)
			 randomFolder =  config.WORKDIR + "/" +name;
		 String location = System.getProperty("user.dir");
		 randomFolder = location + "/" + randomFolder;
		 File theDir = new File(randomFolder);
		 theDir.mkdir();
		 String theLocation_LEMS = randomFolder + "/" + "LEMS_output";
		 theDir = new File(theLocation_LEMS);
		 theDir.mkdir();
		 String theLocation_ISIM = randomFolder + "/" + "ISIM_output";
		 theDir = new File(theLocation_ISIM);
		 theDir.mkdir();
		 String theLocation_FPGA = randomFolder + "/" + "Synth_output";
		 theDir = new File(theLocation_FPGA);
		 theDir.mkdir();

		 StringBuilder resultsHeader = new StringBuilder();
		 String completeLEMSModel = LEMS_minimal_to_complete.createCompleteLEMSFromMinimalModel(returnValues, config,lemsModel, 
					theLocation_LEMS, theLocation_ISIM, theLocation_FPGA,resultsHeader, simTime, simTimeStep);
		 
		 LEMS_simulation.runLEMS(returnValues, completeLEMSModel, config, theLocation_LEMS, theLocation_ISIM, 
				 theLocation_FPGA, resultsHeader);
		 
		VHDLErrors error_analysis = new VHDLErrors();
		error_analysis.loadLEMSResults(returnValues, theLocation_LEMS);
			
		try 
		{
			//now convert to vhdl
			Sim sim = new Sim(completeLEMSModel);
	        sim.readModel();
			sim.build();
			Lems lems = sim.getLems();
			VHDLWriter vw = new VHDLWriter(lems);
			boolean useVirtualSynapses = false;
			Map<String,String> componentScripts = vw.getNeuronModelScripts(neuronName,false);
			String testbenchScript = vw.getSimulationScript(ScriptType.TESTBENCH,  
					error_analysis.getStartingStateFromLEMSSimulation(),neuronName,useVirtualSynapses);
			String tclScript = vw.getTCLScript(simTime,simTimeStep);
			String prjScript = vw.getPrjFile(componentScripts.keySet());
			String vllScript = vw.getVLLFile(componentScripts.keySet());
			String defaultJSON = vw.getSimulationScript(ScriptType.DEFAULTPARAMJSON,neuronName,useVirtualSynapses);
			String defaultJSONState = vw.getSimulationScript(ScriptType.DEFAULTSTATEJSON , 
					error_analysis.getStartingStateFromLEMSSimulation(),neuronName,useVirtualSynapses);
			String defaultReadbackJSON = vw.getSimulationScript(ScriptType.DEFAULTREADBACKJSON,neuronName,useVirtualSynapses);
			String ucfScript = vw.getSimulationScript(ScriptType.CONSTRAINTS,neuronName,useVirtualSynapses);
			

			for (Map.Entry<String, String> entry : componentScripts.entrySet()) {
				String key = entry.getKey();
				String val = entry.getValue();
				File vwFile = new File(theLocation_ISIM + "/" + key + ".vhdl");
				FileUtil.writeStringToFile(val, vwFile);
				returnValues.put(key + ".vhdl", val);
			}

			File vwFile = new File(theLocation_ISIM+ "/" + "testbench.vhdl");
			FileUtil.writeStringToFile(testbenchScript, vwFile);
			returnValues.put("testbench.vhdl", testbenchScript);

		    vwFile = new File(theLocation_ISIM+ "/" + "isim.cmd");
			FileUtil.writeStringToFile(tclScript, vwFile);
			
			
			
			
			
			

			vwFile = new File(theLocation_ISIM+ "/" + "testbench.prj");
			returnValues.put("testbench.prj", prjScript);
			FileUtil.writeStringToFile(prjScript, vwFile);
		} catch (Exception  e) {
			// TODO Auto-generated catch block
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			throw new Exception("LEMS to VHDL model conversion failed:\r\n" + sw.toString());
			///e.printStackTrace();
		}
		
		
		if (simulateVHDL)
		{
			ISIM_simulation.runISIM(config, theLocation_ISIM);
			error_analysis.loadISIMResults(returnValues, theLocation_ISIM);
			error_analysis.compileISIM_LEMS_Errors(returnValues, config, theLocation_LEMS, theLocation_ISIM, theLocation_FPGA);
		}		
		return returnValues;
	}
	
}
