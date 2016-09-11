
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
entity i1 is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
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
end i1;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of i1 is
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

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_none_I_next : sfixed (18 downto -13);

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

derived_variable_pre_process_comb :process ( sysparam_time_timestep )
begin 

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;


--no complex steps in derived variables
subprocess_der_int_ready <= '1';


derived_variable_process_comb :process ( sysparam_time_timestep )
begin

  subprocess_der_ready <= '1';
end process derived_variable_process_comb;

derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
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
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,sysparam_time_simtime,param_time_delay,sysparam_time_simtime,param_time_delay,param_time_duration,sysparam_time_simtime,param_time_delay,param_none_amplitude,param_time_duration,sysparam_time_simtime,param_time_delay)
variable statevariable_none_I_temp_1 : sfixed (18 downto -13);
variable statevariable_none_I_temp_2 : sfixed (18 downto -13);
variable statevariable_none_I_temp_3 : sfixed (18 downto -13);
begin
  if  To_slv ( resize (sysparam_time_simtime-  ( param_time_delay )    ,2,-18))(20)  = '1' then
    statevariable_none_I_temp_1 := resize( to_sfixed ( 0 ,0 , -1 ) ,18,-13);
  else
    statevariable_none_I_temp_1 := statevariable_none_I_in;
  end if;
  if  To_slv ( resize (sysparam_time_simtime-  ( param_time_delay )    ,2,-18))(20)  = '0' AND  To_slv ( resize (sysparam_time_simtime-  ( param_time_duration + param_time_delay )    ,2,-18))(20)  = '1' then
    statevariable_none_I_temp_2 := resize( param_none_amplitude ,18,-13);
  else
    statevariable_none_I_temp_2 := statevariable_none_I_temp_1;
  end if;
  if  To_slv ( resize (sysparam_time_simtime-  ( param_time_duration + param_time_delay )    ,2,-18))(20)  = '0' then
    statevariable_none_I_temp_3 := resize( to_sfixed ( 0 ,0 , -1 ) ,18,-13);
  else
    statevariable_none_I_temp_3 := statevariable_none_I_temp_2;
  end if;
    statevariable_none_I_next <= statevariable_none_I_temp_3;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to exposures
---------------------------------------------------------------------
exposure_none_I <= statevariable_none_I_in;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------
statevariable_none_I_out <= statevariable_none_I_next;
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

component_done <= component_done_int;
end RTL;
