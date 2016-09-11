
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
entity synapsemodel is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
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
end synapsemodel;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of synapsemodel is
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
signal subprocess_all_ready : STD_LOGIC := '0';signal statevariable_conductance_noregime_g_temp_1 : sfixed (-22 downto -53);
signal statevariable_conductance_noregime_g_temp_1_next : sfixed (-22 downto -53);

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_current_i : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);
signal DerivedVariable_current_i_next : sfixed (-28 downto -53) := to_sfixed(0.0 ,-28,-53);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_conductance_g_next : sfixed (-22 downto -53);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------
signal EventPort_in_in_internal : std_logic := '0'; 
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------

derived_variable_pre_process_comb :process ( sysparam_time_timestep, statevariable_conductance_g_in , requirement_voltage_v , param_voltage_erev )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep, statevariable_conductance_g_in , requirement_voltage_v , param_voltage_erev )
begin
  derivedvariable_current_i_next <= resize(( statevariable_conductance_g_in *   (  param_voltage_erev - requirement_voltage_v  )   ),-28,-53);

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_current_i <= derivedvariable_current_i_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------

dynamics_pre_process_comb :process ( sysparam_time_timestep, param_time_tauDecay, statevariable_conductance_g_in ,param_time_inv_tauDecay_inv  )
begin 

end process dynamics_pre_process_comb;

dynamics_pre_process_syn :process ( clk, init_model )
begin 

  subprocess_dyn_int_pre_ready <= '1';
end process dynamics_pre_process_syn;



--No dynamics with complex equations found
subprocess_dyn_int_ready <= '1';

state_variable_process_dynamics_comb :process (sysparam_time_timestep, param_time_tauDecay, statevariable_conductance_g_in ,param_time_inv_tauDecay_inv ,statevariable_conductance_g_in)
begin
  statevariable_conductance_noregime_g_temp_1_next <= resize(statevariable_conductance_g_in + (  - statevariable_conductance_g_in * param_time_inv_tauDecay_inv ) * sysparam_time_timestep,-22,-53);

  subprocess_dyn_ready <= '1';
end process state_variable_process_dynamics_comb;
state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      statevariable_conductance_noregime_g_temp_1 <= statevariable_conductance_noregime_g_temp_1_next;

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,eventport_in_in,statevariable_conductance_g_in,param_conductance_gbase,statevariable_conductance_noregime_g_temp_1,param_time_tauDecay,statevariable_conductance_g_in,param_time_inv_tauDecay_inv)
variable statevariable_conductance_g_temp_1 : sfixed (-22 downto -53);
variable statevariable_conductance_g_temp_2 : sfixed (-22 downto -53);
begin
  statevariable_conductance_g_temp_1 := statevariable_conductance_noregime_g_temp_1;  if eventport_in_in = '1' then
    statevariable_conductance_g_temp_2 := resize( statevariable_conductance_g_in + param_conductance_gbase ,-22,-53);
  else
    statevariable_conductance_g_temp_2 := statevariable_conductance_g_temp_1;
  end if;
    statevariable_conductance_g_next <= statevariable_conductance_g_temp_2;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to exposures
---------------------------------------------------------------------
exposure_conductance_g <= statevariable_conductance_g_in;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------
statevariable_conductance_g_out <= statevariable_conductance_g_next;
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

component_done <= component_done_int;
end RTL;
