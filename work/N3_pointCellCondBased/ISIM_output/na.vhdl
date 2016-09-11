
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
entity na is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
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
  param_per_time_m_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_m_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_m_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_m_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_m_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_m_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_m_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_m_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_m_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_m_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_m_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_m_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_m_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_m_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_none_h_instances : in sfixed (18 downto -13);
  exposure_none_h_fcond : out sfixed (18 downto -13);
  exposure_none_h_q : out sfixed (18 downto -13);
  statevariable_none_h_q_out : out sfixed (18 downto -13);
  statevariable_none_h_q_in : in sfixed (18 downto -13);
  derivedvariable_none_h_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_h_fcond_in : in sfixed (18 downto -13);
  param_per_time_h_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_h_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_h_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_h_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_h_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_h_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_h_forwardRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_h_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_h_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_h_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_h_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_h_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_h_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_h_reverseRateh1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end na;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of na is
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
signal DerivedVariable_none_conductanceScale : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_conductanceScale_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHrates : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHrates_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHtauInf : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHtauInf_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesTau : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesTau_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesInf : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesInf_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesTauInf : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopenHHratesTauInf_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopen : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fopen_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_conductance_g : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);
signal DerivedVariable_conductance_g_next : sfixed (-22 downto -53) := to_sfixed(0.0 ,-22,-53);

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
component m 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_instances : in sfixed (18 downto -13);
  exposure_none_fcond : out sfixed (18 downto -13);
  exposure_none_q : out sfixed (18 downto -13);
  statevariable_none_q_out : out sfixed (18 downto -13);
  statevariable_none_q_in : in sfixed (18 downto -13);
  derivedvariable_none_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_fcond_in : in sfixed (18 downto -13);
  param_per_time_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRatem1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal m_Component_done : STD_LOGIC ; signal Exposure_none_m_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_m_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_m_forwardRatem1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_m_reverseRatem1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
component h 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_instances : in sfixed (18 downto -13);
  exposure_none_fcond : out sfixed (18 downto -13);
  exposure_none_q : out sfixed (18 downto -13);
  statevariable_none_q_out : out sfixed (18 downto -13);
  statevariable_none_q_in : in sfixed (18 downto -13);
  derivedvariable_none_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_fcond_in : in sfixed (18 downto -13);
  param_per_time_forwardRateh1_rate : in sfixed (18 downto -2);
  param_voltage_forwardRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_forwardRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_forwardRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_forwardRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRateh1_r_in : in sfixed (18 downto -2);
  param_per_time_reverseRateh1_rate : in sfixed (18 downto -2);
  param_voltage_reverseRateh1_midpoint : in sfixed (2 downto -22);
  param_voltage_reverseRateh1_scale : in sfixed (2 downto -22);
  param_voltage_inv_reverseRateh1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_reverseRateh1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRateh1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRateh1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end component;
signal h_Component_done : STD_LOGIC ; signal Exposure_none_h_fcond_internal : sfixed (18 downto -13);
signal Exposure_none_h_q_internal : sfixed (18 downto -13);
signal Exposure_per_time_h_forwardRateh1_r_internal : sfixed (18 downto -2);
signal Exposure_per_time_h_reverseRateh1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
m_uut : m 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => m_Component_done,
  param_none_instances => param_none_m_instances,
  requirement_voltage_v => requirement_voltage_v,
  Exposure_none_fcond => Exposure_none_m_fcond_internal,
  Exposure_none_q => Exposure_none_m_q_internal,
  statevariable_none_q_out => statevariable_none_m_q_out,
  statevariable_none_q_in => statevariable_none_m_q_in,
  derivedvariable_none_fcond_out => derivedvariable_none_m_fcond_out,
  derivedvariable_none_fcond_in => derivedvariable_none_m_fcond_in,
  param_per_time_forwardRatem1_rate => param_per_time_m_forwardRatem1_rate,
  param_voltage_forwardRatem1_midpoint => param_voltage_m_forwardRatem1_midpoint,
  param_voltage_forwardRatem1_scale => param_voltage_m_forwardRatem1_scale,
  param_voltage_inv_forwardRatem1_scale_inv => param_voltage_inv_m_forwardRatem1_scale_inv,
  Exposure_per_time_forwardRatem1_r => Exposure_per_time_m_forwardRatem1_r_internal,
  derivedvariable_per_time_forwardRatem1_r_out => derivedvariable_per_time_m_forwardRatem1_r_out,
  derivedvariable_per_time_forwardRatem1_r_in => derivedvariable_per_time_m_forwardRatem1_r_in,
  param_per_time_reverseRatem1_rate => param_per_time_m_reverseRatem1_rate,
  param_voltage_reverseRatem1_midpoint => param_voltage_m_reverseRatem1_midpoint,
  param_voltage_reverseRatem1_scale => param_voltage_m_reverseRatem1_scale,
  param_voltage_inv_reverseRatem1_scale_inv => param_voltage_inv_m_reverseRatem1_scale_inv,
  Exposure_per_time_reverseRatem1_r => Exposure_per_time_m_reverseRatem1_r_internal,
  derivedvariable_per_time_reverseRatem1_r_out => derivedvariable_per_time_m_reverseRatem1_r_out,
  derivedvariable_per_time_reverseRatem1_r_in => derivedvariable_per_time_m_reverseRatem1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_none_m_fcond <= Exposure_none_m_fcond_internal;
