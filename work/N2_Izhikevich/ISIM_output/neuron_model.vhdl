
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
  eventport_out_spike : out STD_LOGIC;
  param_voltage_v0 : in sfixed (2 downto -22);
  param_none_a : in sfixed (18 downto -13);
  param_none_b : in sfixed (18 downto -13);
  param_none_c : in sfixed (18 downto -13);
  param_none_d : in sfixed (18 downto -13);
  param_voltage_thresh : in sfixed (2 downto -22);
  param_time_MSEC : in sfixed (6 downto -18);
  param_voltage_MVOLT : in sfixed (2 downto -22);
  param_time_inv_MSEC_inv : in sfixed (18 downto -6);
  param_voltage_inv_MVOLT_inv : in sfixed (22 downto -2);
  param_none_div_voltage_b_div_MVOLT : in sfixed (18 downto -13);
  exposure_voltage_v : out sfixed (2 downto -22);
  exposure_none_U : out sfixed (18 downto -13);
  statevariable_voltage_v_out : out sfixed (2 downto -22);
  statevariable_voltage_v_in : in sfixed (2 downto -22);
  statevariable_none_U_out : out sfixed (18 downto -13);
  statevariable_none_U_in : in sfixed (18 downto -13);
  param_time_i1_delay : in sfixed (6 downto -18);
  param_time_i1_duration : in sfixed (6 downto -18);
  param_none_i1_amplitude : in sfixed (18 downto -13);
  exposure_none_i1_I : out sfixed (18 downto -13);
  statevariable_none_i1_I_out : out sfixed (18 downto -13);
  statevariable_none_i1_I_in : in sfixed (18 downto -13);
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

signal statevariable_voltage_noregime_v_temp_1 : sfixed (2 downto -22);
signal statevariable_voltage_noregime_v_temp_1_next : sfixed (2 downto -22);
signal statevariable_none_noregime_U_temp_1 : sfixed (18 downto -13);
signal statevariable_none_noregime_U_temp_1_next : sfixed (18 downto -13);

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_none_ISyn : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_ISyn_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_voltage_v_next : sfixed (2 downto -22);
signal statevariable_none_U_next : sfixed (18 downto -13);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------
signal EventPort_out_spike_internal : std_logic := '0'; 
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
component i1 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  eventport_in_in : in STD_LOGIC;
  param_time_delay : in sfixed (6 downto -18);
  param_time_duration : in sfixed (6 downto -18);
  param_none_amplitude : in sfixed (18 downto -13);
  exposure_none_I : out sfixed (18 downto -13);
  statevariable_none_I_out : out sfixed (18 downto -13);
  statevariable_none_I_in : in sfixed (18 downto -13);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal i1_Component_done : STD_LOGIC ; signal Exposure_none_i1_I_internal : sfixed (18 downto -13);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
i1_uut : i1 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => i1_Component_done,
  eventport_in_in => EventPort_in_spike_aggregate(0),
  param_time_delay => param_time_i1_delay,
  param_time_duration => param_time_i1_duration,
  param_none_amplitude => param_none_i1_amplitude,
  Exposure_none_I => Exposure_none_i1_I_internal,
  statevariable_none_I_out => statevariable_none_i1_I_out,
  statevariable_none_I_in => statevariable_none_i1_I_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_none_i1_I <= Exposure_none_i1_I_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_none_i1_I_internal )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_none_i1_I_internal )
begin
  derivedvariable_none_ISyn_next <= resize(( exposure_none_i1_I_internal ),18,-13);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_none_ISyn <= derivedvariable_none_ISyn_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------

dynamics_pre_process_comb :process ( sysparam_time_timestep, param_voltage_MVOLT, statevariable_voltage_v_in , statevariable_none_U_in , param_time_MSEC, derivedvariable_none_ISyn ,param_time_inv_MSEC_inv,param_voltage_inv_MVOLT_inv , param_voltage_MVOLT, param_none_a, param_none_b, statevariable_voltage_v_in , statevariable_none_U_in , param_time_MSEC  )
begin 

end process dynamics_pre_process_comb;

dynamics_pre_process_syn :process ( clk, init_model )
begin 

  subprocess_dyn_int_pre_ready <= '1';
end process dynamics_pre_process_syn;



--No dynamics with complex equations found
subprocess_dyn_int_ready <= '1';

