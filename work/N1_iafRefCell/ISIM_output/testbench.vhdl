
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;
use ieee_proposed.fixed_float_types.ALL;
use std.textio.all;
use ieee.std_logic_textio.all; -- if you're saving this type of signal
entity tb_simulation is
end tb_simulation;


architecture tb of tb_simulation is

FILE test_out_data: TEXT open WRITE_MODE is "VHDLoutput.csv";component top_synth 
    Port (
		   clk : in STD_LOGIC; --SYSTEM CLOCK, THIS ITSELF DOES NOT SIGNIFY TIME STEPS - AKA A SINGLE TIMESTEP MAY TAKE MANY CLOCK CYCLES
          init_model : in STD_LOGIC; --SYNCHRONOUS RESET
		   step_once_go : in STD_LOGIC; --signals to the neuron from the core that a time step is to be simulated
		   step_once_complete : out STD_LOGIC; --signals to the core that a time step has finished
		   eventport_in_spike_aggregate : in STD_LOGIC_VECTOR(511 downto 0);
			neuron_model_eventport_out_spike : out STD_LOGIC;
			neuron_model_current_regimeRESTORE_stdlv : in STD_LOGIC_VECTOR(1 downto 0);
			neuron_model_current_regimeCurrent_stdlv : out STD_LOGIC_VECTOR(1 downto 0);
  neuron_model_param_time_refract : in sfixed (6 downto -18);
  neuron_model_param_conductance_leakConductance : in sfixed (-22 downto -53);
  neuron_model_param_voltage_leakReversal : in sfixed (2 downto -22);
  neuron_model_param_voltage_thresh : in sfixed (2 downto -22);
  neuron_model_param_voltage_reset : in sfixed (2 downto -22);
  neuron_model_param_capacitance_C : in sfixed (-33 downto -47);
  neuron_model_param_capacitance_inv_C_inv : in sfixed (47 downto 33);
  neuron_model_exposure_voltage_v : out sfixed (2 downto -22);
  neuron_model_stateCURRENT_voltage_v : out sfixed (2 downto -22);
  neuron_model_stateRESTORE_voltage_v : in sfixed (2 downto -22);
  neuron_model_stateCURRENT_time_lastSpikeTime : out sfixed (6 downto -18);
  neuron_model_stateRESTORE_time_lastSpikeTime : in sfixed (6 downto -18);
  neuron_model_param_time_SynapseModel_tauDecay : in sfixed (6 downto -18);
  neuron_model_param_conductance_SynapseModel_gbase : in sfixed (-22 downto -53);
  neuron_model_param_voltage_SynapseModel_erev : in sfixed (2 downto -22);
  neuron_model_param_time_inv_SynapseModel_tauDecay_inv : in sfixed (18 downto -6);
  neuron_model_exposure_current_SynapseModel_i : out sfixed (-28 downto -53);
  neuron_model_exposure_conductance_SynapseModel_g : out sfixed (-22 downto -53);
  neuron_model_stateCURRENT_conductance_SynapseModel_g : out sfixed (-22 downto -53);
  neuron_model_stateRESTORE_conductance_SynapseModel_g : in sfixed (-22 downto -53);
  neuron_model_stateCURRENT_current_SynapseModel_i : out sfixed (-28 downto -53);
  neuron_model_stateRESTORE_current_SynapseModel_i : in sfixed (-28 downto -53);
           sysparam_time_timestep : in sfixed (-6 downto -22);
           sysparam_time_simtime : in sfixed (6 downto -22)
	);
end component;


	signal clk 			: std_logic := '0';
	signal eog 			: std_logic := '0';
	signal init_model 			: std_logic := '1';
	signal step_once_go 			: std_logic := '0';
	
	signal step_once_complete 			: std_logic := '0';
	signal eventport_in_spike_aggregate : STD_LOGIC_VECTOR(511 downto 0);
	signal sysparam_time_simtime  : sfixed ( 6 downto -22) := to_sfixed (0.0,6 , -22);
	signal Errors		: integer;
	signal sysparam_time_timestep : sfixed (-6 downto -22) := to_sfixed( 5.0E-5 ,-6,-22);
	signal neuron_model_stateCURRENT_voltage_v_int : sfixed (2 downto -22);signal neuron_model_stateCURRENT_time_lastSpikeTime_int : sfixed (6 downto -18);signal neuron_model_eventport_out_spike_internal : std_logic; signal neuron_model_stateCURRENT_conductance_SynapseModel_g_int : sfixed (-22 downto -53);signal neuron_model_stateCURRENT_current_SynapseModel_i_int : sfixed (-28 downto -53);signal neuron_model_eventport_in_SynapseModel_in_internal : std_logic; 			signal neuron_model_current_regimeCurrent_stdlv_internal : STD_LOGIC_VECTOR(1 downto 0);

file stimulus: TEXT open read_mode is "stimulus.csv";

begin


