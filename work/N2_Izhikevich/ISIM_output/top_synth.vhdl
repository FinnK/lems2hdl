
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
  neuron_model_param_none_a : in sfixed (18 downto -13);
  neuron_model_param_none_b : in sfixed (18 downto -13);
  neuron_model_param_none_c : in sfixed (18 downto -13);
  neuron_model_param_none_d : in sfixed (18 downto -13);
  neuron_model_param_voltage_thresh : in sfixed (2 downto -22);
  neuron_model_param_time_MSEC : in sfixed (6 downto -18);
  neuron_model_param_voltage_MVOLT : in sfixed (2 downto -22);
  neuron_model_param_time_inv_MSEC_inv : in sfixed (18 downto -6);
  neuron_model_param_voltage_inv_MVOLT_inv : in sfixed (22 downto -2);
  neuron_model_param_none_div_voltage_b_div_MVOLT : in sfixed (18 downto -13);
  neuron_model_exposure_voltage_v : out sfixed (2 downto -22);
  neuron_model_exposure_none_U : out sfixed (18 downto -13);
  neuron_model_stateCURRENT_voltage_v : out sfixed (2 downto -22);
  neuron_model_stateRESTORE_voltage_v : in sfixed (2 downto -22);
  neuron_model_stateCURRENT_none_U : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_U : in sfixed (18 downto -13);
  neuron_model_param_time_i1_delay : in sfixed (6 downto -18);
  neuron_model_param_time_i1_duration : in sfixed (6 downto -18);
  neuron_model_param_none_i1_amplitude : in sfixed (18 downto -13);
  neuron_model_exposure_none_i1_I : out sfixed (18 downto -13);
  neuron_model_stateCURRENT_none_i1_I : out sfixed (18 downto -13);
  neuron_model_stateRESTORE_none_i1_I : in sfixed (18 downto -13);

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

           sysparam_time_timestep : sfixed (-6 downto -22);
           sysparam_time_simtime : sfixed (6 downto -22)
		   );
end component;



	signal neuron_model_eventport_out_spike_out : STD_LOGIC := '0';
	signal neuron_model_statevariable_voltage_v_out_int : sfixed (2 downto -22);signal neuron_model_statevariable_voltage_v_in_int : sfixed (2 downto -22);signal neuron_model_statevariable_none_U_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_U_in_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_i1_I_out_int : sfixed (18 downto -13);signal neuron_model_statevariable_none_i1_I_in_int : sfixed (18 downto -13);
begin


neuron_model_uut : neuron_model
    port map (	clk => clk,
				init_model=> init_model,
		   step_once_go  => step_once_go_int,
		   step_once_complete  => step_once_complete_int,
		   eventport_in_spike_aggregate => eventport_in_spike_aggregate,
		   			eventport_out_spike => neuron_model_eventport_out_spike_int ,
			param_voltage_v0 => neuron_model_param_voltage_v0 ,
			param_none_a => neuron_model_param_none_a ,
			param_none_b => neuron_model_param_none_b ,
			param_none_c => neuron_model_param_none_c ,
			param_none_d => neuron_model_param_none_d ,
			param_voltage_thresh => neuron_model_param_voltage_thresh ,
			param_time_MSEC => neuron_model_param_time_MSEC ,
			param_voltage_MVOLT => neuron_model_param_voltage_MVOLT ,
			param_time_inv_MSEC_inv => neuron_model_param_time_inv_MSEC_inv ,
			param_voltage_inv_MVOLT_inv => neuron_model_param_voltage_inv_MVOLT_inv ,
			param_none_div_voltage_b_div_MVOLT => neuron_model_param_none_div_voltage_b_div_MVOLT ,
			statevariable_voltage_v_out => neuron_model_statevariable_voltage_v_out_int,
			statevariable_voltage_v_in => neuron_model_statevariable_voltage_v_in_int,
			statevariable_none_U_out => neuron_model_statevariable_none_U_out_int,
			statevariable_none_U_in => neuron_model_statevariable_none_U_in_int,
			param_time_i1_delay => neuron_model_param_time_i1_delay ,
			param_time_i1_duration => neuron_model_param_time_i1_duration ,
			param_none_i1_amplitude => neuron_model_param_none_i1_amplitude ,
			statevariable_none_i1_I_out => neuron_model_statevariable_none_i1_I_out_int,
			statevariable_none_i1_I_in => neuron_model_statevariable_none_i1_I_in_int,

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
			neuron_model_statevariable_none_U_in_int <= neuron_model_stateRESTORE_none_U;
			neuron_model_statevariable_none_i1_I_in_int <= neuron_model_stateRESTORE_none_i1_I;
			neuron_model_eventport_out_spike_out <= '0';

		 
         elsif (seven_steps_done_shot='1') then
			neuron_model_eventport_out_spike_out <= neuron_model_eventport_out_spike_int3 ;
			neuron_model_statevariable_voltage_v_in_int <= neuron_model_statevariable_voltage_v_out_int;
			neuron_model_statevariable_none_U_in_int <= neuron_model_statevariable_none_U_out_int;
			neuron_model_statevariable_none_i1_I_in_int <= neuron_model_statevariable_none_i1_I_out_int;

else
			neuron_model_eventport_out_spike_out <= '0';
		
end if;
end if;
    

 end process store_state;
 			neuron_model_stateCURRENT_voltage_v <= neuron_model_statevariable_voltage_v_in_int;
			neuron_model_stateCURRENT_none_U <= neuron_model_statevariable_none_U_in_int;
			neuron_model_stateCURRENT_none_i1_I <= neuron_model_statevariable_none_i1_I_in_int;


 neuron_model_eventport_out_spike <= neuron_model_eventport_out_spike_out;
 step_once_complete <= seven_steps_done_shot2;

end top;