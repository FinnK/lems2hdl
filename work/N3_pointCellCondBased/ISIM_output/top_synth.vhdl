
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.ALL;
use std.textio.all;
use ieee.std_logic_textio.all; -- if you're saving this type of signal
use IEEE.numeric_std.all;











 
entity top_synth is
    Port ( clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
           init_model: in STD_LOGIC; --SYNCHRONOUS RESET
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

           sysparam_time_timestep : sfixed (-6 downto -22);
           sysparam_time_simtime : sfixed (6 downto -22)
		   );
end top_synth;

architecture top of top_synth is

signal step_once_complete_int : STD_LOGIC;
signal seven_steps_done : STD_LOGIC;
signal step_once_go_int : STD_LOGIC := '0';
signal seven_steps_done_shot_done : STD_LOGIC;
signal seven_steps_done_shot : STD_LOGIC;
signal seven_steps_done_shot2 : STD_LOGIC;
signal COUNT : unsigned(2 downto 0) := "110";
signal seven_steps_done_next : STD_LOGIC;
signal COUNT_next : unsigned(2 downto 0) := "110";
signal step_once_go_int_next : STD_LOGIC := '0';
signal neuron_model_eventport_out_spike_int : STD_LOGIC;
signal neuron_model_eventport_out_spike_int2 : STD_LOGIC;
signal neuron_model_eventport_out_spike_int3 : STD_LOGIC;

component neuron_model
    Port ( clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
           init_model: in STD_LOGIC; --SYNCHRONOUS RESET
		   step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
		   step_once_complete : out STD_LOGIC; --signals to the core that a time step has finished
		   eventport_in_spike_aggregate : in STD_LOGIC_VECTOR(511 downto 0);
		   			eventport_out_spike : out STD_LOGIC;
  param_voltage_v0 : in sfixed (2 downto -22);
  param_voltage_thresh : in sfixed (2 downto -22);
  param_capacitance_C : in sfixed (-33 downto -47);
  param_capacitance_inv_C_inv : in sfixed (47 downto 33);
  exposure_voltage_v : out sfixed (2 downto -22);
  statevariable_voltage_v_out : out sfixed (2 downto -22);
  statevariable_voltage_v_in : in sfixed (2 downto -22);
  statevariable_none_spiking_out : out sfixed (18 downto -13);
  statevariable_none_spiking_in : in sfixed (18 downto -13);
  param_none_leak_number : in sfixed (18 downto -13);
  param_voltage_leak_erev : in sfixed (2 downto -22);
  exposure_current_leak_i : out sfixed (-28 downto -53);
  derivedvariable_current_leak_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_leak_i_in : in sfixed (-28 downto -53);
  param_conductance_leak_passive_conductance : in sfixed (-22 downto -53);
  exposure_conductance_leak_passive_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_leak_passive_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_leak_passive_g_in : in sfixed (-22 downto -53);
  param_none_naChans_number : in sfixed (18 downto -13);
  param_voltage_naChans_erev : in sfixed (2 downto -22);
  exposure_current_naChans_i : out sfixed (-28 downto -53);
  derivedvariable_current_naChans_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_naChans_i_in : in sfixed (-28 downto -53);
  param_conductance_naChans_na_conductance : in sfixed (-22 downto -53);
  exposure_conductance_naChans_na_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_naChans_na_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_naChans_na_g_in : in sfixed (-22 downto -53);
  param_none_naChans_na_m_instances : in sfixed (18 downto -13);
  exposure_none_naChans_na_m_fcond : out sfixed (18 downto -13);
  exposure_none_naChans_na_m_q : out sfixed (18 downto -13);
  statevariable_none_naChans_na_m_q_out : out sfixed (18 downto -13);
  statevariable_none_naChans_na_m_q_in : in sfixed (18 downto -13);
  derivedvariable_none_naChans_na_m_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_naChans_na_m_fcond_in : in sfixed (18 downto -13);
  param_per_time_naChans_na_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_naChans_na_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_none_naChans_na_h_instances : in sfixed (18 downto -13);
  exposure_none_naChans_na_h_fcond : out sfixed (18 downto -13);
  exposure_none_naChans_na_h_q : out sfixed (18 downto -13);
  statevariable_none_naChans_na_h_q_out : out sfixed (18 downto -13);
  statevariable_none_naChans_na_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_naChans_na_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_naChans_na_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_naChans_na_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_naChans_na_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  param_none_kChans_number : in sfixed (18 downto -13);
  param_voltage_kChans_erev : in sfixed (2 downto -22);
  exposure_current_kChans_i : out sfixed (-28 downto -53);
  derivedvariable_current_kChans_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_kChans_i_in : in sfixed (-28 downto -53);
  param_conductance_kChans_k_conductance : in sfixed (-22 downto -53);
  exposure_conductance_kChans_k_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_kChans_k_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_kChans_k_g_in : in sfixed (-22 downto -53);
  param_none_kChans_k_n_instances : in sfixed (18 downto -13);
  exposure_none_kChans_k_n_fcond : out sfixed (18 downto -13);
  exposure_none_kChans_k_n_q : out sfixed (18 downto -13);
  statevariable_none_kChans_k_n_q_out : out sfixed (18 downto -13);
  statevariable_none_kChans_k_n_q_in : in sfixed (18 downto -13);
  derivedvariable_none_kChans_k_n_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_kChans_k_n_fcond_in : in sfixed (18 downto -13);
  param_per_time_kChans_k_n_reverseRaten1_rate : in sfixed (18 downto -2);
  param_voltage_kChans_k_n_reverseRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_kChans_k_n_reverseRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_kChans_k_n_reverseRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in : in sfixed (18 downto -2);
  param_per_time_kChans_k_n_forwardRaten1_rate : in sfixed (18 downto -2);
  param_voltage_kChans_k_n_forwardRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_kChans_k_n_forwardRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_kChans_k_n_forwardRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in : in sfixed (18 downto -2);
  param_time_synapsemodel_tauDecay : in sfixed (6 downto -18);
  param_conductance_synapsemodel_gbase : in sfixed (-22 downto -53);
  param_voltage_synapsemodel_erev : in sfixed (2 downto -22);
  param_time_inv_synapsemodel_tauDecay_inv : in sfixed (18 downto -6);
  exposure_current_synapsemodel_i : out sfixed (-28 downto -53);
  exposure_conductance_synapsemodel_g : out sfixed (-22 downto -53);
  statevariable_conductance_synapsemodel_g_out : out sfixed (-22 downto -53);
  statevariable_conductance_synapsemodel_g_in : in sfixed (-22 downto -53);
  derivedvariable_current_synapsemodel_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_synapsemodel_i_in : in sfixed (-28 downto -53);

           sysparam_time_timestep : sfixed (-6 downto -22);
           sysparam_time_simtime : sfixed (6 downto -22)
		   );