state_variable_process_dynamics_comb :process (sysparam_time_timestep, param_voltage_MVOLT, statevariable_voltage_v_in , statevariable_none_U_in , param_time_MSEC, derivedvariable_none_ISyn ,param_time_inv_MSEC_inv,param_voltage_inv_MVOLT_inv , param_voltage_MVOLT, param_none_a, param_none_b, statevariable_voltage_v_in , statevariable_none_U_in , param_time_MSEC ,statevariable_voltage_v_in,statevariable_none_U_in)
begin
  statevariable_voltage_noregime_v_temp_1_next <= resize(statevariable_voltage_v_in + (   (  to_sfixed ( 0.04 ,0 , -27 ) * statevariable_voltage_v_in * statevariable_voltage_v_in * param_voltage_inv_MVOLT_inv + to_sfixed ( 5 ,3 , -1 ) * statevariable_voltage_v_in +   (  to_sfixed ( 140.0 ,8 , -1 ) - statevariable_none_U_in + derivedvariable_none_ISyn  )   * param_voltage_MVOLT  )  * param_time_inv_MSEC_inv ) * sysparam_time_timestep,2,-22);
  statevariable_none_noregime_U_temp_1_next <= resize(statevariable_none_U_in + ( param_none_a *   (  param_none_b * statevariable_voltage_v_in * param_voltage_inv_MVOLT_inv - statevariable_none_U_in  )   * param_time_inv_MSEC_inv ) * sysparam_time_timestep,18,-13);

  subprocess_dyn_ready <= '1';
end process state_variable_process_dynamics_comb;
state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      statevariable_voltage_noregime_v_temp_1 <= statevariable_voltage_noregime_v_temp_1_next;
      statevariable_none_noregime_U_temp_1 <= statevariable_none_noregime_U_temp_1_next;

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,param_voltage_v0,param_voltage_thresh,statevariable_voltage_v_in,param_voltage_MVOLT,param_none_c,param_none_d,statevariable_none_U_in,statevariable_voltage_noregime_v_temp_1,param_voltage_MVOLT,statevariable_voltage_v_in,statevariable_none_U_in,param_time_MSEC,derivedvariable_none_ISyn,param_time_inv_MSEC_inv,param_voltage_inv_MVOLT_inv)
variable statevariable_voltage_v_temp_1 : sfixed (2 downto -22);
variable statevariable_voltage_v_temp_2 : sfixed (2 downto -22);
begin
  statevariable_voltage_v_temp_1 := statevariable_voltage_noregime_v_temp_1;  if  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' then
    statevariable_voltage_v_temp_2 := resize( param_none_c * param_voltage_MVOLT ,2,-22);
  else
    statevariable_voltage_v_temp_2 := statevariable_voltage_v_temp_1;
  end if;
    statevariable_voltage_v_next <= statevariable_voltage_v_temp_2;
end process;

---------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_1 :process (sysparam_time_timestep,init_model,param_voltage_v0,param_voltage_MVOLT,param_none_b,param_voltage_v0,param_none_div_voltage_b_div_MVOLT,param_voltage_thresh,statevariable_voltage_v_in,param_voltage_MVOLT,param_none_c,param_none_d,statevariable_none_U_in,statevariable_none_noregime_U_temp_1,param_voltage_MVOLT,param_none_a,param_none_b,statevariable_voltage_v_in,statevariable_none_U_in,param_time_MSEC)
variable statevariable_none_U_temp_1 : sfixed (18 downto -13);
variable statevariable_none_U_temp_2 : sfixed (18 downto -13);
begin
  statevariable_none_U_temp_1 := statevariable_none_noregime_U_temp_1;  if  To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' then
    statevariable_none_U_temp_2 := resize( statevariable_none_U_in + param_none_d ,18,-13);
  else
    statevariable_none_U_temp_2 := statevariable_none_U_temp_1;
  end if;
    statevariable_none_U_next <= statevariable_none_U_temp_2;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

eventport_driver0 :process ( clk,sysparam_time_timestep,init_model, param_voltage_thresh, statevariable_voltage_v_in , param_voltage_MVOLT, param_none_c, param_none_d, statevariable_none_U_in  )
variable eventport_out_spike_temp_1 : std_logic;
variable eventport_out_spike_temp_2 : std_logic;


begin
if rising_edge(clk) and subprocess_all_ready_shot = '1' then
  if   To_slv ( resize ( statevariable_voltage_v_in -  ( param_voltage_thresh )    ,2,-18))(20)  = '0' then
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
exposure_voltage_v <= statevariable_voltage_v_in;exposure_none_U <= statevariable_none_U_in;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------
statevariable_voltage_v_out <= statevariable_voltage_v_next;statevariable_none_U_out <= statevariable_none_U_next;
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
childrenCombined_component_done_process:process(i1_component_done,CLK)
begin
  if (i1_component_done = '1') then
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