Exposure_none_m_q <= Exposure_none_m_q_internal;
h_uut : h 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => h_Component_done,
  param_none_instances => param_none_h_instances,
  requirement_voltage_v => requirement_voltage_v,
  Exposure_none_fcond => Exposure_none_h_fcond_internal,
  Exposure_none_q => Exposure_none_h_q_internal,
  statevariable_none_q_out => statevariable_none_h_q_out,
  statevariable_none_q_in => statevariable_none_h_q_in,
  derivedvariable_none_fcond_out => derivedvariable_none_h_fcond_out,
  derivedvariable_none_fcond_in => derivedvariable_none_h_fcond_in,
  param_per_time_forwardRateh1_rate => param_per_time_h_forwardRateh1_rate,
  param_voltage_forwardRateh1_midpoint => param_voltage_h_forwardRateh1_midpoint,
  param_voltage_forwardRateh1_scale => param_voltage_h_forwardRateh1_scale,
  param_voltage_inv_forwardRateh1_scale_inv => param_voltage_inv_h_forwardRateh1_scale_inv,
  Exposure_per_time_forwardRateh1_r => Exposure_per_time_h_forwardRateh1_r_internal,
  derivedvariable_per_time_forwardRateh1_r_out => derivedvariable_per_time_h_forwardRateh1_r_out,
  derivedvariable_per_time_forwardRateh1_r_in => derivedvariable_per_time_h_forwardRateh1_r_in,
  param_per_time_reverseRateh1_rate => param_per_time_h_reverseRateh1_rate,
  param_voltage_reverseRateh1_midpoint => param_voltage_h_reverseRateh1_midpoint,
  param_voltage_reverseRateh1_scale => param_voltage_h_reverseRateh1_scale,
  param_voltage_inv_reverseRateh1_scale_inv => param_voltage_inv_h_reverseRateh1_scale_inv,
  Exposure_per_time_reverseRateh1_r => Exposure_per_time_h_reverseRateh1_r_internal,
  derivedvariable_per_time_reverseRateh1_r_out => derivedvariable_per_time_h_reverseRateh1_r_out,
  derivedvariable_per_time_reverseRateh1_r_in => derivedvariable_per_time_h_reverseRateh1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_none_h_fcond <= Exposure_none_h_fcond_internal;
Exposure_none_h_q <= Exposure_none_h_q_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_none_m_fcond_internal,exposure_none_h_fcond_internal, derivedvariable_none_fopenHHratesTauInf_next , derivedvariable_none_conductanceScale_next , derivedvariable_none_fopenHHratesInf_next , derivedvariable_none_fopenHHratesTau_next , derivedvariable_none_fopenHHtauInf_next , derivedvariable_none_fopenHHrates_next , param_conductance_conductance, derivedvariable_none_fopen_next  )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_none_m_fcond_internal,exposure_none_h_fcond_internal, derivedvariable_none_fopenHHratesTauInf_next , derivedvariable_none_conductanceScale_next , derivedvariable_none_fopenHHratesInf_next , derivedvariable_none_fopenHHratesTau_next , derivedvariable_none_fopenHHtauInf_next , derivedvariable_none_fopenHHrates_next , param_conductance_conductance, derivedvariable_none_fopen_next  )
begin
  derivedvariable_none_fopenHHrates_next <= resize((  ( exposure_none_m_fcond_internal  *  exposure_none_h_fcond_internal )  ),18,-13);
  derivedvariable_none_fopen_next <= resize(( derivedvariable_none_fopenHHrates_next  ),18,-13);
  derivedvariable_conductance_g_next <= resize(( param_conductance_conductance * derivedvariable_none_fopen_next ),-22,-53);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_none_fopenHHrates <= derivedvariable_none_fopenHHrates_next;
      derivedvariable_none_fopen <= derivedvariable_none_fopen_next;
      derivedvariable_conductance_g <= derivedvariable_conductance_g_next;
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
exposure_conductance_g <= derivedvariable_conductance_g_in;derivedvariable_conductance_g_out <= derivedvariable_conductance_g;
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
childrenCombined_component_done_process:process(m_component_done,h_component_done,CLK)
begin
  if (m_component_done = '1' and h_component_done = '1') then
    childrenCombined_component_done <= '1';
  else
    childrenCombined_component_done <= '0';
  end if;
end process childrenCombined_component_done_process;

component_done <= component_done_int and childrenCombined_component_done;
end RTL;
