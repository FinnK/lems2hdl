
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
entity m is
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC; --SYNCHRONOUS RESET
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  component_done : out STD_LOGIC;
  requirement_voltage_v : in sfixed (2 downto -22);
  param_none_instances : in sfixed (18 downto -13);
  exposure_none_fcond : out sfixed (18 downto -13);
  exposure_none_q : out sfixed (18 downto -13);
  statevariable_none_q_out : out sfixed (18 downto -13);
  statevariable_none_q_in : in sfixed (18 downto -13);
  derivedvariable_none_fcond_out : out sfixed (18 downto -13);
  derivedvariable_none_fcond_in : in sfixed (18 downto -13);
  param_per_time_reverseRatem1_rate : in sfixed (18 downto -2);
  param_voltage_reverseRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_reverseRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_reverseRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_reverseRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_reverseRatem1_r_in : in sfixed (18 downto -2);
  param_per_time_forwardRatem1_rate : in sfixed (18 downto -2);
  param_voltage_forwardRatem1_midpoint : in sfixed (2 downto -22);
  param_voltage_forwardRatem1_scale : in sfixed (2 downto -22);
  param_voltage_inv_forwardRatem1_scale_inv : in sfixed (22 downto -2);
  exposure_per_time_forwardRatem1_r : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRatem1_r_out : out sfixed (18 downto -2);
  derivedvariable_per_time_forwardRatem1_r_in : in sfixed (18 downto -2);
  sysparam_time_timestep : in sfixed (-6 downto -22);
  sysparam_time_simtime : in sfixed (6 downto -22)
);
end m;
---------------------------------------------------------------------
-------------------------------------------------------------------------------------------
-- Architecture Begins
------------------------------------------------------------------------------------------- 

architecture RTL of m is
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
signal subprocess_all_ready : STD_LOGIC := '0';signal pre_pow_fcond_power_result1_A : sfixed(18 downto -13);
signal pre_pow_fcond_power_result1_A_next : sfixed(18 downto -13);
signal pre_pow_fcond_power_result1_X : sfixed(18 downto -13);
signal pre_pow_fcond_power_result1_X_next : sfixed(18 downto -13);
signal pow_fcond_power_result1 : sfixed(18 downto -13);
signal statevariable_none_noregime_q_temp_1 : sfixed (18 downto -13);
signal statevariable_none_noregime_q_temp_1_next : sfixed (18 downto -13);
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
Component ParamPow is
generic( 
  BIT_TOP 	: integer := 11;	
  BIT_BOTTOM	: integer := -12);
	port(
  clk		: In  Std_logic;
  init_model		: In  Std_logic;
  Start	: In  Std_logic;
  Done	: Out  Std_logic;
  X		: In sfixed(BIT_TOP downto BIT_BOTTOM);
  A		: In sfixed(BIT_TOP downto BIT_BOTTOM);
  Output	: Out sfixed(BIT_TOP downto BIT_BOTTOM)
);
end Component; 

---------------------------------------------------------------------
-- Derived Variables and parameters
---------------------------------------------------------------------
signal DerivedVariable_none_rateScale : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_rateScale_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_per_time_alpha : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);
signal DerivedVariable_per_time_alpha_next : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);
signal DerivedVariable_per_time_beta : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);
signal DerivedVariable_per_time_beta_next : sfixed (18 downto -2) := to_sfixed(0.0 ,18,-2);
signal DerivedVariable_none_fcond : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_fcond_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_inf : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_none_inf_next : sfixed (18 downto -13) := to_sfixed(0.0 ,18,-13);
signal DerivedVariable_time_tau : sfixed (6 downto -18) := to_sfixed(0.0 ,6,-18);
signal DerivedVariable_time_tau_next : sfixed (6 downto -18) := to_sfixed(0.0 ,6,-18);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- EDState internal Variables
---------------------------------------------------------------------
signal statevariable_none_q_next : sfixed (18 downto -13);

---------------------------------------------------------------------

---------------------------------------------------------------------
-- Output Port internal Variables
---------------------------------------------------------------------

