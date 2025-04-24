//  Class: fifo_base_test
//
class fifo_base_test extends uvm_test;
	`uvm_component_utils(fifo_base_test)

  	//  Group: Components
	fifo_env env;
	
	//  Group: Variables
    virtual fifo_if vif;

    //  Group: Functions
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		`uvm_info("TEST_BUILD", $sformatf("Starting build_phase for %s",
              get_full_name()), UVM_NONE)

		// Configuração dos agentes
		uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt*", "is_active", UVM_ACTIVE); 
		uvm_config_db#(uvm_active_passive_enum)::set(this, "env.agt_passive", "is_active", UVM_PASSIVE);

		// Criação do ambiente
		env = fifo_env::type_id::create("env", this);

		// Configuração da interface
		if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
		`uvm_fatal("NO_VIF", "interface not found")
  
	  	uvm_config_db#(virtual fifo_if)::set(this, "env.agt*", "vif", vif);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("TEST_CONNECT", "Connecting test components", UVM_MEDIUM)
	endfunction: connect_phase
	
	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction : end_of_elaboration_phase
  
	task run_phase(uvm_phase phase);
		fifo_base_seq seq = fifo_base_seq::type_id::create("seq");

		phase.raise_objection(this);
		`uvm_info("TEST_RUN", "Starting test sequence", UVM_MEDIUM)
		if (!seq.randomize())
			`uvm_fatal("SEQ_RAND", "Sequence randomization failure")
	  
		seq.start(env.agt_active.sequencer);
  
  		#100; // Tempo adicional para conclusão
  		phase.drop_objection(this);
	endtask: run_phase

  //  Constructor: new
	function new(string name = "fifo_base_test", uvm_component parent);
		super.new(name, parent);
	endfunction
endclass