end component;



	signal neuron_model_eventport_out_spike_out : STD_LOGIC := '0';
	signal neuron_model_statevariable_voltage_v_out_int : sfixed (2 downto -22);signal neuron_model_statevariable_voltage_v_in_int : sfixed (2 downto -22);signal neuron_model_statevariable_none_spiking_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_spiking_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_current_leak_i_out_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_current_leak_i_in_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_conductance_leak_passive_g_out_int : sfixed (-22 downto -53);signal neuron_model_derivedvariable_conductance_leak_passive_g_in_int : sfixed (-22 downto -53);signal neuron_model_derivedvariable_current_naChans_i_out_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_current_naChans_i_in_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_conductance_naChans_na_g_out_int : sfixed (-22 downto -53);signal neuron_model_derivedvariable_conductance_naChans_na_g_in_int : sfixed (-22 downto -53);signal neuron_model_statevariable_none_naChans_na_m_q_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_naChans_na_m_q_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_naChans_na_m_fcond_out_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_naChans_na_m_fcond_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in_int : sfixed (18 downto -2);signal neuron_model_statevariable_none_naChans_na_h_q_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_naChans_na_h_q_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_naChans_na_h_fcond_out_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_naChans_na_h_fcond_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_current_kChans_i_out_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_current_kChans_i_in_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_conductance_kChans_k_g_out_int : sfixed (-22 downto -53);signal neuron_model_derivedvariable_conductance_kChans_k_g_in_int : sfixed (-22 downto -53);signal neuron_model_statevariable_none_kChans_k_n_q_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_kChans_k_n_q_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_kChans_k_n_fcond_out_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_none_kChans_k_n_fcond_in_int : sfixed (18 downto -13);signal neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out_int : sfixed (18 downto -2);signal neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in_int : sfixed (18 downto -2);signal neuron_model_statevariable_conductance_synapsemodel_g_out_int : sfixed (-22 downto -53);signal neuron_model_statevariable_conductance_synapsemodel_g_in_int : sfixed (-22 downto -53);signal neuron_model_derivedvariable_current_synapsemodel_i_out_int : sfixed (-28 downto -53);signal neuron_model_derivedvariable_current_synapsemodel_i_in_int : sfixed (-28 downto -53);
