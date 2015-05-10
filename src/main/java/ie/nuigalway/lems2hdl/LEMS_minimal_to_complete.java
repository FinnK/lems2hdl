package ie.nuigalway.lems2hdl;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.io.StringWriter;
import java.util.Map;
import java.util.UUID;

import org.lemsml.jlems.core.expression.ParseError;
import org.lemsml.jlems.core.run.ConnectionError;
import org.lemsml.jlems.core.run.RuntimeError;
import org.lemsml.jlems.core.sim.ContentError;
import org.lemsml.jlems.core.sim.ParseException;
import org.lemsml.jlems.core.sim.Sim;
import org.lemsml.jlems.core.type.Attachments;
import org.lemsml.jlems.core.type.BuildException;
import org.lemsml.jlems.core.type.Component;
import org.lemsml.jlems.core.type.ComponentType;
import org.lemsml.jlems.core.type.Exposure;
import org.lemsml.jlems.core.type.Lems;
import org.lemsml.jlems.core.type.LemsCollection;
import org.lemsml.jlems.core.type.dynamics.ConditionalDerivedVariable;
import org.lemsml.jlems.core.type.dynamics.DerivedVariable;
import org.lemsml.jlems.core.type.dynamics.StateVariable;
import org.lemsml.jlems.core.xml.XMLException;
import org.lemsml.jlems.io.logging.DefaultLogger;
import org.lemsml.jlems.io.out.StringBuilderResultWriter;
import org.lemsml.jlems.io.out.StringBuilderResultWriterFactory;
import org.lemsml.jlems.io.reader.JarResourceInclusionReader;
import org.lemsml.jlems.io.util.FileUtil;
import org.lemsml.jlems.viz.datadisplay.SwingDataViewerFactory;

