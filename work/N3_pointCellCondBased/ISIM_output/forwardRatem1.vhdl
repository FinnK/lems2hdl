
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
entity forwardRatem1 is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_per_time_rate : in sfixed (18 downto -2);
  param_voltage_midpoint : in sfixed (2 downto -22);
  param_voltage_scale : in sfixed (2 downto -22);
  param_voltage_inv_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_r : out sfixed (18 downto -2);
  derivedvariable_per_time_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end forwardRatem1;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of forwardRatem1 is
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
signal subprocess_all_ready : STD_LOGIC := '0';signal pre_exp_r_exponential_result1 : sfixed(18 downto -13);
signal pre_exp_r_exponential_result1_next : sfixed(18 downto -13);
signal exp_r_exponential_result1 : sfixed(18 downto -13);
Component ParamExp is
generic( 
  BIT_TOP 	: integer := 20;	
  BIT_BOTTOM	: integer := -20);	
port(
  clk		: In  Std_logic;
  init_model		: In  Std_logic;
  Start	: In  Std_logic;
  Done	: Out  Std_logic;
  X		: In sfixed(BIT_TOP downto BIT_BOTTOM);
  Output	: Out sfixed(BIT_TOP downto BIT_BOTTOM)
);
end Component;
component delayDone is
generic( 
  Steps 	: integer := 10);	
port(
  clk		: In  Std_logic;
  init_model		: In  Std_logic;
  Start		: In  Std_logic;
  Done		: Out  Std_logic
);
end component;

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_none_x : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_x_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_per_time_r : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);
signal DerivedVariable_per_time_r_next : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);

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
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------

derived_variable_pre_process_comb :process ( sysparam_time_timestep, param_voltage_midpoint, requirement_voltage_v , param_voltage_scale,param_voltage_inv_scale_inv, derivedvariable_none_x , param_per_time_rate,exp_r_exponential_result1, derivedvariable_none_x , param_per_time_rate, derivedvariable_none_x  )
begin 
  pre_exp_r_exponential_result1_next <=  resize(   (  to_sfixed ( 0 ,0 , -1 ) - derivedvariable_none_x  ) ,18,-13);

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 

if (clk'EVENT AND clk = '1') then	
  if init_model  = '1' then
    pre_exp_r_exponential_result1 <= to_sfixed(0,18,-13);
  else 
    if subprocess_all_ready_shot = '1' then
      pre_exp_r_exponential_result1 <= pre_exp_r_exponential_result1_next;
    end if;
  end if;
end if;

  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;

ParamExp_0_exponential_result1 : ParamExp 
generic map( 
  BIT_TOP 	=>  18,
  BIT_BOTTOM	=> -13
)
port map (	clk => clk,
  init_model => init_model,
  Start => step_once_go,
  Done => subprocess_der_int_ready,
  X => pre_exp_r_exponential_result1 ,
  Output => exp_r_exponential_result1
);



derived_variable_process_comb :process ( sysparam_time_timestep, param_voltage_midpoint, requirement_voltage_v , param_voltage_scale,param_voltage_inv_scale_inv, derivedvariable_none_x , param_per_time_rate,exp_r_exponential_result1, derivedvariable_none_x , param_per_time_rate, derivedvariable_none_x  )
begin
  derivedvariable_none_x_next <= resize((   (  requirement_voltage_v - param_voltage_midpoint  )   * param_voltage_inv_scale_inv ),18,-13);


  if  To_slv ( resize ( derivedvariable_none_x -  ( to_sfixed ( 0 ,0 , -1 ) )   ,2,-18)) /= (20 downto 0 => '0') then
    derivedvariable_per_time_r_next <= resize(( param_per_time_rate * derivedvariable_none_x /   (  to_sfixed ( 1 ,1 , -1 ) - exp_r_exponential_result1   )   ),18,-2);
  end if;


  if  To_slv ( resize ( derivedvariable_none_x -  ( to_sfixed ( 0 ,0 , -1 ) )   ,2,-18)) = (20 downto 0 => '0') then
    derivedvariable_per_time_r_next <= resize(( param_per_time_rate ),18,-2);
  end if;
end process derived_variable_process_comb;
uut_delayDone_derivedvariable_forwardRatem1 : delayDone GENERIC MAP(
  Steps => 10
  )
PORT MAP(
  clk => clk,
  init_model => init_model,
  Start => step_once_go,
  Done => subprocess_der_ready
);
derived_variable_process_syn :process ( clk,init_model )
begin 

if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      derivedvariable_none_x <= derivedvariable_none_x_next;
      derivedvariable_per_time_r <= derivedvariable_per_time_r_next;
      derivedvariable_per_time_r <= derivedvariable_per_time_r_next;
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
exposure_per_time_r <= derivedvariable_per_time_r_in;derivedvariable_per_time_r_out <= derivedvariable_per_time_r;
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
