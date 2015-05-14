
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.ALL;
use std.textio.all;
use ieee.std_logic_textio.all; -- if you're saving this type of signal
entity tb_simulation is
end tb_simulation;


architecture tb of tb_simulation is

FILE test_out_data: TEXT open WRITE_MODE is "VHDLoutput.csv";component top_synth 
    Port (
		   clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
          init_model : in STD_LOGIC; --SYNCHRONOUS RESET
		   step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
		   step_once_complete : out STD_LOGIC; --signals to the core that a time step has finished
		   eventport_in_spike_aggregate : in STD_LOGIC_VECTOR(511 downto 0);
			neuron_model_eventport_out_spike : out STD_LOGIC;
  neuron_model_param_voltage_v0 : in sfixed (2 downto -22);
  neuron_model_param_voltage_thresh : in sfixed (2 downto -22);
  neuron_model_param_capacitance_C : in sfixed (-33 downto -47);
  neuron_model_param_capacitance_inv_C_inv : in sfixed (47 downto 33);
  neuron_model_exposure_voltage_v : out sfixed (2 downto -22);
  neuron_model_stateCURRENT_voltage_v : out sfixed (2 downto -22);
  neuron_model_stateRESTORE_voltage_v : in sfixed (2 downto -22);
  neuron_model_stateCURRENT_none_spiking : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_spiking : in sfixed (18 downto -13);
  neuron_model_param_none_leak_number : in sfixed (18 downto -13);
  neuron_model_param_voltage_leak_erev : in sfixed (2 downto -22);
  neuron_model_exposure_current_leak_i : out sfixed (-28 downto -53);
  neuron_model_stateCURRENT_current_leak_i : out sfixed (-28 downto -53);
  neuron_model_stateRESTORE_current_leak_i : in sfixed (-28 downto -53);
  neuron_model_param_conductance_leak_passive_conductance : in sfixed (-22 downto -53);
  neuron_model_exposure_conductance_leak_passive_g : out sfixed (-22 downto -53);
  neuron_model_stateCURRENT_conductance_leak_passive_g : out sfixed (-22 downto -53);
  neuron_model_stateRESTORE_conductance_leak_passive_g : in sfixed (-22 downto -53);
  neuron_model_param_none_naChans_number : in sfixed (18 downto -13);
  neuron_model_param_voltage_naChans_erev : in sfixed (2 downto -22);
  neuron_model_exposure_current_naChans_i : out sfixed (-28 downto -53);
  neuron_model_stateCURRENT_current_naChans_i : out sfixed (-28 downto -53);
  neuron_model_stateRESTORE_current_naChans_i : in sfixed (-28 downto -53);
  neuron_model_param_conductance_naChans_na_conductance : in sfixed (-22 downto -53);
  neuron_model_exposure_conductance_naChans_na_g : out sfixed (-22 downto -53);
  neuron_model_stateCURRENT_conductance_naChans_na_g : out sfixed (-22 downto -53);
  neuron_model_stateRESTORE_conductance_naChans_na_g : in sfixed (-22 downto -53);
  neuron_model_param_none_naChans_na_m_instances : in sfixed (18 downto -13);
  neuron_model_exposure_none_naChans_na_m_fcond : out sfixed (18 downto -13);
  neuron_model_exposure_none_naChans_na_m_q : out sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_naChans_na_m_q : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_naChans_na_m_q : in sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_naChans_na_m_fcond : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_naChans_na_m_fcond : in sfixed (18 downto -13);
  neuron_model_param_per_time_naChans_na_m_reverseRatem1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_naChans_na_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_naChans_na_m_reverseRatem1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_naChans_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  neuron_model_stateRESTORE_per_time_naChans_na_m_reverseRatem1_r : in sfixed (18 downto -2);
  neuron_model_param_per_time_naChans_na_m_forwardRatem1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_naChans_na_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_naChans_na_m_forwardRatem1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_naChans_na_m_forwardRatem1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r : out sfixed (18 downto -2);
	 neuron_model_stateRESTORE_per_time_naChans_na_m_forwardRatem1_r : in sfixed (18 downto -2);
  neuron_model_param_none_naChans_na_h_instances : in sfixed (18 downto -13);
  neuron_model_exposure_none_naChans_na_h_fcond : out sfixed (18 downto -13);
  neuron_model_exposure_none_naChans_na_h_q : out sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_naChans_na_h_q : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_naChans_na_h_q : in sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_naChans_na_h_fcond : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_naChans_na_h_fcond : in sfixed (18 downto -13);
  neuron_model_param_per_time_naChans_na_h_reverseRateh1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_naChans_na_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_naChans_na_h_reverseRateh1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_naChans_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  neuron_model_stateRESTORE_per_time_naChans_na_h_reverseRateh1_r : in sfixed (18 downto -2);
  neuron_model_param_per_time_naChans_na_h_forwardRateh1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_naChans_na_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_naChans_na_h_forwardRateh1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_naChans_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  neuron_model_stateRESTORE_per_time_naChans_na_h_forwardRateh1_r : in sfixed (18 downto -2);
  neuron_model_param_none_kChans_number : in sfixed (18 downto -13);
  neuron_model_param_voltage_kChans_erev : in sfixed (2 downto -22);
  neuron_model_exposure_current_kChans_i : out sfixed (-28 downto -53);
  neuron_model_stateCURRENT_current_kChans_i : out sfixed (-28 downto -53);
  neuron_model_stateRESTORE_current_kChans_i : in sfixed (-28 downto -53);
  neuron_model_param_conductance_kChans_k_conductance : in sfixed (-22 downto -53);
  neuron_model_exposure_conductance_kChans_k_g : out sfixed (-22 downto -53);
  neuron_model_stateCURRENT_conductance_kChans_k_g : out sfixed (-22 downto -53);
  neuron_model_stateRESTORE_conductance_kChans_k_g : in sfixed (-22 downto -53);
  neuron_model_param_none_kChans_k_n_instances : in sfixed (18 downto -13);
  neuron_model_exposure_none_kChans_k_n_fcond : out sfixed (18 downto -13);
  neuron_model_exposure_none_kChans_k_n_q : out sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_kChans_k_n_q : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_kChans_k_n_q : in sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_kChans_k_n_fcond : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_kChans_k_n_fcond : in sfixed (18 downto -13);
  neuron_model_param_per_time_kChans_k_n_reverseRaten1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_kChans_k_n_reverseRaten1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_kChans_k_n_reverseRaten1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_kChans_k_n_reverseRaten1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r : out sfixed (18 downto -2);
  neuron_model_stateRESTORE_per_time_kChans_k_n_reverseRaten1_r : in sfixed (18 downto -2);
  neuron_model_param_per_time_kChans_k_n_forwardRaten1_rate : in sfixed (18 downto -2);
  neuron_model_param_voltage_kChans_k_n_forwardRaten1_midpoint : in sfixed (2 downto -22);
  neuron_model_param_voltage_kChans_k_n_forwardRaten1_scale : in sfixed (2 downto -22);
  neuron_model_param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv : in sfixed (22 downto -2);
  neuron_model_exposure_per_time_kChans_k_n_forwardRaten1_r : out sfixed (18 downto -2);
  neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r : out sfixed (18 downto -2);
	 neuron_model_stateRESTORE_per_time_kChans_k_n_forwardRaten1_r : in sfixed (18 downto -2);
  neuron_model_param_time_synapsemodel_tauDecay : in sfixed (6 downto -18);
  neuron_model_param_conductance_synapsemodel_gbase : in sfixed (-22 downto -53);
  neuron_model_param_voltage_synapsemodel_erev : in sfixed (2 downto -22);
  neuron_model_param_time_inv_synapsemodel_tauDecay_inv : in sfixed (18 downto -6);
  neuron_model_exposure_current_synapsemodel_i : out sfixed (-28 downto -53);
  neuron_model_exposure_conductance_synapsemodel_g : out sfixed (-22 downto -53);
  neuron_model_stateCURRENT_conductance_synapsemodel_g : out sfixed (-22 downto -53);
  neuron_model_stateRESTORE_conductance_synapsemodel_g : in sfixed (-22 downto -53);
  neuron_model_stateCURRENT_current_synapsemodel_i : out sfixed (-28 downto -53);
  neuron_model_stateRESTORE_current_synapsemodel_i : in sfixed (-28 downto -53);
           sysparam_time_timestep : in sfixed (-6 downto -22);
           sysparam_time_simtime : in sfixed (6 downto -22)
	);