begin


neuron_model_uut : neuron_model
    port map (	clk => clk,
				init_model=> init_model,
		   step_once_go  => step_once_go_int,
		   step_once_complete  => step_once_complete_int,
		   eventport_in_spike_aggregate => eventport_in_spike_aggregate,
		   			eventport_out_spike => neuron_model_eventport_out_spike_int ,
			param_voltage_v0 => neuron_model_param_voltage_v0 ,
			param_voltage_thresh => neuron_model_param_voltage_thresh ,
			param_capacitance_C => neuron_model_param_capacitance_C ,
			param_capacitance_inv_C_inv => neuron_model_param_capacitance_inv_C_inv ,
			statevariable_voltage_v_out => neuron_model_statevariable_voltage_v_out_int,
			statevariable_voltage_v_in => neuron_model_statevariable_voltage_v_in_int,
			statevariable_none_spiking_out => neuron_model_statevariable_none_spiking_out_int,
			statevariable_none_spiking_in => neuron_model_statevariable_none_spiking_in_int,
			param_none_leak_number => neuron_model_param_none_leak_number ,
			param_voltage_leak_erev => neuron_model_param_voltage_leak_erev ,
			derivedvariable_current_leak_i_out => neuron_model_derivedvariable_current_leak_i_out_int, 
			derivedvariable_current_leak_i_in => neuron_model_derivedvariable_current_leak_i_in_int,
			param_conductance_leak_passive_conductance => neuron_model_param_conductance_leak_passive_conductance ,
			derivedvariable_conductance_leak_passive_g_out => neuron_model_derivedvariable_conductance_leak_passive_g_out_int, 
			derivedvariable_conductance_leak_passive_g_in => neuron_model_derivedvariable_conductance_leak_passive_g_in_int,
			param_none_naChans_number => neuron_model_param_none_naChans_number ,
			param_voltage_naChans_erev => neuron_model_param_voltage_naChans_erev ,
			derivedvariable_current_naChans_i_out => neuron_model_derivedvariable_current_naChans_i_out_int, 
			derivedvariable_current_naChans_i_in => neuron_model_derivedvariable_current_naChans_i_in_int,
			param_conductance_naChans_na_conductance => neuron_model_param_conductance_naChans_na_conductance ,
			derivedvariable_conductance_naChans_na_g_out => neuron_model_derivedvariable_conductance_naChans_na_g_out_int, 
			derivedvariable_conductance_naChans_na_g_in => neuron_model_derivedvariable_conductance_naChans_na_g_in_int,
			param_none_naChans_na_m_instances => neuron_model_param_none_naChans_na_m_instances ,
			statevariable_none_naChans_na_m_q_out => neuron_model_statevariable_none_naChans_na_m_q_out_int,
			statevariable_none_naChans_na_m_q_in => neuron_model_statevariable_none_naChans_na_m_q_in_int,
			derivedvariable_none_naChans_na_m_fcond_out => neuron_model_derivedvariable_none_naChans_na_m_fcond_out_int, 
			derivedvariable_none_naChans_na_m_fcond_in => neuron_model_derivedvariable_none_naChans_na_m_fcond_in_int,
			param_per_time_naChans_na_m_reverseRatem1_rate => neuron_model_param_per_time_naChans_na_m_reverseRatem1_rate ,
			param_voltage_naChans_na_m_reverseRatem1_midpoint => neuron_model_param_voltage_naChans_na_m_reverseRatem1_midpoint ,
			param_voltage_naChans_na_m_reverseRatem1_scale => neuron_model_param_voltage_naChans_na_m_reverseRatem1_scale ,
			param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv => neuron_model_param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv ,
			derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out => neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out_int, 
			derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in => neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in_int,
			param_per_time_naChans_na_m_forwardRatem1_rate => neuron_model_param_per_time_naChans_na_m_forwardRatem1_rate ,
			param_voltage_naChans_na_m_forwardRatem1_midpoint => neuron_model_param_voltage_naChans_na_m_forwardRatem1_midpoint ,
			param_voltage_naChans_na_m_forwardRatem1_scale => neuron_model_param_voltage_naChans_na_m_forwardRatem1_scale ,
			param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv => neuron_model_param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv ,
			derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out => neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out_int,
			derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in => neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in_int,
			param_none_naChans_na_h_instances => neuron_model_param_none_naChans_na_h_instances ,
			statevariable_none_naChans_na_h_q_out => neuron_model_statevariable_none_naChans_na_h_q_out_int,
			statevariable_none_naChans_na_h_q_in => neuron_model_statevariable_none_naChans_na_h_q_in_int,
			derivedvariable_none_naChans_na_h_fcond_out => neuron_model_derivedvariable_none_naChans_na_h_fcond_out_int, 
			derivedvariable_none_naChans_na_h_fcond_in => neuron_model_derivedvariable_none_naChans_na_h_fcond_in_int,
			param_per_time_naChans_na_h_reverseRateh1_rate => neuron_model_param_per_time_naChans_na_h_reverseRateh1_rate ,
			param_voltage_naChans_na_h_reverseRateh1_midpoint => neuron_model_param_voltage_naChans_na_h_reverseRateh1_midpoint ,
			param_voltage_naChans_na_h_reverseRateh1_scale => neuron_model_param_voltage_naChans_na_h_reverseRateh1_scale ,
			param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv => neuron_model_param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv ,
			derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out => neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out_int, 
			derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in => neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in_int,
			param_per_time_naChans_na_h_forwardRateh1_rate => neuron_model_param_per_time_naChans_na_h_forwardRateh1_rate ,
			param_voltage_naChans_na_h_forwardRateh1_midpoint => neuron_model_param_voltage_naChans_na_h_forwardRateh1_midpoint ,
			param_voltage_naChans_na_h_forwardRateh1_scale => neuron_model_param_voltage_naChans_na_h_forwardRateh1_scale ,
			param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv => neuron_model_param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv ,
			derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out => neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out_int, 
			derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in => neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in_int,
			param_none_kChans_number => neuron_model_param_none_kChans_number ,
			param_voltage_kChans_erev => neuron_model_param_voltage_kChans_erev ,
			derivedvariable_current_kChans_i_out => neuron_model_derivedvariable_current_kChans_i_out_int, 
			derivedvariable_current_kChans_i_in => neuron_model_derivedvariable_current_kChans_i_in_int,
			param_conductance_kChans_k_conductance => neuron_model_param_conductance_kChans_k_conductance ,
			derivedvariable_conductance_kChans_k_g_out => neuron_model_derivedvariable_conductance_kChans_k_g_out_int, 
			derivedvariable_conductance_kChans_k_g_in => neuron_model_derivedvariable_conductance_kChans_k_g_in_int,
			param_none_kChans_k_n_instances => neuron_model_param_none_kChans_k_n_instances ,
			statevariable_none_kChans_k_n_q_out => neuron_model_statevariable_none_kChans_k_n_q_out_int,
			statevariable_none_kChans_k_n_q_in => neuron_model_statevariable_none_kChans_k_n_q_in_int,
			derivedvariable_none_kChans_k_n_fcond_out => neuron_model_derivedvariable_none_kChans_k_n_fcond_out_int, 
			derivedvariable_none_kChans_k_n_fcond_in => neuron_model_derivedvariable_none_kChans_k_n_fcond_in_int,
			param_per_time_kChans_k_n_reverseRaten1_rate => neuron_model_param_per_time_kChans_k_n_reverseRaten1_rate ,
			param_voltage_kChans_k_n_reverseRaten1_midpoint => neuron_model_param_voltage_kChans_k_n_reverseRaten1_midpoint ,
			param_voltage_kChans_k_n_reverseRaten1_scale => neuron_model_param_voltage_kChans_k_n_reverseRaten1_scale ,
			param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv => neuron_model_param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv ,
			derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out => neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out_int, 
			derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in => neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in_int,
			param_per_time_kChans_k_n_forwardRaten1_rate => neuron_model_param_per_time_kChans_k_n_forwardRaten1_rate ,
			param_voltage_kChans_k_n_forwardRaten1_midpoint => neuron_model_param_voltage_kChans_k_n_forwardRaten1_midpoint ,
			param_voltage_kChans_k_n_forwardRaten1_scale => neuron_model_param_voltage_kChans_k_n_forwardRaten1_scale ,
			param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv => neuron_model_param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv ,
			derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out => neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out_int,
			derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in => neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in_int,
			param_time_synapsemodel_tauDecay => neuron_model_param_time_synapsemodel_tauDecay ,
			param_conductance_synapsemodel_gbase => neuron_model_param_conductance_synapsemodel_gbase ,
			param_voltage_synapsemodel_erev => neuron_model_param_voltage_synapsemodel_erev ,
			param_time_inv_synapsemodel_tauDecay_inv => neuron_model_param_time_inv_synapsemodel_tauDecay_inv ,
			statevariable_conductance_synapsemodel_g_out => neuron_model_statevariable_conductance_synapsemodel_g_out_int,
			statevariable_conductance_synapsemodel_g_in => neuron_model_statevariable_conductance_synapsemodel_g_in_int,
			derivedvariable_current_synapsemodel_i_out => neuron_model_derivedvariable_current_synapsemodel_i_out_int, 
			derivedvariable_current_synapsemodel_i_in => neuron_model_derivedvariable_current_synapsemodel_i_in_int,

           sysparam_time_timestep => sysparam_time_timestep,
           sysparam_time_simtime => sysparam_time_simtime
		   );
		

