package ie.nuigalway.lems2hdl;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringWriter;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.collections.KeyValue;
import org.lemsml.jlems.io.util.FileUtil;

public class VHDLErrors {

    ResultsStructure lems_results = null;
    ResultsStructure vhdl_results = null;
    ResultsStructure fpga_results = null;
    Map<Integer,Float[]> error_results = null;
    
    public Map<String,Float> getStartingStateFromLEMSSimulation()
    {
    	Map<String,Float> map = new HashMap<String, Float>();
    	for (int i = 0; i < lems_results.resultsHeader.length;i++)
    	{
    		map.put(lems_results.resultsHeader[i], lems_results.resultsValues.get(0)[i]);    	
    	}
    	return map;
    }
    
    public void loadLEMSResults(Map<String, String> returnValues, String theLocation_LEMS) throws IOException
    {

    	FileReader in = new FileReader(theLocation_LEMS+ "/" + "results.csv");
		lems_results = new ResultsStructure();
		lems_results.convertCSVtoStringMap(in, " ","\t");
		in.close();
		
		//read in LEMS results
		if (!returnValues.containsKey("LEMS_results.csv"))
		{
			in = new FileReader(theLocation_LEMS+ "/" + "results.csv");
			BufferedReader br3 = new BufferedReader(in);
			StringBuilder sb3 = new StringBuilder();
			String line;
			while ((line = br3.readLine()) != null) {
				sb3.append(br3);
				sb3.append("\r\n");
			}
			returnValues.put("LEMS_results.csv", sb3.toString());
		}
    }

    public void loadISIMResults(Map<String, String> returnValues, String theLocation_ISIM) throws IOException
    {
    	//read in ISIM results
		Reader in = new FileReader(theLocation_ISIM+ "/" + "VHDLoutput.csv");
		vhdl_results = new ResultsStructure();
		vhdl_results.convertCSVtoStringMap(in, " ");
		in.close();
		
		if (!returnValues.containsKey("VHDL_results.csv"))
		{
			//return this data
			in = new FileReader(theLocation_ISIM+ "/" + "VHDLoutput.csv");
			BufferedReader br3 = new BufferedReader(in);
			StringBuilder sb3 = new StringBuilder();
			String line;
			while ((line = br3.readLine()) != null) {
				sb3.append(br3);
				sb3.append("\r\n");
			}
			returnValues.put("VHDL_results.csv", sb3.toString());
		}
    
    }

    

    public void loadFPGAResults(Map<String, String> returnValues, String theLocation_FPGA) throws IOException
    {
    	//read in ISIM results
    	FileReader in = new FileReader(theLocation_FPGA+ "/" + "fpga_output.csv");
		fpga_results = new ResultsStructure();
		fpga_results.convertCSVtoStringMap(in, " ");

		if (!returnValues.containsKey("FPGA_results.csv"))
		{
			in = new FileReader(theLocation_FPGA+ "/" + "fpga_output.csv");
			BufferedReader br3 = new BufferedReader(in);
			StringBuilder sb3 = new StringBuilder();
			String line;
			while ((line = br3.readLine()) != null) {
				sb3.append(br3);
				sb3.append("\r\n");
			}
			returnValues.put("FPGA_results.csv", sb3.toString());
		}
    
    }

    
    