end component;


	signal clk 			: std_logic := '0';
	signal eog 			: std_logic := '0';
	signal init_model 			: std_logic := '1';
	signal step_once_go 			: std_logic := '0';
	
	signal step_once_complete 			: std_logic := '0';
	signal eventport_in_spike_aggregate : STD_LOGIC_VECTOR(511 downto 0);
	signal sysparam_time_simtime  : sfixed ( 6 downto -22) := to_sfixed (0.0,6 , -22);
	signal Errors		: integer;
	signal sysparam_time_timestep : sfixed (-6 downto -22) := to_sfixed( 5.0E-5 ,-6,-22);
	signal neuron_model_stateCURRENT_voltage_v_int : sfixed (2 downto -22);signal neuron_model_stateCURRENT_none_spiking_int : sfixed (18 downto -13);signal neuron_model_eventport_out_spike_internal : std_logic; signal neuron_model_stateCURRENT_current_leak_i_int : sfixed (-28 downto -53);signal neuron_model_stateCURRENT_conductance_leak_passive_g_int : sfixed (-22 downto -53);signal neuron_model_stateCURRENT_current_naChans_i_int : sfixed (-28 downto -53);signal neuron_model_stateCURRENT_conductance_naChans_na_g_int : sfixed (-22 downto -53);signal neuron_model_stateCURRENT_none_naChans_na_m_q_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_none_naChans_na_m_fcond_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_none_naChans_na_h_q_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_none_naChans_na_h_fcond_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_current_kChans_i_int : sfixed (-28 downto -53);signal neuron_model_stateCURRENT_conductance_kChans_k_g_int : sfixed (-22 downto -53);signal neuron_model_stateCURRENT_none_kChans_k_n_q_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_none_kChans_k_n_fcond_int : sfixed (18 downto -13);signal neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r_int : sfixed (18 downto -2);signal neuron_model_stateCURRENT_conductance_synapsemodel_g_int : sfixed (-22 downto -53);signal neuron_model_stateCURRENT_current_synapsemodel_i_int : sfixed (-28 downto -53);signal neuron_model_eventport_in_synapsemodel_in_internal : std_logic; 