---------------------------------------------------------------------
---------------------------------------------------------------------
-- Child Components
---------------------------------------------------------------------
component reverseRatem1 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
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
end component;
signal reverseRatem1_Component_done : STD_LOGIC ; signal Exposure_per_time_reverseRatem1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
component forwardRatem1 
Port (
  clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
  init_model : in STD_LOGIC;
  step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
  Component_done : out STD_LOGIC;
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
end component;
signal forwardRatem1_Component_done : STD_LOGIC ; signal Exposure_per_time_forwardRatem1_r_internal : sfixed (18 downto -2);
---------------------------------------------------------------------
---------------------------------------------------------------------
-- Begin Internal Processes
---------------------------------------------------------------------

begin
---------------------------------------------------------------------
-- Child EDComponent Instantiations and corresponding internal variables
---------------------------------------------------------------------
reverseRatem1_uut : reverseRatem1 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => reverseRatem1_Component_done,
  param_per_time_rate => param_per_time_reverseRatem1_rate,
  param_voltage_midpoint => param_voltage_reverseRatem1_midpoint,
  param_voltage_scale => param_voltage_reverseRatem1_scale,
  param_voltage_inv_scale_inv => param_voltage_inv_reverseRatem1_scale_inv,
  requirement_voltage_v => requirement_voltage_v,
  Exposure_per_time_r => Exposure_per_time_reverseRatem1_r_internal,
  derivedvariable_per_time_r_out => derivedvariable_per_time_reverseRatem1_r_out,
  derivedvariable_per_time_r_in => derivedvariable_per_time_reverseRatem1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_per_time_reverseRatem1_r <= Exposure_per_time_reverseRatem1_r_internal;
forwardRatem1_uut : forwardRatem1 
port map (
  clk => clk,
  init_model => init_model,
  step_once_go => step_once_go,
  Component_done => forwardRatem1_Component_done,
  param_per_time_rate => param_per_time_forwardRatem1_rate,
  param_voltage_midpoint => param_voltage_forwardRatem1_midpoint,
  param_voltage_scale => param_voltage_forwardRatem1_scale,
  param_voltage_inv_scale_inv => param_voltage_inv_forwardRatem1_scale_inv,
  requirement_voltage_v => requirement_voltage_v,
  Exposure_per_time_r => Exposure_per_time_forwardRatem1_r_internal,
  derivedvariable_per_time_r_out => derivedvariable_per_time_forwardRatem1_r_out,
  derivedvariable_per_time_r_in => derivedvariable_per_time_forwardRatem1_r_in,
  sysparam_time_timestep => sysparam_time_timestep,
  sysparam_time_simtime => sysparam_time_simtime
);
Exposure_per_time_forwardRatem1_r <= Exposure_per_time_forwardRatem1_r_internal;

derived_variable_pre_process_comb :process ( sysparam_time_timestep,exposure_per_time_forwardRatem1_r_internal,exposure_per_time_reverseRatem1_r_internal, param_none_instances, statevariable_none_q_in ,pow_fcond_power_result1, derivedvariable_per_time_alpha_next , derivedvariable_per_time_beta_next , derivedvariable_none_rateScale_next , derivedvariable_per_time_alpha_next , derivedvariable_per_time_beta_next  )
begin 
  pre_pow_fcond_power_result1_A_next <=  resize(  statevariable_none_q_in ,18,-13);
  pre_pow_fcond_power_result1_X_next <=  resize( param_none_instances ,18,-13);

end process derived_variable_pre_process_comb;

derived_variable_pre_process_syn :process ( clk, init_model )
begin 
if (clk'EVENT AND clk = '1') then	
  if init_model  = '1' then
    pre_pow_fcond_power_result1_A <= to_sfixed(0,18,-13);
    pre_pow_fcond_power_result1_X <= to_sfixed(0,18,-13);
  else 
    if subprocess_all_ready_shot = '1' then
      pre_pow_fcond_power_result1_A <= pre_pow_fcond_power_result1_A_next ;
      pre_pow_fcond_power_result1_X <= pre_pow_fcond_power_result1_X_next ;
    end if;
  end if;end if;  subprocess_der_int_pre_ready <= '1';
end process derived_variable_pre_process_syn;
ParamPow_fcond_power_result1 : ParamPow 
generic map( 
  BIT_TOP 	=>  18,
  BIT_BOTTOM	=> -13
)
port map (	clk => clk,
  init_model => init_model,
  Start => step_once_go,
  Done => subprocess_der_int_ready,
  X => pre_pow_fcond_power_result1_X ,
  A => pre_pow_fcond_power_result1_A ,
  Output => pow_fcond_power_result1
);


derived_variable_process_comb :process ( sysparam_time_timestep,exposure_per_time_forwardRatem1_r_internal,exposure_per_time_reverseRatem1_r_internal, param_none_instances, statevariable_none_q_in ,pow_fcond_power_result1, derivedvariable_per_time_alpha_next , derivedvariable_per_time_beta_next , derivedvariable_none_rateScale_next , derivedvariable_per_time_alpha_next , derivedvariable_per_time_beta_next  )
begin
  derivedvariable_per_time_alpha_next <= resize(( exposure_per_time_forwardRatem1_r_internal ),18,-2);
  derivedvariable_per_time_beta_next <= resize(( exposure_per_time_reverseRatem1_r_internal ),18,-2);
  derivedvariable_none_fcond_next <= resize((pow_fcond_power_result1),18,-13);
  derivedvariable_none_inf_next <= resize(( derivedvariable_per_time_alpha_next /  (  derivedvariable_per_time_alpha_next + derivedvariable_per_time_beta_next  )   ),18,-13);
  derivedvariable_time_tau_next <= resize(( to_sfixed ( 1 ,1 , -1 ) / (  ( derivedvariable_per_time_alpha_next + derivedvariable_per_time_beta_next )   )  ),6,-18);
end process derived_variable_process_comb;
uut_delayDone_derivedvariable_m : delayDone GENERIC MAP(
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
      derivedvariable_per_time_alpha <= derivedvariable_per_time_alpha_next;
      derivedvariable_per_time_beta <= derivedvariable_per_time_beta_next;
      derivedvariable_none_fcond <= derivedvariable_none_fcond_next;
      derivedvariable_none_inf <= derivedvariable_none_inf_next;
      derivedvariable_time_tau <= derivedvariable_time_tau_next;
    end if;
end if;
end process derived_variable_process_syn;
---------------------------------------------------------------------

dynamics_pre_process_comb :process ( sysparam_time_timestep, statevariable_none_q_in , derivedvariable_none_inf , derivedvariable_time_tau   )
begin 

end process dynamics_pre_process_comb;

dynamics_pre_process_syn :process ( clk, init_model )
begin 

  subprocess_dyn_int_pre_ready <= '1';
end process dynamics_pre_process_syn;



--No dynamics with complex equations found
subprocess_dyn_int_ready <= '1';

state_variable_process_dynamics_comb :process (sysparam_time_timestep, statevariable_none_q_in , derivedvariable_none_inf , derivedvariable_time_tau  ,statevariable_none_q_in)
begin
  statevariable_none_noregime_q_temp_1_next <= resize(statevariable_none_q_in + (   (  derivedvariable_none_inf - statevariable_none_q_in  )   / derivedvariable_time_tau ) * sysparam_time_timestep,18,-13);
end process state_variable_process_dynamics_comb;
uut_delayDone_statevariable_m : delayDone GENERIC MAP(
  Steps => 10
  )
PORT MAP(
  clk => clk,
  init_model => init_model,
  Start => step_once_go,
  Done => subprocess_dyn_ready
);state_variable_process_dynamics_syn :process (CLK,init_model)
begin
if clk'event and clk = '1' then  
    if subprocess_all_ready_shot = '1' then  
      statevariable_none_noregime_q_temp_1 <= statevariable_none_noregime_q_temp_1_next;

    end if;
end if;
end process state_variable_process_dynamics_syn;

------------------------------------------------------------------------------------------------------
-- EDState Variable Drivers
------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------
	-- EDState variable: $par.name Driver Process
	---------------------------------------------------------------------
state_variable_process_comb_0 :process (sysparam_time_timestep,init_model,derivedvariable_none_inf,statevariable_none_noregime_q_temp_1,statevariable_none_q_in,derivedvariable_none_inf,derivedvariable_time_tau)
variable statevariable_none_q_temp_1 : sfixed (18 downto -13);
begin
  statevariable_none_q_temp_1 := statevariable_none_noregime_q_temp_1;    statevariable_none_q_next <= statevariable_none_q_temp_1;
end process;

---------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to exposures
---------------------------------------------------------------------
exposure_none_q <= statevariable_none_q_in;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign state variables to output state variables
---------------------------------------------------------------------
statevariable_none_q_out <= statevariable_none_q_next;
---------------------------------------------------------------------

---------------------------------------------------------------------
-- Assign derived variables to exposures
---------------------------------------------------------------------
exposure_none_fcond <= derivedvariable_none_fcond_in;derivedvariable_none_fcond_out <= derivedvariable_none_fcond;
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
childrenCombined_component_done_process:process(reverseRatem1_component_done,forwardRatem1_component_done,CLK)
begin
  if (reverseRatem1_component_done = '1' and forwardRatem1_component_done = '1') then
    childrenCombined_component_done <= '1';
  else
    childrenCombined_component_done <= '0';
  end if;
end process childrenCombined_component_done_process;

component_done <= component_done_int and childrenCombined_component_done;
end RTL;
