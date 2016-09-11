
---------------------------------------------------------------------
-- Standard Library bits 
---------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- For Modelsim
--use ieee.fixed_pkg.all;
--use ieee.fixed_float_types.ALL;

-- For ISE
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.ALL;
use IEEE.numeric_std.all;

---------------------------------------------------------------------
---------------------------------------------------------------------
-- Entity Description
---------------------------------------------------------------------
entity neuron_model is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
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
  param_per_time_naChans_na_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_naChans_na_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_none_naChans_na_h_instances : in sfixed (18 downto -13);
  exposure_none_naChans_na_h_fcond : out sfixed (18 downto -13);
  exposure_none_naChans_na_h_q : out sfixed (18 downto -13);
  statevariable_none_naChans_na_h_q_out : out sfixed (18 downto -13);
  statevariable_none_naChans_na_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_naChans_na_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_naChans_na_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_naChans_na_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_naChans_na_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_naChans_na_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_naChans_na_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_naChans_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in : in sfixed (18 downto -2);
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
  param_per_time_kChans_k_n_forwardRaten1_rate : in sfixed (18 downto -2);
  param_voltage_kChans_k_n_forwardRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_kChans_k_n_forwardRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_kChans_k_n_forwardRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in : in sfixed (18 downto -2);
  param_per_time_kChans_k_n_reverseRaten1_rate : in sfixed (18 downto -2);
  param_voltage_kChans_k_n_reverseRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_kChans_k_n_reverseRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_kChans_k_n_reverseRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in : in sfixed (18 downto -2);
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
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end neuron_model;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of neuron_model is
signal COUNT : unsigned(2 downto 0) := "000";
signal childrenCombined_Component_done_single_shot_fired : STD_LOGIC := '0';
signal childrenCombined_Component_done_single_shot : STD_LOGIC := '0';
signal childrenCombined_Component_done : STD_LOGIC := '0';
signal Component_done_int : STD_LOGIC := '0';


signal subprocess_der_int_pre_ready : STD_LOGIC := '0';
signal subprocess_der_int_ready : STD_LOGIC := '0';
signal subprocess_der_ready : STD_LOGIC := '0';
signal subprocess_dyn_int_pre_ready : STD_LOGIC := '0';
signal subprocess_dyn_int_ready : STD_LOGIC := '0';
signal subprocess_dyn_ready : STD_LOGIC := '0';
signal subprocess_model_ready : STD_LOGIC := '1';
signal subprocess_all_ready_shotdone : STD_LOGIC := '1';
signal subprocess_all_ready_shot : STD_LOGIC := '0';
signal subprocess_all_ready : STD_LOGIC := '0';signal synapsemodel_step_once_complete_fired : STD_LOGIC := '1';


signal step_once_complete_fired : STD_LOGIC := '1';
signal Component_done : STD_LOGIC := '0';


constant cNSpikeSources : integer := 512;	-- The number of spike sources.
constant cNOutputs		: integer := 512;	-- The number of Synapses in the neuron model.
constant cNSelectBits	: integer := 9;		-- Log2(NOutputs), rounded up.

signal SpikeOut			: Std_logic_vector((cNOutputs-1) downto 0);

signal statevariable_voltage_noregime_v_temp_1 : sfixed (2 downto -22);
signal statevariable_voltage_noregime_v_temp_1_next : sfixed (2 downto -22);

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_current_iChannels : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iChannels_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iSyn : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iSyn_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iMemb : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iMemb_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_voltage_v_next : sfixed (2 downto -22);
signal statevariable_none_spiking_next : sfixed (18 downto -13);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------
signal EventPort_out_spike_internal : std_logic := '0'; 
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
component leak 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_number : in sfixed (18 downto -13);
  param_voltage_erev : in sfixed (2 downto -22);
  exposure_current_i : out sfixed (-28 downto -53);
  derivedvariable_current_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_i_in : in sfixed (-28 downto -53);
  param_conductance_passive_conductance : in sfixed (-22 downto -53);
  exposure_conductance_passive_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_passive_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_passive_g_in : in sfixed (-22 downto -53);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal leak_Component_done : STD_LOGIC ; signal Exposure_current_leak_i_internal : sfixed (-28 downto -53);