file stimulus: TEXT open read_mode is "stimulus.csv";

begin


top_synth_uut : top_synth 
    port map (	clk => clk,
				init_model => init_model,
		   step_once_go  => step_once_go,
		   step_once_complete  => step_once_complete,
		   eventport_in_spike_aggregate => eventport_in_spike_aggregate,
			neuron_model_eventport_out_spike => neuron_model_eventport_out_spike_internal ,
			neuron_model_param_voltage_v0 => to_sfixed (-0.065,2 , -22),
			neuron_model_param_voltage_thresh => to_sfixed (0.02,2 , -22),
			neuron_model_param_capacitance_C => to_sfixed (1.0E-11,-33 , -47),
			neuron_model_param_capacitance_inv_C_inv => to_sfixed (9.9999998E10,47 , 33),
			neuron_model_stateCURRENT_voltage_v => neuron_model_stateCURRENT_voltage_v_int,
			neuron_model_stateRESTORE_voltage_v => to_sfixed (-0.065,2 , -22),
			neuron_model_stateCURRENT_none_spiking => neuron_model_stateCURRENT_none_spiking_int,
			neuron_model_stateRESTORE_none_spiking => to_sfixed (0.0,18 , -13),
			neuron_model_param_none_leak_number => to_sfixed (300.0,18 , -13),
			neuron_model_param_voltage_leak_erev => to_sfixed (-0.0543,2 , -22),
			neuron_model_stateCURRENT_current_leak_i => neuron_model_stateCURRENT_current_leak_i_int,
			neuron_model_stateRESTORE_current_leak_i => to_sfixed (3.21E-11,-28 , -53),
			neuron_model_param_conductance_leak_passive_conductance => to_sfixed (1.0E-11,-22 , -53),
			neuron_model_stateCURRENT_conductance_leak_passive_g => neuron_model_stateCURRENT_conductance_leak_passive_g_int,
			neuron_model_stateRESTORE_conductance_leak_passive_g => to_sfixed (1.0E-11,-22 , -53),
			neuron_model_param_none_naChans_number => to_sfixed (120000.0,18 , -13),
			neuron_model_param_voltage_naChans_erev => to_sfixed (0.05,2 , -22),
			neuron_model_stateCURRENT_current_naChans_i => neuron_model_stateCURRENT_current_naChans_i_int,
			neuron_model_stateRESTORE_current_naChans_i => to_sfixed (1.2200572E-11,-28 , -53),
			neuron_model_param_conductance_naChans_na_conductance => to_sfixed (1.0E-11,-22 , -53),
			neuron_model_stateCURRENT_conductance_naChans_na_g => neuron_model_stateCURRENT_conductance_naChans_na_g_int,
			neuron_model_stateRESTORE_conductance_naChans_na_g => to_sfixed (8.8409943E-16,-22 , -53),
			neuron_model_param_none_naChans_na_m_instances => to_sfixed (3.0,18 , -13),
			neuron_model_stateCURRENT_none_naChans_na_m_q => neuron_model_stateCURRENT_none_naChans_na_m_q_int,
			neuron_model_stateRESTORE_none_naChans_na_m_q => to_sfixed (0.052932486,18 , -13),
			neuron_model_stateCURRENT_none_naChans_na_m_fcond => neuron_model_stateCURRENT_none_naChans_na_m_fcond_int,
			neuron_model_stateRESTORE_none_naChans_na_m_fcond => to_sfixed (1.4830878E-4,18 , -13),
			neuron_model_param_per_time_naChans_na_m_reverseRatem1_rate => to_sfixed (4000.0,18 , -2),
			neuron_model_param_voltage_naChans_na_m_reverseRatem1_midpoint => to_sfixed (-0.065,2 , -22),
			neuron_model_param_voltage_naChans_na_m_reverseRatem1_scale => to_sfixed (-0.018,2 , -22),
			neuron_model_param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv => to_sfixed (-55.555557,22 , -2),
			neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r => neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r_int,
			neuron_model_stateRESTORE_per_time_naChans_na_m_reverseRatem1_r => to_sfixed (4000.0,18 , -2),
			neuron_model_param_per_time_naChans_na_m_forwardRatem1_rate => to_sfixed (1000.0,18 , -2),
			neuron_model_param_voltage_naChans_na_m_forwardRatem1_midpoint => to_sfixed (-0.04,2 , -22),
			neuron_model_param_voltage_naChans_na_m_forwardRatem1_scale => to_sfixed (0.01,2 , -22),
			neuron_model_param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv => to_sfixed (100.0,22 , -2),
			neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r => neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r_int,
			neuron_model_stateRESTORE_per_time_naChans_na_m_forwardRatem1_r => to_sfixed (223.56372,18 , -2),
			neuron_model_param_none_naChans_na_h_instances => to_sfixed (1.0,18 , -13),
			neuron_model_stateCURRENT_none_naChans_na_h_q => neuron_model_stateCURRENT_none_naChans_na_h_q_int,
			neuron_model_stateRESTORE_none_naChans_na_h_q => to_sfixed (0.5961208,18 , -13),
			neuron_model_stateCURRENT_none_naChans_na_h_fcond => neuron_model_stateCURRENT_none_naChans_na_h_fcond_int,
			neuron_model_stateRESTORE_none_naChans_na_h_fcond => to_sfixed (0.5961208,18 , -13),
			neuron_model_param_per_time_naChans_na_h_reverseRateh1_rate => to_sfixed (1000.0,18 , -2),
			neuron_model_param_voltage_naChans_na_h_reverseRateh1_midpoint => to_sfixed (-0.035,2 , -22),
			neuron_model_param_voltage_naChans_na_h_reverseRateh1_scale => to_sfixed (0.01,2 , -22),
			neuron_model_param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv => to_sfixed (100.0,22 , -2),
			neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r => neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r_int,
			neuron_model_stateRESTORE_per_time_naChans_na_h_reverseRateh1_r => to_sfixed (47.425873,18 , -2),
			neuron_model_param_per_time_naChans_na_h_forwardRateh1_rate => to_sfixed (70.0,18 , -2),
			neuron_model_param_voltage_naChans_na_h_forwardRateh1_midpoint => to_sfixed (-0.065,2 , -22),
			neuron_model_param_voltage_naChans_na_h_forwardRateh1_scale => to_sfixed (-0.02,2 , -22),
			neuron_model_param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv => to_sfixed (-50.0,22 , -2),
			neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r => neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r_int,
			neuron_model_stateRESTORE_per_time_naChans_na_h_forwardRateh1_r => to_sfixed (70.0,18 , -2),
			neuron_model_param_none_kChans_number => to_sfixed (36000.0,18 , -13),
			neuron_model_param_voltage_kChans_erev => to_sfixed (-0.077,2 , -22),
			neuron_model_stateCURRENT_current_kChans_i => neuron_model_stateCURRENT_current_kChans_i_int,
			neuron_model_stateRESTORE_current_kChans_i => to_sfixed (-4.3997334E-11,-28 , -53),
			neuron_model_param_conductance_kChans_k_conductance => to_sfixed (1.0E-11,-22 , -53),
			neuron_model_stateCURRENT_conductance_kChans_k_g => neuron_model_stateCURRENT_conductance_kChans_k_g_int,
			neuron_model_stateRESTORE_conductance_kChans_k_g => to_sfixed (1.0184568E-13,-22 , -53),
			neuron_model_param_none_kChans_k_n_instances => to_sfixed (4.0,18 , -13),
			neuron_model_stateCURRENT_none_kChans_k_n_q => neuron_model_stateCURRENT_none_kChans_k_n_q_int,
			neuron_model_stateRESTORE_none_kChans_k_n_q => to_sfixed (0.3176769,18 , -13),
			neuron_model_stateCURRENT_none_kChans_k_n_fcond => neuron_model_stateCURRENT_none_kChans_k_n_fcond_int,
			neuron_model_stateRESTORE_none_kChans_k_n_fcond => to_sfixed (0.010184568,18 , -13),
			neuron_model_param_per_time_kChans_k_n_reverseRaten1_rate => to_sfixed (125.0,18 , -2),
			neuron_model_param_voltage_kChans_k_n_reverseRaten1_midpoint => to_sfixed (-0.065,2 , -22),
			neuron_model_param_voltage_kChans_k_n_reverseRaten1_scale => to_sfixed (-0.08,2 , -22),
			neuron_model_param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv => to_sfixed (-12.5,22 , -2),
			neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r => neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r_int,
			neuron_model_stateRESTORE_per_time_kChans_k_n_reverseRaten1_r => to_sfixed (125.0,18 , -2),
			neuron_model_param_per_time_kChans_k_n_forwardRaten1_rate => to_sfixed (100.0,18 , -2),
			neuron_model_param_voltage_kChans_k_n_forwardRaten1_midpoint => to_sfixed (-0.055,2 , -22),
			neuron_model_param_voltage_kChans_k_n_forwardRaten1_scale => to_sfixed (0.01,2 , -22),
			neuron_model_param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv => to_sfixed (100.0,22 , -2),
			neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r => neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r_int,
			neuron_model_stateRESTORE_per_time_kChans_k_n_forwardRaten1_r => to_sfixed (58.19767,18 , -2),
			neuron_model_param_time_synapsemodel_tauDecay => to_sfixed (0.003,6 , -18),
			neuron_model_param_conductance_synapsemodel_gbase => to_sfixed (1.0E-9,-22 , -53),
			neuron_model_param_voltage_synapsemodel_erev => to_sfixed (0.0,2 , -22),
			neuron_model_param_time_inv_synapsemodel_tauDecay_inv => to_sfixed (333.33334,18 , -6),
			neuron_model_stateCURRENT_conductance_synapsemodel_g => neuron_model_stateCURRENT_conductance_synapsemodel_g_int,
			neuron_model_stateRESTORE_conductance_synapsemodel_g => to_sfixed (0.0,-22 , -53),
			neuron_model_stateCURRENT_current_synapsemodel_i => neuron_model_stateCURRENT_current_synapsemodel_i_int,
			neuron_model_stateRESTORE_current_synapsemodel_i => to_sfixed (0.0,-28 , -53),

           sysparam_time_timestep => sysparam_time_timestep,
           sysparam_time_simtime => sysparam_time_simtime
		   );
		
