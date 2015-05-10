package ie.nuigalway.lems2hdl;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.Reader;
import java.util.HashMap;
import java.util.Map;

public class ResultsStructure  {

	public Map<Integer,Float[]> resultsValues = new HashMap<Integer, Float[]>();
	public String[] resultsHeader = null;
	public Map<Integer,Float> spikeTimes = new HashMap<Integer, Float>();
	public Map<Integer,Float> ISITimes = new HashMap<Integer, Float>();
	

	public void convertCSVtoStringMap(Reader in, String cvsSplitBy)
	{
		convertCSVtoStringMap(in, cvsSplitBy,cvsSplitBy);
	}
	public void convertCSVtoStringMap(Reader in, String cvsSplitBy,String cvsSplitByData)
	{
		
		 
		BufferedReader br = null;
		String line = "";
	 
		try {
	 
			br = new BufferedReader(in);
			int lineID= 0;
			line = br.readLine();
			String[] valuesString = line.split(cvsSplitBy);
			Float[] values = new Float[valuesString.length];
			resultsHeader = valuesString;
			int TimeId = 0;
			int SpikeId = 0;
			for (int i  =0; i < resultsHeader.length;i++)
			{
				if (resultsHeader[i].matches("neuron_model_spike"))
				{
					SpikeId = i;
					break;
				}
			}
					
			while ((line = br.readLine()) != null) {
				valuesString = line.split(cvsSplitByData);
				values = new Float[valuesString.length];
			        // use comma as separator
				try{
					for (int i = 0; i < values.length; i++)
					{
						values[i] = Float.parseFloat(valuesString[i]);
					}
					if (values[SpikeId] == 1)
					{
						spikeTimes.put(spikeTimes.size(), values[TimeId]);
						if (spikeTimes.size() > 1)
						ISITimes.put(ISITimes.size(),
								 values[TimeId] - spikeTimes.get(spikeTimes.size()-2));
					}
					resultsValues.put(lineID, values);
					lineID++;
				}
				catch (Exception e)
				{
					
				}
			}
	 
		}  catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	 
		System.out.println("Done");
	  }
	
	
}