	public void compileISIM_LEMS_Errors(Map<String, String> returnValues, VHDLConfiguration config,String theLocation_LEMS,
			String theLocation_ISIM,  String theLocation_FPGA) throws IOException
	{

		System.out.printf("LEMS_results: " + lems_results.resultsValues.size() + " of " + lems_results.resultsValues.get(0).length + " long\r\n");
		System.out.printf("ISIM_results: " + vhdl_results.resultsValues.size() + " of " + vhdl_results.resultsValues.get(0).length + " long\r\n");
		error_results = new HashMap<Integer, Float[]>();
		float maxerror = 0;
		float[] totalError = new float[vhdl_results.resultsHeader.length];
		float[] totalError2 = new float[vhdl_results.resultsHeader.length];
		int totalCount = 0;
		StringBuilder sb = new StringBuilder();
		StringBuilder sb2 = new StringBuilder();
		StringBuilder sb3 = new StringBuilder();
		float  errorInt = 0;
		int count  = 0;
		for (int i = 0; i < vhdl_results.spikeTimes.size() || i < lems_results.spikeTimes.size(); i++)
		{
			if (i < vhdl_results.spikeTimes.size()&& vhdl_results.spikeTimes.get(i) < 0.5f) {
			sb2.append(vhdl_results.spikeTimes.get(i) + " ");}
			if (i < lems_results.spikeTimes.size() && lems_results.spikeTimes.get(i) < 0.5f) {
			sb2.append(lems_results.spikeTimes.get(i) + " ");}
			
			if (i < vhdl_results.spikeTimes.size() && i < lems_results.spikeTimes.size()
					&& vhdl_results.spikeTimes.get(i) < 0.5f  && lems_results.spikeTimes.get(i) < 0.5f)
			{
				float errorSquared = (vhdl_results.spikeTimes.get(i) - lems_results.spikeTimes.get(i)) * (vhdl_results.spikeTimes.get(i) - lems_results.spikeTimes.get(i));
				sb2.append(errorSquared + " \r\n");
				errorInt += errorSquared;
				count++;
			}
		}
		sb2.append("RMS: " + Math.sqrt(errorInt/count));
		float  errorISIInt = 0;
		int countISI  = 0;
		for (int i = 0; i < vhdl_results.ISITimes.size() || i < 
				lems_results.ISITimes.size(); i++)
		{
			if (i < vhdl_results.ISITimes.size() && vhdl_results.spikeTimes.get(i+1) < 0.5f){
			sb3.append(vhdl_results.ISITimes.get(i) + " ");}
			if (i < lems_results.ISITimes.size() && lems_results.spikeTimes.get(i+1) < 0.5f) {
				sb3.append(lems_results.ISITimes.get(i) + " ");}
			
			if (i < vhdl_results.ISITimes.size() && i < lems_results.ISITimes.size() 
					&& vhdl_results.spikeTimes.get(i+1)  < 0.5f  && lems_results.spikeTimes.get(i+1)  < 0.5f)
			{
				float errorSquared = (vhdl_results.ISITimes.get(i) - 
						lems_results.ISITimes.get(i)) * (vhdl_results.ISITimes.get(i) 
								- lems_results.ISITimes.get(i));
				sb3.append(errorSquared + " \r\n");
				errorISIInt += errorSquared;
				countISI+=lems_results.ISITimes.get(i) * lems_results.ISITimes.get(i);
			}
		}
		sb3.append("PRD ISI: " + Math.sqrt(errorISIInt/countISI)*100);
		
		
    	FileReader in = new FileReader(theLocation_LEMS+ "/" + "results.csv");
		
    	in.close();
    	int[] lemsHeaderIndices = getCorrespondingLEMSHeaderIDs(vhdl_results,lems_results);
    	
    	for (int i = 0; i< vhdl_results.resultsHeader.length; i++)
		{
			sb.append("LEMS_" +  vhdl_results.resultsHeader[i] + " " + "ISIM_" +  vhdl_results.resultsHeader[i] + 
					" " + "ERROR_" +  vhdl_results.resultsHeader[i] + " ");
		}
		sb.append(" \r\n");
		for (int i = 0; i < vhdl_results.resultsValues.size() && i < lems_results.resultsValues.size(); i++)
		{
			
			
			for (int j = 0; j < vhdl_results.resultsHeader.length ; j++)
			{

				sb.append(lems_results.resultsValues.get(i)[lemsHeaderIndices[j]]);
				sb.append(" ");

				sb.append(vhdl_results.resultsValues.get(i)[j]);
				sb.append(" ");
				/*if (lems_results.resultsValues.get(i)[lemsHeaderIndices[j]] != 0)
				{*/
					float error = (float) (Math.pow(((vhdl_results.resultsValues.get(i)[j] - 
							lems_results.resultsValues.get(i)[lemsHeaderIndices[j]])),2.0f));
					if (error > maxerror)
						maxerror = error;
					sb.append(error);
					sb.append(" ");
					totalError[j] += (error);
					totalError2[j] += Math.pow(lems_results.resultsValues.get(i)[lemsHeaderIndices[j]],2.0f);
				/*}
				else
					sb.append("0 ");*/
			}
			totalCount++;
			sb.append("\r\n");
		}
		sb.append("\r\n");
		for (int j = 0; j < vhdl_results.resultsHeader.length ; j++)
		{

			sb.append("PRD PRD " + (Math.sqrt(totalError[j]/totalError2[j])*100) + " ");
			
		}
		File vwFile = new File(theLocation_ISIM + "/" + "ISIM_to_LEMS_errors.csv");
		FileUtil.writeStringToFile(sb.toString(), vwFile);
		File vwFile2 = new File(theLocation_ISIM + "/" + "ISIM_to_LEMS_timing_errors.csv");
		FileUtil.writeStringToFile(sb2.toString(), vwFile2);
		File vwFile3 = new File(theLocation_ISIM + "/" + "ISIM_to_LEMS_timing_ISI_errors.csv");
		FileUtil.writeStringToFile(sb3.toString(), vwFile3);
		System.out.printf("max error:" + maxerror  + " percent fractional error\r\n");
		//System.out.printf("average error:" + totalError/totalCount  + " percent fractional error\r\n");
		
	}
	
