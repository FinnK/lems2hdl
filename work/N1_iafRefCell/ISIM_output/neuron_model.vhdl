
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
  SelectSpikesIn			: Std_logic_vector(4607 downto 0) := (others => '0');
  current_regime_in_stdlv : in STD_LOGIC_VECTOR(1 downto 0);
  current_regime_out_stdlv : out STD_LOGIC_VECTOR(1 downto 0);
  eventport_out_spike : out STD_LOGIC;
  param_time_refract : in sfixed (6 downto -18);
  param_conductance_leakConductance : in sfixed (-22 downto -53);
  param_voltage_leakReversal : in sfixed (2 downto -22);
  param_voltage_thresh : in sfixed (2 downto -22);
  param_voltage_reset : in sfixed (2 downto -22);
  param_capacitance_C : in sfixed (-33 downto -47);
  param_capacitance_inv_C_inv : in sfixed (47 downto 33);
  exposure_voltage_v : out sfixed (2 downto -22);
  statevariable_voltage_v_out : out sfixed (2 downto -22);
  statevariable_voltage_v_in : in sfixed (2 downto -22);
  statevariable_time_lastSpikeTime_out : out sfixed (6 downto -18);
  statevariable_time_lastSpikeTime_in : in sfixed (6 downto -18);
  param_time_SynapseModel_tauDecay : in sfixed (6 downto -18);
  param_conductance_SynapseModel_gbase : in sfixed (-22 downto -53);
  param_voltage_SynapseModel_erev : in sfixed (2 downto -22);
  param_time_inv_SynapseModel_tauDecay_inv : in sfixed (18 downto -6);
  exposure_current_SynapseModel_i : out sfixed (-28 downto -53);
  exposure_conductance_SynapseModel_g : out sfixed (-22 downto -53);
  statevariable_conductance_SynapseModel_g_out : out sfixed (-22 downto -53);
  statevariable_conductance_SynapseModel_g_in : in sfixed (-22 downto -53);
  derivedvariable_current_SynapseModel_i_out : out sfixed (-28 downto -53);
  derivedvariable_current_SynapseModel_i_in : in sfixed (-28 downto -53);
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
signal subprocess_all_ready : STD_LOGIC := '0';

signal step_once_complete_fired : STD_LOGIC := '1';
signal Component_done : STD_LOGIC := '0';


constant cNSpikeSources : integer := 512;	-- The number of spike sources.
constant cNOutputs		: integer := 512;	-- The number of Synapses in the neuron model.
constant cNSelectBits	: integer := 9;		-- Log2(NOutputs), rounded up.

signal SpikeOut			: Std_logic_vector((cNOutputs-1) downto 0);

signal statevariable_voltage_integrating_v_temp_1 : sfixed (2 downto -22);
signal statevariable_voltage_integrating_v_temp_1_next : sfixed (2 downto -22);

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_current_iSyn : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iSyn_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iMemb : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_iMemb_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_voltage_v_next : sfixed (2 downto -22);
signal statevariable_time_lastSpikeTime_next : sfixed (6 downto -18);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------
signal EventPort_out_spike_internal : std_logic := '0'; 
---------------------------------------------------------------------
type regime_type is (refractory,integrating);
signal current_regime_in_int: regime_type;
signal next_regime: regime_type;
function CONV_STDLV_TO_REGIME (DATA :std_logic_vector) return regime_type is
begin
  return regime_type'val(to_integer(unsigned(DATA)));
end CONV_STDLV_TO_REGIME;

function CONV_REGIME_TO_STDLV (regime :regime_type) return std_logic_vector is 
begin
  return std_logic_vector(to_unsigned(regime_type'pos(regime),2));
end CONV_REGIME_TO_STDLV;
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
component SynapseModel 
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
signal SynapseModel_Component_done : STD_LOGIC ; signal Exposure_current_SynapseModel_i_internal : sfixed (-28 downto -53);
signal Exposure_conductance_SynapseModel_g_internal : sfixed (-22 downto -53);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
SynapseModel_uut : SynapseModel 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => SynapseModel_Component_done,
  eventport_in_in => EventPort_in_spike_aggregate(0),
  param_time_tauDecay => param_time_SynapseModel_tauDecay,
  param_conductance_gbase => param_conductance_SynapseModel_gbase,
  param_voltage_erev => param_voltage_SynapseModel_erev,
  param_time_inv_tauDecay_inv => param_time_inv_SynapseModel_tauDecay_inv,
  requirement_voltage_v => statevariable_voltage_v_in,
  Exposure_current_i => Exposure_current_SynapseModel_i_internal,
  Exposure_conductance_g => Exposure_conductance_SynapseModel_g_internal,
  statevariable_conductance_g_out => statevariable_conductance_SynapseModel_g_out,
  statevariable_conductance_g_in => statevariable_conductance_SynapseModel_g_in,
  derivedvariable_current_i_out => derivedvariable_current_SynapseModel_i_out,
  derivedvariable_current_i_in => derivedvariable_current_SynapseModel_i_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_current_SynapseModel_i <= Exposure_current_SynapseModel_i_internal;
Exposure_conductance_SynapseModel_g <= Exposure_conductance_SynapseModel_g_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_current_SynapseModel_i_internal, param_conductance_leakConductance, param_voltage_leakReversal, statevariable_voltage_v_in , derivedvariable_current_iSyn_next  )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_current_SynapseModel_i_internal, param_conductance_leakConductance, param_voltage_leakReversal, statevariable_voltage_v_in , derivedvariable_current_iSyn_next  )
begin
  derivedvariable_current_iSyn_next <= resize(( exposure_current_SynapseModel_i_internal ),-28,-53);
  derivedvariable_current_iMemb_next <= resize(( param_conductance_leakConductance *   (  param_voltage_leakReversal - statevariable_voltage_v_in  )   + derivedvariable_current_iSyn_next ),-28,-53);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_current_iSyn <= derivedvariable_current_iSyn_next;
      derivedvariable_current_iMemb <= derivedvariable_current_iMemb_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------