signal Exposure_conductance_leak_passive_g_internal : sfixed (-22 downto -53);
---------------------------------------------------------------------
component naChans 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_number : in sfixed (18 downto -13);
  param_voltage_erev : in sfixed (2 downto -22);
  exposure_current_i : out sfixed (-28 downto -53);
  derivedvariable_current_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_i_in : in sfixed (-28 downto -53);
  param_conductance_na_conductance : in sfixed (-22 downto -53);
  exposure_conductance_na_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_na_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_na_g_in : in sfixed (-22 downto -53);
  param_none_na_m_instances : in sfixed (18 downto -13);
  exposure_none_na_m_fcond : out sfixed (18 downto -13);
  exposure_none_na_m_q : out sfixed (18 downto -13);
  statevariable_none_na_m_q_out : out sfixed (18 downto -13);
  statevariable_none_na_m_q_in : in sfixed (18 downto -13);
  derivedvariable_none_na_m_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_na_m_fcond_in : in sfixed (18 downto -13);
  param_per_time_na_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_na_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_na_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_na_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_none_na_h_instances : in sfixed (18 downto -13);
  exposure_none_na_h_fcond : out sfixed (18 downto -13);
  exposure_none_na_h_q : out sfixed (18 downto -13);
  statevariable_none_na_h_q_out : out sfixed (18 downto -13);
  statevariable_none_na_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_na_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_na_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_na_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_na_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_na_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_na_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_reverseRateh1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal naChans_Component_done : STD_LOGIC ; signal Exposure_current_naChans_i_internal : sfixed (-28 downto -53);
signal Exposure_conductance_naChans_na_g_internal : sfixed (-22 downto -53);
signal Exposure_none_naChans_na_m_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_naChans_na_m_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_naChans_na_m_forwardRatem1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_naChans_na_m_reverseRatem1_r_internal : sfixed (18 downto -2);
signal Exposure_none_naChans_na_h_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_naChans_na_h_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_naChans_na_h_forwardRateh1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_naChans_na_h_reverseRateh1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
component kChans 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_number : in sfixed (18 downto -13);
  param_voltage_erev : in sfixed (2 downto -22);
  exposure_current_i : out sfixed (-28 downto -53);
  derivedvariable_current_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_i_in : in sfixed (-28 downto -53);
  param_conductance_k_conductance : in sfixed (-22 downto -53);
  exposure_conductance_k_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_k_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_k_g_in : in sfixed (-22 downto -53);
  param_none_k_n_instances : in sfixed (18 downto -13);
  exposure_none_k_n_fcond : out sfixed (18 downto -13);
  exposure_none_k_n_q : out sfixed (18 downto -13);
  statevariable_none_k_n_q_out : out sfixed (18 downto -13);
  statevariable_none_k_n_q_in : in sfixed (18 downto -13);
  derivedvariable_none_k_n_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_k_n_fcond_in : in sfixed (18 downto -13);
  param_per_time_k_n_forwardRaten1_rate : in sfixed (18 downto -2);
  param_voltage_k_n_forwardRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_k_n_forwardRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_k_n_forwardRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_k_n_forwardRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_k_n_forwardRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_k_n_forwardRaten1_r_in : in sfixed (18 downto -2);
  param_per_time_k_n_reverseRaten1_rate : in sfixed (18 downto -2);
  param_voltage_k_n_reverseRaten1_midpoint : in sfixed (2 downto -22);
  param_voltage_k_n_reverseRaten1_scale : in sfixed (2 downto -22);
  param_voltage_inv_k_n_reverseRaten1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_k_n_reverseRaten1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_k_n_reverseRaten1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_k_n_reverseRaten1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal kChans_Component_done : STD_LOGIC ; signal Exposure_current_kChans_i_internal : sfixed (-28 downto -53);