public class LEMS_minimal_to_complete {

	
	private static void writeOutputColumns(Component comp,ComponentType compT,
			LemsCollection<String> newOutputColumnsNeuron, StringBuilder resultsHeader,
			String parentName,String parentNamePath) throws ContentError
	{
		newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_spike\" quantity=\"neuron_model_instance[0]/spike\" />");
		resultsHeader.append("neuron_model_spike ");
		for (StateVariable exp : compT.getDynamics().stateVariables) {
			newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_stateCURRENT_" +  
		exp.getDimension().name + parentName + "_"  + exp.getName() + "\" quantity=\"neuron_model_instance[0]/" 
				+parentNamePath	+ exp.getName() + "\" />");
			resultsHeader.append("neuron_model_stateCURRENT_" +  exp.getDimension().name + parentName +
					"_"  + exp.getName() + " " );
		}
		for (DerivedVariable exp : compT.getDynamics().derivedVariables) {
			newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_stateCURRENT_" +  
		exp.getDimension().name + parentName + "_"  + exp.getName() + "\" quantity=\"neuron_model_instance[0]/" 
		+parentNamePath	+ exp.getName() + "\" />");
			resultsHeader.append("neuron_model_stateCURRENT_" +  exp.getDimension().name + parentName +
					"_"  + exp.getName() + " " );
		}
		for (ConditionalDerivedVariable exp : compT.getDynamics().conditionalDerivedVariables) {
			newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_stateCURRENT_" +  
		exp.getDimension().name + parentName + "_"  + exp.getName() + "\" quantity=\"neuron_model_instance[0]/" 
		+parentNamePath	+ exp.getName() + "\" />");
			resultsHeader.append("neuron_model_stateCURRENT_" +  exp.getDimension().name + parentName +
					"_"  + exp.getName() + " " );
		}
		for (Component childComp : comp.getAllChildren()) {
			ComponentType b = childComp.r_type;
			String parentNameNew = parentName + "_" + childComp.getID();
			String parentNamePathNew = parentNamePath + childComp.getID()+ "/" ;
			writeOutputColumns(childComp,b,newOutputColumnsNeuron,resultsHeader,
					parentNameNew,parentNamePathNew);
		}
	}
	
	
	public static String createCompleteLEMSFromMinimalModel( Map<String, String> returnValues, VHDLConfiguration config,String lemsModel, 
			String theLocation_LEMS, String theLocation_ISIM, String theLocation_FPGA,
			StringBuilder resultsHeader, double simTime, double simTimeStep) throws Exception
	{
		String srcStrDup = null;Lems lems = null;
		 StringBuilderResultWriterFactory.initialize();

		 
	     SwingDataViewerFactory.initialize();
	     DefaultLogger.initialize();

	     
		 File commonFile = new File(config.COMMONFILEPATH + "/" + "Ex_common.xml");
		 JarResourceInclusionReader jrir = new JarResourceInclusionReader(commonFile);
   	
	    Sim sim;
		try {
			String srcStr = jrir.read();
			srcStrDup = srcStr;
			//replace with the passed in neuron
			srcStr = srcStr.replace("[content neuron_model_instance]", lemsModel);
			srcStrDup = srcStrDup.replace("[content neuron_model_instance]", lemsModel);
			srcStr = srcStr.replace("[content synapse_model_instance]", "");
			srcStr = srcStr.replace("[content population_instance]", "");
			srcStr = srcStr.replace("[content outputcolumnsneuron]", "");
			srcStr = srcStr.replace("[content outputcolumnsstim]", "");
			srcStr = srcStr.replace("[content simulationTime]", (simTime * 1000) + "ms");
			srcStr = srcStr.replace("[content simulationTimeStep]", (simTimeStep * 1000) + "ms");
			
			sim = new Sim(srcStr.toString());
	        sim.readModel();
			lems = sim.getLems();
			
			//now go through design and get all attachments
			int id = 1;
			LemsCollection<String> newSpikeGens = new LemsCollection<String>();
			LemsCollection<String> newPopulations = new LemsCollection<String>();
			LemsCollection<String> newPopulationsSyns = new LemsCollection<String>();
			LemsCollection<String> newOutputColumns = new LemsCollection<String>();
			LemsCollection<String> newOutputColumnsNeuron = new LemsCollection<String>();
			StringBuilder stimulusHeader = new StringBuilder();
			resultsHeader.append("time " );
			
			ComponentType a = lems.getComponent("neuron_model").r_type;

			writeOutputColumns(lems.getComponent("neuron_model"),a,newOutputColumnsNeuron,
					resultsHeader,"","");
			
			LemsCollection<Attachments> attachmentss = lems.getComponent("neuron_model").getComponentType().getAttachmentss();
			for (Attachments attachments : attachmentss) {
				for (Component comp : lems.getComponents()) {
					String attachmentType = attachments.getComponentType().getName();
					if ( attachmentType.matches(comp.getComponentType().name) || comp.getComponentType().extendsType(lems.getComponentTypeByName(attachmentType)))
					{
						
						if (comp.getComponentType().eventPorts.getByName("in").isDirectionIn())
						{
							ComponentType ct = comp.getComponentType();
							newSpikeGens.add("<spikeGenerator id=\"spikeGen_" + id + "\" period=\"" + (50 * id) + "ms\"/>");
							
							newPopulations.add("<population id=\"spikeGen_" + id + "_instance\" component=\"spikeGen_" + id + 
									"\" size=\"1\" />");
						    
							if (ct.getPropertys().hasName("weight"))
							{
								newPopulationsSyns.add("<synapticConnectionWD  id=\"spikeGen_" + id + "_conn\" from=\"spikeGen_" + id + "_instance[0]\" to=\"neuron_model_instance[0]\" synapse=\"" +
										comp.getID() + "\" weight=\"1\" delay=\"0ms\" " +
										" destination=\"" + attachments.name + "\"/>");
							}
							else
							{
								newPopulationsSyns.add("<synapticConnection  id=\"spikeGen_" + id + "_conn\" from=\"spikeGen_" + id + "_instance[0]\" to=\"neuron_model_instance[0]\" synapse=\"" +
										comp.getID() + "\" destination=\"" + attachments.name + "\"/>");
							}
							
							newOutputColumns.add("<OutputColumn id=\"spikeGen_" + id + "_instance_spike\" quantity=\"spikeGen_" + id + "_instance[0]/spike_state\" />");
							stimulusHeader.append("spikeGen_" + id);
							/*for (StateVariable exp : comp.r_type.getDynamics().stateVariables) {
								newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_stateCURRENT_" +  exp.getDimension().name + "_" +  comp.getID() + "_" + exp.getName() + "\" quantity=\"neuron_model_instance[0]/" + comp.getID() +  "/" + exp.getName() + "\" />");
								resultsHeader.append("neuron_model_stateCURRENT_" +  exp.getDimension().name + "_" + comp.getID() + "_" + exp.getName() + " " );
							}
							for (DerivedVariable exp : comp.r_type.getDynamics().derivedVariables) {
								newOutputColumnsNeuron.add("<OutputColumn id=\"neuron_model_stateCURRENT_" +  exp.getDimension().name + "_" +  comp.getID() + "_" + exp.getName() + "\" quantity=\"neuron_model_instance[0]/" + comp.getID() +  "/" + exp.getName() + "\" />");
								resultsHeader.append("neuron_model_stateCURRENT_" +  exp.getDimension().name + "_" + comp.getID() + "_" + exp.getName() + " " );
							}*/
							

							writeOutputColumns(comp,comp.r_type,newOutputColumnsNeuron,
									resultsHeader, "_"+comp.getID(),comp.getID()+"/");
						}
						else
						{

							newPopulationsSyns.add("<explicitInput id=\"explicit_input_" + id + "\" target=\"neuron_model_instance[0]\" input=\"" + comp.getID() + "\" destination=\"" + attachments.name + "\"/>");
							
						}
						
					    id++;
					}
				}
			}
			
			StringBuilder sb = new StringBuilder();
			for (String c : newSpikeGens) {
				sb.append(c + "\r\n");
			}
			srcStrDup = srcStrDup.replace("[content synapse_model_instance]", sb.toString()); sb = new StringBuilder();
			for (String c2 : newPopulations) {
				sb.append(c2 + "\r\n");
			}
			for (String c3 : newPopulationsSyns) {
				sb.append(c3 + "\r\n");
			}
			srcStrDup = srcStrDup.replace("[content population_instance]", sb.toString()); sb = new StringBuilder();
			for (String c : newOutputColumns) {
				sb.append(c + "\r\n");
			}
			srcStrDup = srcStrDup.replace("[content outputcolumnsstim]", sb.toString()); sb = new StringBuilder();
			for (String c : newOutputColumnsNeuron) {
				sb.append(c + "\r\n");
			}
			srcStrDup = srcStrDup.replace("[content outputcolumnsneuron]", sb.toString());
			srcStrDup = srcStrDup.replace("[content simulationTime]", (simTime * 1000) + "ms");
			srcStrDup = srcStrDup.replace("[content simulationTimeStep]", (simTimeStep * 1000) + "ms");
			//srcStrDup = srcStrDup.replace("[content outputcolumns]", 
		    //        "<OutputColumn id=\"spikeGen_1_instance\" quantity=\"spikeGen_1_instance[0]/spike\" />" +
		    //        "<OutputColumn id=\"spikeGen_2_instance\" quantity=\"spikeGen_2_instance[0]/spike\" />");
			
			File completeLEMSFile = new File(theLocation_LEMS+ "/" + "completeLEMS.xml");
			FileUtil.writeStringToFile(srcStrDup.toString(), completeLEMSFile);
			
			return srcStrDup;

			
		} catch (Exception e) {
			StringWriter sw = new StringWriter();
			PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			throw new Exception("LEMS model run failed:\r\n" + sw.toString());
		}
	}
	
}