---------------------------------------------------------------------
-- EDRegime EDState Machine Process
---------------------------------------------------------------------

regime_state_process_comb :process (sysparam_time_simtime,current_regime_in_int,init_model,statevariable_voltage_v_in, statevariable_time_lastSpikeTime_in , param_time_refract, sysparam_time_simtime, param_voltage_thresh, statevariable_voltage_v_in )
begin 
  next_regime <= current_regime_in_int;

  if init_model = '1' then  
    next_regime <= integrating;
  else
    if ( current_regime_in_int = refractory ) and  To_slv ( resize (sysparam_time_simtime-  ( statevariable_time_lastSpikeTime_in + param_time_refract )    ,2,-18))(20)  = '0' then
      next_regime <= integrating;
    end if;
    if ( current_regime_in_int = integrating ) and  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' then
      next_regime <= refractory;
    end if;

  end if;

end process;

current_regime_out_stdlv <= CONV_REGIME_TO_STDLV(next_regime);
current_regime_in_int <= CONV_STDLV_TO_REGIME(current_regime_in_stdlv);
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
  statevariable_voltage_integrating_v_temp_1_next <= resize(statevariable_voltage_v_in + ( derivedvariable_current_iMemb * param_capacitance_inv_C_inv ) * sysparam_time_timestep,2,-22);

  subprocess_dyn_ready <= '1';
end process state_variable_process_dynamics_comb;
state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      statevariable_voltage_integrating_v_temp_1 <= statevariable_voltage_integrating_v_temp_1_next;

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,param_voltage_reset,current_regime_in_int,next_regime,statevariable_voltage_integrating_v_temp_1,derivedvariable_current_iMemb,param_capacitance_C,param_capacitance_inv_C_inv)
variable statevariable_voltage_v_temp_1 : sfixed (2 downto -22);
variable statevariable_voltage_v_temp_2 : sfixed (2 downto -22);
begin

  if ( current_regime_in_int = refractory ) then
    statevariable_voltage_v_temp_1 := resize(statevariable_voltage_v_in ,2,-22);
  end if;

  if ( current_regime_in_int = integrating ) then
    statevariable_voltage_v_temp_1 := statevariable_voltage_integrating_v_temp_1;
  end if;

  if (not ( current_regime_in_int = next_regime )) and ( next_regime = refractory ) then
    statevariable_voltage_v_temp_2 := resize( param_voltage_reset ,2,-22);
  else
    statevariable_voltage_v_temp_2 := statevariable_voltage_v_temp_1;

  end if;

  if (not ( current_regime_in_int = next_regime )) and ( next_regime = integrating ) then

  end if;
    statevariable_voltage_v_next <= statevariable_voltage_v_temp_2;
end process;

---------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_1 :process (sysparam_time_timestep,init_model,current_regime_in_int,next_regime)
variable statevariable_time_lastSpikeTime_temp_1 : sfixed (6 downto -18);
begin

  if ( current_regime_in_int = refractory ) then
    statevariable_time_lastSpikeTime_temp_1 := resize(statevariable_time_lastSpikeTime_in ,6,-18);
  end if;

  if ( current_regime_in_int = integrating ) then
    statevariable_time_lastSpikeTime_temp_1 := resize(statevariable_time_lastSpikeTime_in ,6,-18);
  end if;

  if (not ( current_regime_in_int = next_regime )) and ( next_regime = refractory ) then
    statevariable_time_lastSpikeTime_temp_1 := resize(sysparam_time_simtime,6,-18);
  else
    statevariable_time_lastSpikeTime_temp_1 := statevariable_time_lastSpikeTime_in;

  end if;

  if (not ( current_regime_in_int = next_regime )) and ( next_regime = integrating ) then

  end if;
    statevariable_time_lastSpikeTime_next <= statevariable_time_lastSpikeTime_temp_1;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

eventport_driver0 :process ( clk,sysparam_time_timestep,init_model, param_voltage_thresh, statevariable_voltage_v_in  )
variable eventport_out_spike_temp_1 : std_logic;
variable eventport_out_spike_temp_2 : std_logic;


begin
if rising_edge(clk) and subprocess_all_ready_shot = '1' then
  if ( current_regime_in_int = integrating) and  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' then
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
statevariable_voltage_v_out <= statevariable_voltage_v_next;statevariable_time_lastSpikeTime_out <= statevariable_time_lastSpikeTime_next;
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
childrenCombined_component_done_process:process(SynapseModel_component_done,CLK)
begin
  if (SynapseModel_component_done = '1') then
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
