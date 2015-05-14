
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
entity naChans is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
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
  param_per_time_na_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_na_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_na_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_na_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_none_na_h_instances : in sfixed (18 downto -13);
  exposure_none_na_h_fcond : out sfixed (18 downto -13);
  exposure_none_na_h_q : out sfixed (18 downto -13);
  statevariable_none_na_h_q_out : out sfixed (18 downto -13);
  statevariable_none_na_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_na_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_na_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_na_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_na_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_reverseRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_na_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_na_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_na_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_na_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_na_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_na_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end naChans;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of naChans is
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
---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_conductance_channelg : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);
signal DerivedVariable_conductance_channelg_next : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);
signal DerivedVariable_conductance_geff : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);
signal DerivedVariable_conductance_geff_next : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);
signal DerivedVariable_current_i : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_i_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
component na 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_conductance_conductance : in sfixed (-22 downto -53);
  exposure_conductance_g : out sfixed (-22 downto -53);
  derivedvariable_conductance_g_out : out sfixed (-22 downto -53);
  derivedvariable_conductance_g_in : in sfixed (-22 downto -53);
  param_none_m_instances : in sfixed (18 downto -13);
  exposure_none_m_fcond : out sfixed (18 downto -13);
  exposure_none_m_q : out sfixed (18 downto -13);
  statevariable_none_m_q_out : out sfixed (18 downto -13);
  statevariable_none_m_q_in : in sfixed (18 downto -13);
  derivedvariable_none_m_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_m_fcond_in : in sfixed (18 downto -13);
  param_per_time_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_none_h_instances : in sfixed (18 downto -13);
  exposure_none_h_fcond : out sfixed (18 downto -13);
  exposure_none_h_q : out sfixed (18 downto -13);
  statevariable_none_h_q_out : out sfixed (18 downto -13);
  statevariable_none_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_h_reverseRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal na_Component_done : STD_LOGIC ; signal Exposure_conductance_na_g_internal : sfixed (-22 downto -53);