receive_data: process 

variable l: line;

variable char : character; 

variable s : STD_LOGIC_VECTOR(0 downto 0); 

begin            
   -- wait for Reset to complete
   -- wait until init_model='1';
   wait until init_model='0';

   
   while not endfile(stimulus) loop

     -- read digital data from input file
     readline(stimulus, l);


     read(l, s);
eventport_in_spike_aggregate(0) <= s(0);
     wait until step_once_go = '1';

   end loop;
    
   
   wait;

 end process receive_data;

	process
	variable L1              : LINE;
    begin
	write(L1, "SimulationTime " );
	write(L1, "neuron_model_spike " );

				write(L1, "neuron_model_stateCURRENT_voltage_v" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_spiking" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_current_leak_i" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_conductance_leak_passive_g" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_current_naChans_i" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_conductance_naChans_na_g" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_naChans_na_m_q" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_naChans_na_m_fcond" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_naChans_na_h_q" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_naChans_na_h_fcond" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_current_kChans_i" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_conductance_kChans_k_g" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_kChans_k_n_q" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_none_kChans_k_n_fcond" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_conductance_synapsemodel_g" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_current_synapsemodel_i" );
				write(L1, " ");
		
				writeline(test_out_data, L1); -- write row to output file
        Wait;
    end process;
	
	clk <= not(clk) after 10 ns;
	
step_once_go_proc: process 


begin            
   -- wait for Reset to complete
   -- wait until init_model='1';
   wait until init_model='0';
   
   wait for 180 ns;
   while 1 = 1 loop
		step_once_go <= '1';
		wait for 20 ns;
		step_once_go <= '0';
		wait until step_once_complete = '1';
		wait until step_once_complete = '0';
   end loop;
    

 end process step_once_go_proc;
 
 
 
 process
 begin
   wait for 20 ns;
	init_model <= '1';
   wait for 20 ns;
	init_model <= '0';
wait;
 end process ;
  
	--
	-- Print the results at each clock tick.
	--
	process(step_once_complete)
	variable L1              : LINE;
	begin
		if (init_model = '1') then
		
				sysparam_time_simtime <= to_sfixed (0.0,6, -22);
		else
			if (step_once_complete'event and step_once_complete = '1' and init_model = '0') then
				sysparam_time_simtime <= resize(sysparam_time_simtime + sysparam_time_timestep,6, -22);
				write(L1, real'image(to_real( sysparam_time_simtime )));  -- nth value in row
				write(L1, " ");
				if (			neuron_model_eventport_out_spike_internal = '1') then
					write(L1, "1 " );
				else
					write(L1, "0 " );
				end if;

				write(L1, real'image(to_real(neuron_model_stateCURRENT_voltage_v_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_spiking_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_current_leak_i_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_conductance_leak_passive_g_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_current_naChans_i_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_conductance_naChans_na_g_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_naChans_na_m_q_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_naChans_na_m_fcond_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_naChans_na_h_q_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_naChans_na_h_fcond_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_current_kChans_i_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_conductance_kChans_k_g_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_kChans_k_n_q_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_none_kChans_k_n_fcond_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_conductance_synapsemodel_g_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_current_synapsemodel_i_int)) );
				write(L1, " ");
		

				
				writeline(test_out_data, L1); -- write row to output file
			end if;
		end if;
	end process;

end tb;