count_proc_comb:process(init_model,step_once_complete_int,COUNT,step_once_go)
  	begin 
		seven_steps_done_next <= '0';
		COUNT_next <= COUNT;
		step_once_go_int_next <= '0';
			if (init_model='1') then 
				seven_steps_done_next <= '0';
				COUNT_next <= "110";
		        step_once_go_int_next <= '0';
			else
				if step_once_complete_int = '1'	then
					if (COUNT = "110") then
						seven_steps_done_next <= '1';
					    COUNT_next <= "110";
						step_once_go_int_next <= '0';
					else
						seven_steps_done_next <= '0';
						COUNT_next <= COUNT + 1;
						step_once_go_int_next <= '1';
					end if;
				elsif step_once_go = '1' then
					seven_steps_done_next <= '0';
					COUNT_next <= "000";
					step_once_go_int_next <= '1';
				else
		            seven_steps_done_next <= '0';
		            COUNT_next <= COUNT;
					step_once_go_int_next <= '0';
				end if;
			end if;
end process count_proc_comb;



count_proc_syn:process(clk)
  	begin 
      if rising_edge(clk) then  
		 if init_model = '1' then
		    COUNT <= "110";
			 seven_steps_done <= '1';
			 step_once_go_int <= '0';
		  else
		    COUNT <= COUNT_next;
		    seven_steps_done <= seven_steps_done_next;
		    step_once_go_int <= step_once_go_int_next;
		  end if;		end if;