signal Exposure_none_na_m_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_na_m_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_na_m_reverseRatem1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_na_m_forwardRatem1_r_internal : sfixed (18 downto -2);
signal Exposure_none_na_h_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_na_h_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_na_h_reverseRateh1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_na_h_forwardRateh1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
na_uut : na 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => na_Component_done,
  param_conductance_conductance => param_conductance_na_conductance,
  requirement_voltage_v => requirement_voltage_v,
  Exposure_conductance_g => Exposure_conductance_na_g_internal,
  derivedvariable_conductance_g_out => derivedvariable_conductance_na_g_out,
  derivedvariable_conductance_g_in => derivedvariable_conductance_na_g_in,
  param_none_m_instances => param_none_na_m_instances,
  Exposure_none_m_fcond => Exposure_none_na_m_fcond_internal,
  Exposure_none_m_q => Exposure_none_na_m_q_internal,
  statevariable_none_m_q_out => statevariable_none_na_m_q_out,
  statevariable_none_m_q_in => statevariable_none_na_m_q_in,
  derivedvariable_none_m_fcond_out => derivedvariable_none_na_m_fcond_out,
  derivedvariable_none_m_fcond_in => derivedvariable_none_na_m_fcond_in,
  param_per_time_m_reverseRatem1_rate => param_per_time_na_m_reverseRatem1_rate,
  param_voltage_m_reverseRatem1_midpoint => param_voltage_na_m_reverseRatem1_midpoint,
  param_voltage_m_reverseRatem1_scale => param_voltage_na_m_reverseRatem1_scale,
  param_voltage_inv_m_reverseRatem1_scale_inv => param_voltage_inv_na_m_reverseRatem1_scale_inv,
  Exposure_per_time_m_reverseRatem1_r => Exposure_per_time_na_m_reverseRatem1_r_internal,
  derivedvariable_per_time_m_reverseRatem1_r_out => derivedvariable_per_time_na_m_reverseRatem1_r_out,
  derivedvariable_per_time_m_reverseRatem1_r_in => derivedvariable_per_time_na_m_reverseRatem1_r_in,
  param_per_time_m_forwardRatem1_rate => param_per_time_na_m_forwardRatem1_rate,
  param_voltage_m_forwardRatem1_midpoint => param_voltage_na_m_forwardRatem1_midpoint,
  param_voltage_m_forwardRatem1_scale => param_voltage_na_m_forwardRatem1_scale,
  param_voltage_inv_m_forwardRatem1_scale_inv => param_voltage_inv_na_m_forwardRatem1_scale_inv,
  Exposure_per_time_m_forwardRatem1_r => Exposure_per_time_na_m_forwardRatem1_r_internal,
  derivedvariable_per_time_m_forwardRatem1_r_out => derivedvariable_per_time_na_m_forwardRatem1_r_out,
  derivedvariable_per_time_m_forwardRatem1_r_in => derivedvariable_per_time_na_m_forwardRatem1_r_in,
  param_none_h_instances => param_none_na_h_instances,
  Exposure_none_h_fcond => Exposure_none_na_h_fcond_internal,
  Exposure_none_h_q => Exposure_none_na_h_q_internal,
  statevariable_none_h_q_out => statevariable_none_na_h_q_out,
  statevariable_none_h_q_in => statevariable_none_na_h_q_in,
  derivedvariable_none_h_fcond_out => derivedvariable_none_na_h_fcond_out,
  derivedvariable_none_h_fcond_in => derivedvariable_none_na_h_fcond_in,
  param_per_time_h_reverseRateh1_rate => param_per_time_na_h_reverseRateh1_rate,
  param_voltage_h_reverseRateh1_midpoint => param_voltage_na_h_reverseRateh1_midpoint,
  param_voltage_h_reverseRateh1_scale => param_voltage_na_h_reverseRateh1_scale,
  param_voltage_inv_h_reverseRateh1_scale_inv => param_voltage_inv_na_h_reverseRateh1_scale_inv,
  Exposure_per_time_h_reverseRateh1_r => Exposure_per_time_na_h_reverseRateh1_r_internal,
  derivedvariable_per_time_h_reverseRateh1_r_out => derivedvariable_per_time_na_h_reverseRateh1_r_out,
  derivedvariable_per_time_h_reverseRateh1_r_in => derivedvariable_per_time_na_h_reverseRateh1_r_in,
  param_per_time_h_forwardRateh1_rate => param_per_time_na_h_forwardRateh1_rate,
  param_voltage_h_forwardRateh1_midpoint => param_voltage_na_h_forwardRateh1_midpoint,
  param_voltage_h_forwardRateh1_scale => param_voltage_na_h_forwardRateh1_scale,
  param_voltage_inv_h_forwardRateh1_scale_inv => param_voltage_inv_na_h_forwardRateh1_scale_inv,
  Exposure_per_time_h_forwardRateh1_r => Exposure_per_time_na_h_forwardRateh1_r_internal,
  derivedvariable_per_time_h_forwardRateh1_r_out => derivedvariable_per_time_na_h_forwardRateh1_r_out,
  derivedvariable_per_time_h_forwardRateh1_r_in => derivedvariable_per_time_na_h_forwardRateh1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_conductance_na_g <= Exposure_conductance_na_g_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_conductance_na_g_internal, derivedvariable_conductance_channelg_next , param_none_number, requirement_voltage_v , derivedvariable_conductance_geff_next , param_voltage_erev )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_conductance_na_g_internal, derivedvariable_conductance_channelg_next , param_none_number, requirement_voltage_v , derivedvariable_conductance_geff_next , param_voltage_erev )
begin
  derivedvariable_conductance_channelg_next <= resize(( exposure_conductance_na_g_internal ),-22,-53);
  derivedvariable_conductance_geff_next <= resize(( derivedvariable_conductance_channelg_next * param_none_number ),-22,-53);
  derivedvariable_current_i_next <= resize(( derivedvariable_conductance_geff_next *   (  param_voltage_erev - requirement_voltage_v  )   ),-28,-53);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_conductance_channelg <= derivedvariable_conductance_channelg_next;
      derivedvariable_conductance_geff <= derivedvariable_conductance_geff_next;
      derivedvariable_current_i <= derivedvariable_current_i_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------

dynamics_pre_process_comb :process ( sysparam_time_timestep )
begin 

end process dynamics_pre_process_comb;

dynamics_pre_process_syn :process ( clk, init_model )
begin 

  subprocess_dyn_int_pre_ready <= '1';
end process dynamics_pre_process_syn;



--No dynamics with complex equations found
subprocess_dyn_int_ready <= '1';

state_variable_process_dynamics_comb :process (sysparam_time_timestep)
begin

  subprocess_dyn_ready <= '1';
end process state_variable_process_dynamics_comb;
state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to exposures
---------------------------------------------------------------------

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign derived variables to exposures
---------------------------------------------------------------------
exposure_current_i <= derivedvariable_current_i_in;derivedvariable_current_i_out <= derivedvariable_current_i;
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
childrenCombined_component_done_process:process(na_component_done,CLK)
begin
  if (na_component_done = '1') then
    childrenCombined_component_done <= '1';
  else
    childrenCombined_component_done <= '0';
  end if;
end process childrenCombined_component_done_process;

component_done <= component_done_int and childrenCombined_component_done;
end RTL;