signal Exposure_conductance_kChans_k_g_internal : sfixed (-22 downto -53);
signal Exposure_none_kChans_k_n_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_kChans_k_n_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_kChans_k_n_forwardRaten1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_kChans_k_n_reverseRaten1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
component synapsemodel 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  eventport_in_in : in STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_time_tauDecay : in sfixed (6 downto -18);
  param_conductance_gbase : in sfixed (-22 downto -53);
  param_voltage_erev : in sfixed (2 downto -22);
  param_time_inv_tauDecay_inv : in sfixed (18 downto -6);
  exposure_current_i : out sfixed (-28 downto -53);
  exposure_conductance_g : out sfixed (-22 downto -53);
  statevariable_conductance_g_out : out sfixed (-22 downto -53);
  statevariable_conductance_g_in : in sfixed (-22 downto -53);
  derivedvariable_current_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_i_in : in sfixed (-28 downto -53);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal synapsemodel_Component_done : STD_LOGIC ; signal Exposure_current_synapsemodel_i_internal : sfixed (-28 downto -53);
signal Exposure_conductance_synapsemodel_g_internal : sfixed (-22 downto -53);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
leak_uut : leak 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => leak_Component_done,
  param_none_number => param_none_leak_number,
  param_voltage_erev => param_voltage_leak_erev,
  requirement_voltage_v => statevariable_voltage_v_in,
  Exposure_current_i => Exposure_current_leak_i_internal,
  derivedvariable_current_i_out => derivedvariable_current_leak_i_out,
  derivedvariable_current_i_in => derivedvariable_current_leak_i_in,
  param_conductance_passive_conductance => param_conductance_leak_passive_conductance,
  Exposure_conductance_passive_g => Exposure_conductance_leak_passive_g_internal,
  derivedvariable_conductance_passive_g_out => derivedvariable_conductance_leak_passive_g_out,
  derivedvariable_conductance_passive_g_in => derivedvariable_conductance_leak_passive_g_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_current_leak_i <= Exposure_current_leak_i_internal;
