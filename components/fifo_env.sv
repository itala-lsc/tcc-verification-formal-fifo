//Class fifo_env
//
class fifo_env extends uvm_env;
	`uvm_component_utils(fifo_env)
  
	//  Group: Components
	fifo_agent agt_active; // Agente para operações ativas
	fifo_agent agt_passive; // Agente para monitoramento passivo
	fifo_cov_agent cov_agent; // Agente de cobertura
	fifo_scoreboard scbd; //Scoreboard para verificação
	
  	//  Group: Variables

  	//  Group: Functions
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("ENV_BUILD", "Building FIFO test environment", UVM_MEDIUM)
		
		//Cria componentes
		agt_active = fifo_agent::type_id::create ("agt_active", this);
		agt_passive = fifo_agent::type_id::create("agt_passive", this);
		
	 	cov_agent = fifo_cov_agent::type_id::create("cov_agent", this);

		scbd = fifo_scoreboard::type_id::create("scbd", this);
		
		// Configura agentes
        uvm_config_db#(uvm_active_passive_enum)::set(this, "agt_passive", 
                                                   "is_active", UVM_PASSIVE);
	endfunction: build_phase
		
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);

		`uvm_info("ENV_CONNECT", "Connecting FIFO environment components", UVM_MEDIUM)

		// Conexão do agente ativo
		agt_active.monitor.mon_analysis_port.connect(cov_agent.imp_active);
		agt_active.monitor.mon_analysis_port.connect(scbd.item_export);

		// Conexão do agente passivo
		agt_passive.monitor.mon_analysis_port.connect(cov_agent.imp_passive);
		agt_passive.monitor.mon_analysis_port.connect(scbd.item_export);

		// Conexão do driver ao sequencer
		agt_active.driver.seq_item_port.connect(agt_active.sequencer.seq_item_export);
	endfunction: connect_phase
	
	
  	//  Constructor: new
	function new(string name = "fifo_env", uvm_component parent);
		super.new(name, parent);
	  endfunction: new

endclass: fifo_env