end process count_proc_syn;



shot_process:process(clk)
begin
	if rising_edge(clk) then
			if (init_model='1') then 
				seven_steps_done_shot <= '0';
				seven_steps_done_shot_done <= '1';
			else
				if seven_steps_done = '1' and seven_steps_done_shot_done = '0' then
					seven_steps_done_shot <= '1';
					seven_steps_done_shot_done <= '1';
				elsif seven_steps_done_shot = '1' then
					seven_steps_done_shot <= '0';
				elsif seven_steps_done = '0' then
					seven_steps_done_shot <= '0';
					seven_steps_done_shot_done <= '0';
				end if;
			end if;
	end if;

end process shot_process;


store_state: process (clk)
   begin
      if rising_edge(clk) then  
         neuron_model_eventport_out_spike_int2 <= neuron_model_eventport_out_spike_int;         neuron_model_eventport_out_spike_int3 <= neuron_model_eventport_out_spike_int2;         seven_steps_done_shot2 <= seven_steps_done_shot;         if (init_model='1') then   
		
			neuron_model_statevariable_voltage_v_in_int <= neuron_model_stateRESTORE_voltage_v;
			neuron_model_statevariable_none_spiking_in_int <= neuron_model_stateRESTORE_none_spiking;
			neuron_model_derivedvariable_current_leak_i_in_int <= neuron_model_stateRESTORE_current_leak_i;
			neuron_model_derivedvariable_conductance_leak_passive_g_in_int <= neuron_model_stateRESTORE_conductance_leak_passive_g;
			neuron_model_derivedvariable_current_naChans_i_in_int <= neuron_model_stateRESTORE_current_naChans_i;
			neuron_model_derivedvariable_conductance_naChans_na_g_in_int <= neuron_model_stateRESTORE_conductance_naChans_na_g;
			neuron_model_statevariable_none_naChans_na_m_q_in_int <= neuron_model_stateRESTORE_none_naChans_na_m_q;
			neuron_model_derivedvariable_none_naChans_na_m_fcond_in_int <= neuron_model_stateRESTORE_none_naChans_na_m_fcond;
			neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in_int <= neuron_model_stateRESTORE_per_time_naChans_na_m_reverseRatem1_r;
			neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in_int <= neuron_model_stateRESTORE_per_time_naChans_na_m_forwardRatem1_r;
			neuron_model_statevariable_none_naChans_na_h_q_in_int <= neuron_model_stateRESTORE_none_naChans_na_h_q;
			neuron_model_derivedvariable_none_naChans_na_h_fcond_in_int <= neuron_model_stateRESTORE_none_naChans_na_h_fcond;
			neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in_int <= neuron_model_stateRESTORE_per_time_naChans_na_h_reverseRateh1_r;
			neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in_int <= neuron_model_stateRESTORE_per_time_naChans_na_h_forwardRateh1_r;
			neuron_model_derivedvariable_current_kChans_i_in_int <= neuron_model_stateRESTORE_current_kChans_i;
			neuron_model_derivedvariable_conductance_kChans_k_g_in_int <= neuron_model_stateRESTORE_conductance_kChans_k_g;
			neuron_model_statevariable_none_kChans_k_n_q_in_int <= neuron_model_stateRESTORE_none_kChans_k_n_q;
			neuron_model_derivedvariable_none_kChans_k_n_fcond_in_int <= neuron_model_stateRESTORE_none_kChans_k_n_fcond;
			neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in_int <= neuron_model_stateRESTORE_per_time_kChans_k_n_reverseRaten1_r;
			neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in_int <= neuron_model_stateRESTORE_per_time_kChans_k_n_forwardRaten1_r;
			neuron_model_statevariable_conductance_synapsemodel_g_in_int <= neuron_model_stateRESTORE_conductance_synapsemodel_g;
			neuron_model_derivedvariable_current_synapsemodel_i_in_int <= neuron_model_stateRESTORE_current_synapsemodel_i;
			neuron_model_eventport_out_spike_out <= '0';

		 
         elsif (seven_steps_done_shot='1') then
			neuron_model_eventport_out_spike_out <= neuron_model_eventport_out_spike_int3 ;
			neuron_model_statevariable_voltage_v_in_int <= neuron_model_statevariable_voltage_v_out_int;
			neuron_model_statevariable_none_spiking_in_int <= neuron_model_statevariable_none_spiking_out_int;
			neuron_model_derivedvariable_current_leak_i_in_int <= neuron_model_derivedvariable_current_leak_i_out_int;
			neuron_model_derivedvariable_conductance_leak_passive_g_in_int <= neuron_model_derivedvariable_conductance_leak_passive_g_out_int;
			neuron_model_derivedvariable_current_naChans_i_in_int <= neuron_model_derivedvariable_current_naChans_i_out_int;
			neuron_model_derivedvariable_conductance_naChans_na_g_in_int <= neuron_model_derivedvariable_conductance_naChans_na_g_out_int;
			neuron_model_statevariable_none_naChans_na_m_q_in_int <= neuron_model_statevariable_none_naChans_na_m_q_out_int;
			neuron_model_derivedvariable_none_naChans_na_m_fcond_in_int <= neuron_model_derivedvariable_none_naChans_na_m_fcond_out_int;
			neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in_int <= neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out_int;
			neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in_int <= neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out_int;
			neuron_model_statevariable_none_naChans_na_h_q_in_int <= neuron_model_statevariable_none_naChans_na_h_q_out_int;
			neuron_model_derivedvariable_none_naChans_na_h_fcond_in_int <= neuron_model_derivedvariable_none_naChans_na_h_fcond_out_int;
			neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in_int <= neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out_int;
			neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in_int <= neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out_int;
			neuron_model_derivedvariable_current_kChans_i_in_int <= neuron_model_derivedvariable_current_kChans_i_out_int;
			neuron_model_derivedvariable_conductance_kChans_k_g_in_int <= neuron_model_derivedvariable_conductance_kChans_k_g_out_int;
			neuron_model_statevariable_none_kChans_k_n_q_in_int <= neuron_model_statevariable_none_kChans_k_n_q_out_int;
			neuron_model_derivedvariable_none_kChans_k_n_fcond_in_int <= neuron_model_derivedvariable_none_kChans_k_n_fcond_out_int;
			neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in_int <= neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out_int;
			neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in_int <= neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out_int;
			neuron_model_statevariable_conductance_synapsemodel_g_in_int <= neuron_model_statevariable_conductance_synapsemodel_g_out_int;
			neuron_model_derivedvariable_current_synapsemodel_i_in_int <= neuron_model_derivedvariable_current_synapsemodel_i_out_int;