naChans_uut : naChans 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => naChans_Component_done,
  param_none_number => param_none_naChans_number,
  param_voltage_erev => param_voltage_naChans_erev,
  requirement_voltage_v => statevariable_voltage_v_in,
  Exposure_current_i => Exposure_current_naChans_i_internal,
  derivedvariable_current_i_out => derivedvariable_current_naChans_i_out,
  derivedvariable_current_i_in => derivedvariable_current_naChans_i_in,
  param_conductance_na_conductance => param_conductance_naChans_na_conductance,
  Exposure_conductance_na_g => Exposure_conductance_naChans_na_g_internal,
  derivedvariable_conductance_na_g_out => derivedvariable_conductance_naChans_na_g_out,
  derivedvariable_conductance_na_g_in => derivedvariable_conductance_naChans_na_g_in,
  param_none_na_m_instances => param_none_naChans_na_m_instances,
  Exposure_none_na_m_fcond => Exposure_none_naChans_na_m_fcond_internal,
  Exposure_none_na_m_q => Exposure_none_naChans_na_m_q_internal,
  statevariable_none_na_m_q_out => statevariable_none_naChans_na_m_q_out,
  statevariable_none_na_m_q_in => statevariable_none_naChans_na_m_q_in,
  derivedvariable_none_na_m_fcond_out => derivedvariable_none_naChans_na_m_fcond_out,
  derivedvariable_none_na_m_fcond_in => derivedvariable_none_naChans_na_m_fcond_in,
  param_per_time_na_m_forwardRatem1_rate => param_per_time_naChans_na_m_forwardRatem1_rate,
  param_voltage_na_m_forwardRatem1_midpoint => param_voltage_naChans_na_m_forwardRatem1_midpoint,
  param_voltage_na_m_forwardRatem1_scale => param_voltage_naChans_na_m_forwardRatem1_scale,
  param_voltage_inv_na_m_forwardRatem1_scale_inv => param_voltage_inv_naChans_na_m_forwardRatem1_scale_inv,
  Exposure_per_time_na_m_forwardRatem1_r => Exposure_per_time_naChans_na_m_forwardRatem1_r_internal,
  derivedvariable_per_time_na_m_forwardRatem1_r_out => derivedvariable_per_time_naChans_na_m_forwardRatem1_r_out,
  derivedvariable_per_time_na_m_forwardRatem1_r_in => derivedvariable_per_time_naChans_na_m_forwardRatem1_r_in,
  param_per_time_na_m_reverseRatem1_rate => param_per_time_naChans_na_m_reverseRatem1_rate,
  param_voltage_na_m_reverseRatem1_midpoint => param_voltage_naChans_na_m_reverseRatem1_midpoint,
  param_voltage_na_m_reverseRatem1_scale => param_voltage_naChans_na_m_reverseRatem1_scale,
  param_voltage_inv_na_m_reverseRatem1_scale_inv => param_voltage_inv_naChans_na_m_reverseRatem1_scale_inv,
  Exposure_per_time_na_m_reverseRatem1_r => Exposure_per_time_naChans_na_m_reverseRatem1_r_internal,
  derivedvariable_per_time_na_m_reverseRatem1_r_out => derivedvariable_per_time_naChans_na_m_reverseRatem1_r_out,
  derivedvariable_per_time_na_m_reverseRatem1_r_in => derivedvariable_per_time_naChans_na_m_reverseRatem1_r_in,
  param_none_na_h_instances => param_none_naChans_na_h_instances,
  Exposure_none_na_h_fcond => Exposure_none_naChans_na_h_fcond_internal,
  Exposure_none_na_h_q => Exposure_none_naChans_na_h_q_internal,
  statevariable_none_na_h_q_out => statevariable_none_naChans_na_h_q_out,
  statevariable_none_na_h_q_in => statevariable_none_naChans_na_h_q_in,
  derivedvariable_none_na_h_fcond_out => derivedvariable_none_naChans_na_h_fcond_out,
  derivedvariable_none_na_h_fcond_in => derivedvariable_none_naChans_na_h_fcond_in,
  param_per_time_na_h_forwardRateh1_rate => param_per_time_naChans_na_h_forwardRateh1_rate,
  param_voltage_na_h_forwardRateh1_midpoint => param_voltage_naChans_na_h_forwardRateh1_midpoint,
  param_voltage_na_h_forwardRateh1_scale => param_voltage_naChans_na_h_forwardRateh1_scale,
  param_voltage_inv_na_h_forwardRateh1_scale_inv => param_voltage_inv_naChans_na_h_forwardRateh1_scale_inv,
  Exposure_per_time_na_h_forwardRateh1_r => Exposure_per_time_naChans_na_h_forwardRateh1_r_internal,
  derivedvariable_per_time_na_h_forwardRateh1_r_out => derivedvariable_per_time_naChans_na_h_forwardRateh1_r_out,
  derivedvariable_per_time_na_h_forwardRateh1_r_in => derivedvariable_per_time_naChans_na_h_forwardRateh1_r_in,
  param_per_time_na_h_reverseRateh1_rate => param_per_time_naChans_na_h_reverseRateh1_rate,
  param_voltage_na_h_reverseRateh1_midpoint => param_voltage_naChans_na_h_reverseRateh1_midpoint,
  param_voltage_na_h_reverseRateh1_scale => param_voltage_naChans_na_h_reverseRateh1_scale,
  param_voltage_inv_na_h_reverseRateh1_scale_inv => param_voltage_inv_naChans_na_h_reverseRateh1_scale_inv,
  Exposure_per_time_na_h_reverseRateh1_r => Exposure_per_time_naChans_na_h_reverseRateh1_r_internal,
  derivedvariable_per_time_na_h_reverseRateh1_r_out => derivedvariable_per_time_naChans_na_h_reverseRateh1_r_out,
  derivedvariable_per_time_na_h_reverseRateh1_r_in => derivedvariable_per_time_naChans_na_h_reverseRateh1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_current_naChans_i <= Exposure_current_naChans_i_internal;