	private int[]  getCorrespondingLEMSHeaderIDs(ResultsStructure matchStructure,ResultsStructure matchFrom)
	{
		int[] lemsHeaderIndices = new int[matchStructure.resultsHeader.length];
		for (int i = 1; i< matchStructure.resultsHeader.length; i++)
		{
			//get index from LEMS header for this data
			//names are separated by _, try a full match, then go backwards by _ until match found
			int[] underscoresRemoved = new int[matchFrom.resultsHeader.length];
			boolean matchFound = false;
			while (matchFound == false)
			{
				for (int id = 0; id < matchFrom.resultsHeader.length; id++)
				{
					if (matchFrom.resultsHeader[id].toLowerCase().matches
							(matchStructure.resultsHeader[i].toLowerCase()) ||
							matchFrom.resultsHeader[id].toLowerCase().matches
							(matchStructure.resultsHeader[i].toLowerCase().replace("statecurrent", "state").replace("staterestore", "state")) ||
							matchFrom.resultsHeader[id].toLowerCase().replace("statecurrent", "state").replace("staterestore", "state").matches
							(matchStructure.resultsHeader[i].toLowerCase()))
					{
						lemsHeaderIndices[i]  = id;
						matchFound = true;
						break;
					}
				}
			}
			
		}
		return lemsHeaderIndices;
	}
		

