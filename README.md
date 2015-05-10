# lems2hdl
Repository of ISIM simulation for testing of VHDL export process in org.neuroml.export

To compile the source code you require Maven and the required packages as specified in the maven project file:
FinnK/org.neuroml.export:1.4.2 (VHDL_Dev branch)
FinnK/org.lemsml:0.9.7.3 (VHDL_Dev branch)

To use this program the Xilinx ISIM simulator must be installed. This is available as part of the Xilinx ISE webpack: http://www.xilinx.com/products/design-tools/ise-design-suite/ise-webpack.html
Update the LEMS2HDL.properties file with the correct locations for the required Xilinx Fuse program.
A complete and dependency including jar file is in the repo if you wish to just execute the built lems2hdl program. To start this Jar run:
> lems2hdl.bat LEMSCoreTypes\sample_models\N1_iafRefCell.xml neuron_model isim