kChans_uut : kChans 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => kChans_Component_done,
  param_none_number => param_none_kChans_number,
  param_voltage_erev => param_voltage_kChans_erev,
  requirement_voltage_v => statevariable_voltage_v_in,
  Exposure_current_i => Exposure_current_kChans_i_internal,
  derivedvariable_current_i_out => derivedvariable_current_kChans_i_out,
  derivedvariable_current_i_in => derivedvariable_current_kChans_i_in,
  param_conductance_k_conductance => param_conductance_kChans_k_conductance,
  Exposure_conductance_k_g => Exposure_conductance_kChans_k_g_internal,
  derivedvariable_conductance_k_g_out => derivedvariable_conductance_kChans_k_g_out,
  derivedvariable_conductance_k_g_in => derivedvariable_conductance_kChans_k_g_in,
  param_none_k_n_instances => param_none_kChans_k_n_instances,
  Exposure_none_k_n_fcond => Exposure_none_kChans_k_n_fcond_internal,
  Exposure_none_k_n_q => Exposure_none_kChans_k_n_q_internal,
  statevariable_none_k_n_q_out => statevariable_none_kChans_k_n_q_out,
  statevariable_none_k_n_q_in => statevariable_none_kChans_k_n_q_in,
  derivedvariable_none_k_n_fcond_out => derivedvariable_none_kChans_k_n_fcond_out,
  derivedvariable_none_k_n_fcond_in => derivedvariable_none_kChans_k_n_fcond_in,
  param_per_time_k_n_forwardRaten1_rate => param_per_time_kChans_k_n_forwardRaten1_rate,
  param_voltage_k_n_forwardRaten1_midpoint => param_voltage_kChans_k_n_forwardRaten1_midpoint,
  param_voltage_k_n_forwardRaten1_scale => param_voltage_kChans_k_n_forwardRaten1_scale,
  param_voltage_inv_k_n_forwardRaten1_scale_inv => param_voltage_inv_kChans_k_n_forwardRaten1_scale_inv,
  Exposure_per_time_k_n_forwardRaten1_r => Exposure_per_time_kChans_k_n_forwardRaten1_r_internal,
  derivedvariable_per_time_k_n_forwardRaten1_r_out => derivedvariable_per_time_kChans_k_n_forwardRaten1_r_out,
  derivedvariable_per_time_k_n_forwardRaten1_r_in => derivedvariable_per_time_kChans_k_n_forwardRaten1_r_in,
  param_per_time_k_n_reverseRaten1_rate => param_per_time_kChans_k_n_reverseRaten1_rate,
  param_voltage_k_n_reverseRaten1_midpoint => param_voltage_kChans_k_n_reverseRaten1_midpoint,
  param_voltage_k_n_reverseRaten1_scale => param_voltage_kChans_k_n_reverseRaten1_scale,
  param_voltage_inv_k_n_reverseRaten1_scale_inv => param_voltage_inv_kChans_k_n_reverseRaten1_scale_inv,
  Exposure_per_time_k_n_reverseRaten1_r => Exposure_per_time_kChans_k_n_reverseRaten1_r_internal,
  derivedvariable_per_time_k_n_reverseRaten1_r_out => derivedvariable_per_time_kChans_k_n_reverseRaten1_r_out,
  derivedvariable_per_time_k_n_reverseRaten1_r_in => derivedvariable_per_time_kChans_k_n_reverseRaten1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_current_kChans_i <= Exposure_current_kChans_i_internal;
synapsemodel_uut : synapsemodel 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => synapsemodel_Component_done,
  eventport_in_in => EventPort_in_spike_aggregate(0),
  param_time_tauDecay => param_time_synapsemodel_tauDecay,
  param_conductance_gbase => param_conductance_synapsemodel_gbase,
  param_voltage_erev => param_voltage_synapsemodel_erev,
  param_time_inv_tauDecay_inv => param_time_inv_synapsemodel_tauDecay_inv,
  requirement_voltage_v => statevariable_voltage_v_in,
  Exposure_current_i => Exposure_current_synapsemodel_i_internal,
  Exposure_conductance_g => Exposure_conductance_synapsemodel_g_internal,
  statevariable_conductance_g_out => statevariable_conductance_synapsemodel_g_out,
  statevariable_conductance_g_in => statevariable_conductance_synapsemodel_g_in,
  derivedvariable_current_i_out => derivedvariable_current_synapsemodel_i_out,
  derivedvariable_current_i_in => derivedvariable_current_synapsemodel_i_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_current_synapsemodel_i <= Exposure_current_synapsemodel_i_internal;