	public void compileLEMS_FPGA_Errors(Map<String, String> returnValues, VHDLConfiguration config,String theLocation_LEMS,
			String theLocation_ISIM,  String theLocation_FPGA) throws IOException
	{

			//Compare FPGA results to Simulated Results
		

			System.out.printf("LEMS_results: " + lems_results.resultsValues.size() + " of " + lems_results.resultsValues.get(0).length + " long\r\n");
			System.out.printf("VHDL_results: " + fpga_results.resultsValues.size() + " of " + fpga_results.resultsValues.get(0).length + " long\r\n");
			error_results = new HashMap<Integer, Float[]>();
			float maxerror = 0;
			float[] totalError = new float[fpga_results.resultsHeader.length];
			float[] totalError2 = new float[fpga_results.resultsHeader.length];
			int totalCount = 0;
			StringBuilder sb = new StringBuilder();
			StringBuilder sb2 = new StringBuilder();
			StringBuilder sb3 = new StringBuilder();
			float  errorInt = 0;
			int count = 0;
			for (int i = 0; i < fpga_results.spikeTimes.size() || i < lems_results.spikeTimes.size(); i++)
			{
				if (i < fpga_results.spikeTimes.size()&& fpga_results.spikeTimes.get(i) < 0.5f) {
				sb2.append(fpga_results.spikeTimes.get(i) + " ");}
				if (i < lems_results.spikeTimes.size()&& lems_results.spikeTimes.get(i) < 0.5f) {
				sb2.append(lems_results.spikeTimes.get(i) + " ");}
				
				if (i < fpga_results.spikeTimes.size() && i < lems_results.spikeTimes.size()
						&& fpga_results.spikeTimes.get(i) < 0.5f  && lems_results.spikeTimes.get(i) < 0.5f)
				{
					float errorSquared = (fpga_results.spikeTimes.get(i) - lems_results.spikeTimes.get(i)) * (fpga_results.spikeTimes.get(i) - lems_results.spikeTimes.get(i));
					sb2.append(errorSquared + " \r\n");
					errorInt += errorSquared;
					count++;
				}
			}
			sb2.append("RMS: " + Math.sqrt(errorInt/count));
			float  errorISIInt = 0;
			float countISI  = 0;
			for (int i = 0; i < fpga_results.ISITimes.size() || i < 
					lems_results.ISITimes.size(); i++)
			{
				if (i < fpga_results.ISITimes.size()&& fpga_results.spikeTimes.get(i+1) < 0.5f) {
				sb3.append(fpga_results.ISITimes.get(i) + " ");}
				if (i < lems_results.ISITimes.size()&& lems_results.spikeTimes.get(i+1) < 0.5f) {
					sb3.append(lems_results.ISITimes.get(i) + " ");}
				
				if (i < fpga_results.ISITimes.size() && i < lems_results.ISITimes.size()
						&& fpga_results.spikeTimes.get(i+1) < 0.5f  && lems_results.spikeTimes.get(i+1) < 0.5f)
				{
					float errorSquared = (fpga_results.ISITimes.get(i) - 
							lems_results.ISITimes.get(i)) * (fpga_results.ISITimes.get(i) 
									- lems_results.ISITimes.get(i));
					sb3.append(errorSquared + " \r\n");
					errorISIInt += errorSquared;
					float baseSquared = lems_results.ISITimes.get(i) * lems_results.ISITimes.get(i);
					countISI += baseSquared;
				}
			}
			sb3.append("PRD ISI: " + Math.sqrt(errorISIInt/countISI)*100);
			
			
			FileReader in = new FileReader(theLocation_LEMS+ "/" + "results.csv");
			in.close();

	    	int[] lemsHeaderIndices = getCorrespondingLEMSHeaderIDs(fpga_results,lems_results);
	    	
			for (int i = 0; i< fpga_results.resultsHeader.length; i++)
			{
				sb.append("LEMS_" +  fpga_results.resultsHeader[i] + " " + "FPGA_" +  fpga_results.resultsHeader[i] + " " + "ERROR_" +  fpga_results.resultsHeader[i] + " ");
			}
			sb.append(" \r\n");
			for (int i = 0; i < fpga_results.resultsValues.size() && i < lems_results.resultsValues.size(); i++)
			{
				for (int j = 0; j < fpga_results.resultsValues.get(0).length; j++)
				{

					sb.append(lems_results.resultsValues.get(i)[lemsHeaderIndices[j]]);
					sb.append(" ");

					sb.append(fpga_results.resultsValues.get(i)[j]);
					sb.append(" ");
					/*if (lems_results.resultsValues.get(i)[lemsHeaderIndices[j]] != 0)
					{*/
						float error = (float) (Math.pow(((fpga_results.resultsValues.get(i)[j] - 
								lems_results.resultsValues.get(i)[lemsHeaderIndices[j]])),2.0f));
						if (error > maxerror)
							maxerror = error;
						sb.append(error);
						sb.append(" ");
						totalError[j] += (error);
						totalError2[j] += Math.pow(lems_results.resultsValues.get(i)[lemsHeaderIndices[j]],2.0f);
					/*}
					else
						sb.append("0 ");*/
				}
				sb.append("\r\n");
			}

			for (int j = 0; j < fpga_results.resultsHeader.length ; j++)
			{

				sb.append("PRD PRD " + (Math.sqrt(totalError[j]/totalError2[j])*100) + " ");
				
			}
			
			File vwFile = new File(theLocation_FPGA+ "/" + "FPGA_to_LEMS_errors.csv");
			FileUtil.writeStringToFile(sb.toString(), vwFile);
			File vwFile2 = new File(theLocation_FPGA + "/" + "FPGA_to_LEMS_timing_errors.csv");
			FileUtil.writeStringToFile(sb2.toString(), vwFile2);
			File vwFile3 = new File(theLocation_FPGA + "/" + "FPGA_to_LEMS_timing_ISI_errors.csv");
			FileUtil.writeStringToFile(sb3.toString(), vwFile3);
			System.out.printf("max error:" + maxerror  + " percent fractional error\r\n");
			//System.out.printf("average error:" + totalError/totalCount  + " percent fractional error\r\n");
			
	}
	
	
	public void compileAll_Results(Map<String, String> returnValues, VHDLConfiguration config,String theLocation_LEMS,
			String theLocation_Results) throws IOException
	{
		System.out.printf("LEMS_results: " + lems_results.resultsValues.size() + " of " + 
	lems_results.resultsValues.get(0).length + " long\r\n");
		System.out.printf("ISIM_results: " + vhdl_results.resultsValues.size() + " of " + 
	vhdl_results.resultsValues.get(0).length + " long\r\n");
		System.out.printf("FPGA_results: " + fpga_results.resultsValues.size() + " of " + 
	fpga_results.resultsValues.get(0).length + " long\r\n");
		StringBuilder sb = new StringBuilder();
    	FileReader in = new FileReader(theLocation_LEMS+ "/" + "results.csv");
		in.close();
		int[] lemsHeaderIndices = getCorrespondingLEMSHeaderIDs(fpga_results,lems_results);
    	
		for (int i = 0; i< fpga_results.resultsHeader.length; i++)
		{
			sb.append("LEMS_" +  fpga_results.resultsHeader[i] + " " + "ISIM_" +  fpga_results.resultsHeader[i] + 
					" " + "FPGA_" +  fpga_results.resultsHeader[i] + " ");
		}
		sb.append(" \r\n");
		for (int i = 0; i < fpga_results.resultsValues.size() && i < 
				vhdl_results.resultsValues.size() && i < lems_results.resultsValues.size() ; i++)
		{
			for (int j = 0; j < fpga_results.resultsValues.get(0).length ; j++)
			{

				sb.append(lems_results.resultsValues.get(i)[lemsHeaderIndices[j]]);
				sb.append(" ");

				sb.append(vhdl_results.resultsValues.get(i)[j]);
				sb.append(" ");
				
				sb.append(fpga_results.resultsValues.get(i)[j]);
				sb.append(" ");
				
			}
			sb.append("\r\n");
		}
		File vwFile = new File(theLocation_Results+ "/" + "LEMS_ISIM_FPGA_results.csv");
		FileUtil.writeStringToFile(sb.toString(), vwFile);
	}
	
}