top_synth_uut : top_synth 
    port map (	clk => clk,
				init_model => init_model,
		   step_once_go  => step_once_go,
		   step_once_complete  => step_once_complete,
		   eventport_in_spike_aggregate => eventport_in_spike_aggregate,
			neuron_model_eventport_out_spike => neuron_model_eventport_out_spike_internal ,
			neuron_model_current_regimeRESTORE_stdlv => (others => '0'),
			neuron_model_current_regimeCurrent_stdlv => neuron_model_current_regimeCurrent_stdlv_internal
,			neuron_model_param_time_refract => to_sfixed (0.01,6 , -18),
			neuron_model_param_conductance_leakConductance => to_sfixed (3.0E-11,-22 , -53),
			neuron_model_param_voltage_leakReversal => to_sfixed (-0.07,2 , -22),
			neuron_model_param_voltage_thresh => to_sfixed (-0.055,2 , -22),
			neuron_model_param_voltage_reset => to_sfixed (-0.07,2 , -22),
			neuron_model_param_capacitance_C => to_sfixed (4.0E-12,-33 , -47),
			neuron_model_param_capacitance_inv_C_inv => to_sfixed (2.49999999E11,47 , 33),
			neuron_model_stateCURRENT_voltage_v => neuron_model_stateCURRENT_voltage_v_int,
			neuron_model_stateRESTORE_voltage_v => to_sfixed (-0.07,2 , -22),
			neuron_model_stateCURRENT_time_lastSpikeTime => neuron_model_stateCURRENT_time_lastSpikeTime_int,
			neuron_model_stateRESTORE_time_lastSpikeTime => to_sfixed (0.0,6 , -18),
			neuron_model_param_time_SynapseModel_tauDecay => to_sfixed (0.003,6 , -18),
			neuron_model_param_conductance_SynapseModel_gbase => to_sfixed (2.5E-10,-22 , -53),
			neuron_model_param_voltage_SynapseModel_erev => to_sfixed (0.0,2 , -22),
			neuron_model_param_time_inv_SynapseModel_tauDecay_inv => to_sfixed (333.33334,18 , -6),
			neuron_model_stateCURRENT_conductance_SynapseModel_g => neuron_model_stateCURRENT_conductance_SynapseModel_g_int,
			neuron_model_stateRESTORE_conductance_SynapseModel_g => to_sfixed (0.0,-22 , -53),
			neuron_model_stateCURRENT_current_SynapseModel_i => neuron_model_stateCURRENT_current_SynapseModel_i_int,
			neuron_model_stateRESTORE_current_SynapseModel_i => to_sfixed (0.0,-28 , -53),

           sysparam_time_timestep => sysparam_time_timestep,
           sysparam_time_simtime => sysparam_time_simtime
		   );
		
receive_data: process 

variable l: line;

variable char : character; 

variable s : STD_LOGIC_VECTOR(0 downto 0); 

begin            
   -- wait for Reset to complete
   -- wait until init_model='1';
   wait until init_model='0';

   
   while not endfile(stimulus) loop

     -- read digital data from input file
     readline(stimulus, l);


     read(l, s);
eventport_in_spike_aggregate(0) <= s(0);
     wait until step_once_go = '1';

   end loop;
    
   
   wait;

 end process receive_data;

	process
	variable L1              : LINE;
    begin
	write(L1, "SimulationTime " );
	write(L1, "neuron_model_spike " );

				write(L1, "neuron_model_stateCURRENT_voltage_v" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_time_lastSpikeTime" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_conductance_SynapseModel_g" );
				write(L1, " ");
		
				write(L1, "neuron_model_stateCURRENT_current_SynapseModel_i" );
				write(L1, " ");
		
				writeline(test_out_data, L1); -- write row to output file
        Wait;
    end process;
	
	clk <= not(clk) after 10 ns;
	
step_once_go_proc: process 


begin            
   -- wait for Reset to complete
   -- wait until init_model='1';
   wait until init_model='0';
   
   wait for 180 ns;
   while 1 = 1 loop
		step_once_go <= '1';
		wait for 20 ns;
		step_once_go <= '0';
		wait until step_once_complete = '1';
		wait until step_once_complete = '0';
   end loop;
    

 end process step_once_go_proc;
 
 
 
 process
 begin
   wait for 20 ns;
	init_model <= '1';
   wait for 20 ns;
	init_model <= '0';
wait;
 end process ;
  
	--
	-- Print the results at each clock tick.
	--
	process(step_once_complete)
	variable L1              : LINE;
	begin
		if (init_model = '1') then
		
				sysparam_time_simtime <= to_sfixed (0.0,6, -22);
		else
			if (step_once_complete'event and step_once_complete = '1' and init_model = '0') then
				sysparam_time_simtime <= resize(sysparam_time_simtime + sysparam_time_timestep,6, -22);
				write(L1, real'image(to_real( sysparam_time_simtime )));  -- nth value in row
				write(L1, " ");
				if (			neuron_model_eventport_out_spike_internal = '1') then
					write(L1, "1 " );
				else
					write(L1, "0 " );
				end if;

				write(L1, real'image(to_real(neuron_model_stateCURRENT_voltage_v_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_time_lastSpikeTime_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_conductance_SynapseModel_g_int)) );
				write(L1, " ");
		
				write(L1, real'image(to_real(neuron_model_stateCURRENT_current_SynapseModel_i_int)) );
				write(L1, " ");
		

				
				writeline(test_out_data, L1); -- write row to output file
			end if;
		end if;
	end process;

end tb;
