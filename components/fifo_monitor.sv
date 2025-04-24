//  Class: fifo_monitor
//
class fifo_monitor extends uvm_monitor;
	`uvm_component_utils(fifo_monitor)

	//  Group: Components
	virtual fifo_if vif;

	// Group: Variables
	uvm_analysis_port #(fifo_item) mon_analysis_port;

	uvm_active_passive_enum is_active;

  	//  Group: Functions
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("MON_BUILD", $sformatf("Starting build_phase for %s",
				  get_full_name()), UVM_NONE)
	
		if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
		  `uvm_fatal("MON_BUILD", $sformatf("Error to get vif for %s", get_full_name))
	
		if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active))
		  `uvm_fatal("MON_BUILD", $sformatf("Error to get is_active for %s", get_full_name))
	
		mon_analysis_port = new("mon_analysis_port", this);
	
		`uvm_info("MON_BUILD", $sformatf("Finishing build_phase for %s",
				  get_full_name()), UVM_NONE)
	  endfunction: build_phase
	
	
	  task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		if (is_active == UVM_ACTIVE)
		  monitor_inputs();
		else
		  monitor_outputs();
	  endtask : run_phase

	  task monitor_inputs();
		fifo_item item = fifo_item::type_id::create("item");

		forever begin
			@ (posedge vif.clk);

			item.wr_en = vif.wr_en;
			item.rd_en = vif.rd_en;
			item.din = vif.din;

			`uvm_info("MON_ACTIVE", "Monitor captured INPUT item.", UVM_MEDIUM)
        	`uvm_info("MON_ACTIVE", $sformatf("%s", item.sprint()), UVM_FULL)

        	mon_analysis_port.write(item);
		end
	  endtask: monitor_inputs

	  task monitor_outputs();
		fifo_item item = fifo_item::type_id::create("fifo_out_tr");
		forever begin
			@ (posedge vif.clk);

			item.dout = vif.dout;
			item.full = vif.full;
			item.empty = vif.empty;

			`uvm_info("MON_PASSIVE", "Monitor captured OUTPUT item.", UVM_MEDIUM)
        	`uvm_info("MON_PASSIVE", $sformatf("%s", item.sprint()), UVM_FULL)

        	mon_analysis_port.write(item);
		end
	  endtask: monitor_outputs

  	//  Constructor: new
	function new(string name = "fifo_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction

endclass: fifo_monitor