Exposure_conductance_synapsemodel_g <= Exposure_conductance_synapsemodel_g_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_current_leak_i_internal,exposure_current_naChans_i_internal,exposure_current_kChans_i_internal,exposure_current_synapsemodel_i_internal, derivedvariable_current_iChannels_next , derivedvariable_current_iSyn_next  )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_current_leak_i_internal,exposure_current_naChans_i_internal,exposure_current_kChans_i_internal,exposure_current_synapsemodel_i_internal, derivedvariable_current_iChannels_next , derivedvariable_current_iSyn_next  )
begin
  derivedvariable_current_iChannels_next <= resize((  (  ( exposure_current_leak_i_internal  +  exposure_current_naChans_i_internal )  +  exposure_current_kChans_i_internal )  ),-28,-53);
  derivedvariable_current_iSyn_next <= resize(( exposure_current_synapsemodel_i_internal ),-28,-53);
  derivedvariable_current_iMemb_next <= resize(( derivedvariable_current_iChannels_next + derivedvariable_current_iSyn_next ),-28,-53);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_current_iChannels <= derivedvariable_current_iChannels_next;
      derivedvariable_current_iSyn <= derivedvariable_current_iSyn_next;
      derivedvariable_current_iMemb <= derivedvariable_current_iMemb_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------

dynamics_pre_process_comb :process ( sysparam_time_timestep, derivedvariable_current_iMemb , param_capacitance_C,param_capacitance_inv_C_inv  )
begin 

end process dynamics_pre_process_comb;

dynamics_pre_process_syn :process ( clk, init_model )
begin 

  subprocess_dyn_int_pre_ready <= '1';
end process dynamics_pre_process_syn;



--No dynamics with complex equations found
subprocess_dyn_int_ready <= '1';

state_variable_process_dynamics_comb :process (sysparam_time_timestep, derivedvariable_current_iMemb , param_capacitance_C,param_capacitance_inv_C_inv ,statevariable_voltage_v_in)
begin
  statevariable_voltage_noregime_v_temp_1_next <= resize(statevariable_voltage_v_in + ( derivedvariable_current_iMemb * param_capacitance_inv_C_inv ) * sysparam_time_timestep,2,-22);

  subprocess_dyn_ready <= '1';
end process state_variable_process_dynamics_comb;
state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      statevariable_voltage_noregime_v_temp_1 <= statevariable_voltage_noregime_v_temp_1_next;

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,param_voltage_v0,statevariable_voltage_noregime_v_temp_1,derivedvariable_current_iMemb,param_capacitance_C,param_capacitance_inv_C_inv)
variable statevariable_voltage_v_temp_1 : sfixed (2 downto -22);
begin
  statevariable_voltage_v_temp_1 := statevariable_voltage_noregime_v_temp_1;    statevariable_voltage_v_next <= statevariable_voltage_v_temp_1;
end process;

---------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_1 :process (sysparam_time_timestep,init_model,param_voltage_v0,param_voltage_thresh,statevariable_voltage_v_in,statevariable_none_spiking_in,param_voltage_thresh,statevariable_voltage_v_in)
variable statevariable_none_spiking_temp_1 : sfixed (18 downto -13);
variable statevariable_none_spiking_temp_2 : sfixed (18 downto -13);
begin
  if  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' AND  To_slv ( resize ( statevariable_none_spiking_in -  ( to_sfixed ( 0.5 ,0 , -1 ) )    ,2,-18))(20)  = '1' then
    statevariable_none_spiking_temp_1 := resize( to_sfixed ( 1 ,1 , -1 ) ,18,-13);
  else
    statevariable_none_spiking_temp_1 := statevariable_none_spiking_in;
  end if;
  if  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '1' then
    statevariable_none_spiking_temp_2 := resize( to_sfixed ( 0 ,0 , -1 ) ,18,-13);
  else
    statevariable_none_spiking_temp_2 := statevariable_none_spiking_temp_1;
  end if;
    statevariable_none_spiking_next <= statevariable_none_spiking_temp_2;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

eventport_driver0 :process ( clk,sysparam_time_timestep,init_model, param_voltage_thresh, statevariable_voltage_v_in , statevariable_none_spiking_in  )
variable eventport_out_spike_temp_1 : std_logic;
variable eventport_out_spike_temp_2 : std_logic;


begin
if rising_edge(clk) and subprocess_all_ready_shot = '1' then
  if   To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' AND  To_slv ( resize ( statevariable_none_spiking_in -  ( to_sfixed ( 0.5 ,0 , -1 ) )    ,2,-18))(20)  = '1' then
    eventport_out_spike_temp_1 := '1';
  else
    eventport_out_spike_temp_1 := '0';
  end if;eventport_out_spike_internal <= eventport_out_spike_temp_1;

