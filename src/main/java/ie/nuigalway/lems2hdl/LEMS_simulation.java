package ie.nuigalway.lems2hdl;

import java.io.PrintWriter;
import java.util.Map;

import org.lemsml.jlems.core.sim.Sim;
import org.lemsml.jlems.core.type.Lems;
import org.lemsml.jlems.core.type.LemsCollection;
import org.lemsml.jlems.io.out.StringBuilderResultWriter;
import org.lemsml.jlems.io.out.StringBuilderResultWriterFactory;

public class LEMS_simulation {


	public static void runLEMS( Map<String, String> returnValues, String fullLems, VHDLConfiguration config, String theLocation_LEMS,
			String theLocation_ISIM, String theLocation_FPGA,StringBuilder resultsHeader) throws Exception
	{

		Sim sim = new Sim(fullLems.toString());
        sim.readModel();
		sim.build();
		sim.run();
		Lems lems = sim.getLems();
		
		
		LemsCollection<StringBuilderResultWriter> results = StringBuilderResultWriterFactory.getStringBuilderResultWriters();
		for (StringBuilderResultWriter result : results) {
			if (result.getID().matches("results"))
			{
				String output = result.getSBOutput().toString();
				PrintWriter out = new PrintWriter(theLocation_LEMS+ "/" + "results.csv");
				out.print(result.getSBOutput().insert(0, resultsHeader.toString() + "\n"));
				returnValues.put("LEMS_results.csv", result.toString());
				out.close();
				
			}
			else if (result.getID().matches("stimulus"))
			{
				String output = result.getSBOutput().toString();
				PrintWriter out = new PrintWriter(theLocation_LEMS+ "/" + "stimulus.csv");
				out.print(result.getSBOutput().insert(0, "\n"));
				out.close();
				returnValues.put("LEMS_stimulus.csv", result.toString());
				PrintWriter out2 = new PrintWriter(theLocation_ISIM+ "/" + "stimulus.csv");
				output = output.replace("\t\n","\n").replaceAll("\\.0\t","").replaceAll("\\.0\n","\n").replaceAll(".*\t","") + "\n";
				out2.print(output);
				returnValues.put("VHDL_ISIM_stimulus.csv", output);
				out2.close();
				out2 = new PrintWriter(theLocation_FPGA+ "/" + "stimulus.csv");
				out2.print(result.getSBOutput());
				out2.close();
				
			}
		}
	
	}
	
}
