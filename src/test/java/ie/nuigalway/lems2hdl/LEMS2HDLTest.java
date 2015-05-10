package ie.nuigalway.lems2hdl;
import java.io.File;

import org.lemsml.jlems.io.reader.JarResourceInclusionReader;

import junit.framework.TestCase;


public class LEMS2HDLTest extends TestCase {

	public void testConversion() {
		String[] args = {"..\\..\\LEMSCoreTypesForPaper\\sample_models\\N1_iafRefCell.xml",
				"neuron_model",
				"isim"};
		Main.main(args);
	}

}