end if;

end process;
---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to exposures
---------------------------------------------------------------------
exposure_voltage_v <= statevariable_voltage_v_in;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------
statevariable_voltage_v_out <= statevariable_voltage_v_next;statevariable_none_spiking_out <= statevariable_none_spiking_next;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign derived variables to exposures
---------------------------------------------------------------------

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Subprocess ready process
---------------------------------------------------------------------

subprocess_all_ready_process: process(step_once_go,subprocess_der_int_ready,subprocess_der_int_pre_ready,subprocess_der_ready,subprocess_dyn_int_pre_ready,subprocess_dyn_int_ready,subprocess_dyn_ready,subprocess_model_ready)
begin
  if step_once_go = '0' and subprocess_der_int_ready = '1'  and subprocess_der_int_pre_ready = '1'and subprocess_der_ready ='1' and subprocess_dyn_int_ready = '1' and subprocess_dyn_int_pre_ready = '1' and subprocess_dyn_ready = '1' and subprocess_model_ready = '1' then
    subprocess_all_ready <= '1';
  else
    subprocess_all_ready <= '0';
  end if;
end process subprocess_all_ready_process;
subprocess_all_ready_shot_process : process(clk)
begin
	if rising_edge(clk) then
			if (init_model='1') then 
				subprocess_all_ready_shot <= '0';
			    subprocess_all_ready_shotdone <= '1';
			else
				if subprocess_all_ready = '1' and subprocess_all_ready_shotdone = '0' then
					subprocess_all_ready_shot <= '1';
					subprocess_all_ready_shotdone <= '1';
				elsif subprocess_all_ready_shot = '1' then
					subprocess_all_ready_shot <= '0';
				elsif subprocess_all_ready = '0' then
					subprocess_all_ready_shot <= '0';
					subprocess_all_ready_shotdone <= '0';
				end if;
			end if;
	end if;

end process subprocess_all_ready_shot_process;
---------------------------------------------------------------------



count_proc:process(clk)
begin 
  if (clk'EVENT AND clk = '1') then
    if init_model = '1' then       COUNT <= "001";
      component_done_int <= '1';
    else       if step_once_go = '1' then
        COUNT <= "000";
        component_done_int <= '0';
      elsif COUNT = "001" then
        component_done_int <= '1';
      elsif subprocess_all_ready_shot = '1' then
        COUNT <= COUNT + 1;
        component_done_int <= '0';
      end if;
    end if;
  end if;
end process count_proc;
childrenCombined_component_done_process:process(leak_component_done,naChans_component_done,kChans_component_done,synapsemodel_component_done,CLK)
begin
  if (leak_component_done = '1' and naChans_component_done = '1' and kChans_component_done = '1' and synapsemodel_component_done = '1') then
    childrenCombined_component_done <= '1';
  else
    childrenCombined_component_done <= '0';
  end if;
end process childrenCombined_component_done_process;

component_done <= component_done_int and childrenCombined_component_done;
---------------------------------------------------------------------
-- Control the done signal
---------------------------------------------------------------------

step_once_complete_synch:process(clk)
begin 
  if (clk'EVENT AND clk = '1') then
    if init_model = '1' then       step_once_complete <= '0';
      step_once_complete_fired <= '1';
    else        if component_done = '1' and step_once_complete_fired = '0'  then
        step_once_complete <= '1';
        step_once_complete_fired <= '1';
---------------------------------------------------------------------
-- Assign event ports to exposures
---------------------------------------------------------------------
        eventport_out_spike <=  eventport_out_spike_internal ;

---------------------------------------------------------------------
      elsif component_done = '0' then
        step_once_complete <= '0';
        step_once_complete_fired <= '0';
---------------------------------------------------------------------
-- Assign event ports to exposures
---------------------------------------------------------------------
        eventport_out_spike <=  '0';

---------------------------------------------------------------------
      else
        step_once_complete <= '0';
---------------------------------------------------------------------
-- Assign event ports to exposures
---------------------------------------------------------------------
        eventport_out_spike <=  '0';

---------------------------------------------------------------------
      end if;
    end if;
  end if;
end process step_once_complete_synch;
---------------------------------------------------------------------

end RTL;
