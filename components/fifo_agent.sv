// Class fifo_agent
//
class fifo_agent extends uvm_agent;
	`uvm_component_utils(fifo_agent)

	// Group: Components
	fifo_sequencer sequencer;
	fifo_driver driver;
	fifo_monitor monitor;

	// Group: Variables
	uvm_active_passive_enum is_active;
	
	//  Group: Functions
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("AGT_BUILD", $sformatf("Starting build_phase for %s",
				  get_full_name()), UVM_NONE)
	
		if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
		`uvm_fatal("AGT_BUILD", $sformatf("Error to get is_active for %s", get_full_name))
	
		if (is_active == UVM_ACTIVE) begin
		  driver   = fifo_driver::type_id::create("driver" , this);
		  sequencer  = fifo_sequencer::type_id::create("sequencer", this);
		end
	
		monitor   = fifo_monitor::type_id::create("monitor" , this);
	
		`uvm_info("AGT_BUILD", $sformatf("Finishing build_phase for %s",
				  get_full_name()), UVM_NONE)
	  endfunction: build_phase
	
	
	  function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("AGT_CONNECT", $sformatf("Starting connect_phase for %s",
				  get_full_name()), UVM_NONE)
	
		if (is_active == UVM_ACTIVE)
		  monitor.mo_analysis_port.connect(sequencer.seq_item_export);
	
		`uvm_info("AGT_CONNECT", $sformatf("Finishing connect_phase for %s",
				  get_full_name()), UVM_NONE)
	  endfunction: connect_phase
		
	  //  Constructor: new
	  function new(string name = "fifo_agent", uvm_component parent);
		super.new(name, parent);
	  endfunction: new
endclass: fifo_agent