else
			neuron_model_eventport_out_spike_out <= '0';
		
end if;
end if;
    

 end process store_state;
 			neuron_model_stateCURRENT_voltage_v <= neuron_model_statevariable_voltage_v_in_int;
			neuron_model_stateCURRENT_none_spiking <= neuron_model_statevariable_none_spiking_in_int;
			neuron_model_stateCURRENT_current_leak_i <= neuron_model_derivedvariable_current_leak_i_in_int;
			neuron_model_stateCURRENT_conductance_leak_passive_g <= neuron_model_derivedvariable_conductance_leak_passive_g_in_int;
			neuron_model_stateCURRENT_current_naChans_i <= neuron_model_derivedvariable_current_naChans_i_in_int;
			neuron_model_stateCURRENT_conductance_naChans_na_g <= neuron_model_derivedvariable_conductance_naChans_na_g_in_int;
			neuron_model_stateCURRENT_none_naChans_na_m_q <= neuron_model_statevariable_none_naChans_na_m_q_in_int;
			neuron_model_stateCURRENT_none_naChans_na_m_fcond <= neuron_model_derivedvariable_none_naChans_na_m_fcond_in_int;
			neuron_model_stateCURRENT_per_time_naChans_na_m_reverseRatem1_r <= neuron_model_derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in_int;
			neuron_model_stateCURRENT_per_time_naChans_na_m_forwardRatem1_r <= neuron_model_derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in_int;
			neuron_model_stateCURRENT_none_naChans_na_h_q <= neuron_model_statevariable_none_naChans_na_h_q_in_int;
			neuron_model_stateCURRENT_none_naChans_na_h_fcond <= neuron_model_derivedvariable_none_naChans_na_h_fcond_in_int;
			neuron_model_stateCURRENT_per_time_naChans_na_h_reverseRateh1_r <= neuron_model_derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in_int;
			neuron_model_stateCURRENT_per_time_naChans_na_h_forwardRateh1_r <= neuron_model_derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in_int;
			neuron_model_stateCURRENT_current_kChans_i <= neuron_model_derivedvariable_current_kChans_i_in_int;
			neuron_model_stateCURRENT_conductance_kChans_k_g <= neuron_model_derivedvariable_conductance_kChans_k_g_in_int;
			neuron_model_stateCURRENT_none_kChans_k_n_q <= neuron_model_statevariable_none_kChans_k_n_q_in_int;
			neuron_model_stateCURRENT_none_kChans_k_n_fcond <= neuron_model_derivedvariable_none_kChans_k_n_fcond_in_int;
			neuron_model_stateCURRENT_per_time_kChans_k_n_reverseRaten1_r <= neuron_model_derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in_int;
			neuron_model_stateCURRENT_per_time_kChans_k_n_forwardRaten1_r <= neuron_model_derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in_int;
			neuron_model_stateCURRENT_conductance_synapsemodel_g <= neuron_model_statevariable_conductance_synapsemodel_g_in_int;
			neuron_model_stateCURRENT_current_synapsemodel_i <= neuron_model_derivedvariable_current_synapsemodel_i_in_int;


 neuron_model_eventport_out_spike <= neuron_model_eventport_out_spike_out;
 step_once_complete <= seven_steps_done_shot2;

end top;