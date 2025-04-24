// Class: fifo_driver
//
class fifo_driver extends uvm_driver #(fifo_item);
	`uvm_component_utils(fifo_driver)
  
	//  Group: Components
	virtual fifo_if vif;
  
	//  Group: Functions
	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);
	  `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s",
	  			get_full_name()), UVM_NONE)

	  if (!uvm_config_db#(virtual fifo_if)::get(this, "", "vif", vif))
      `uvm_fatal("DRV_IF", $sformatf("Error to get vif for %s", get_full_name()))

    `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s",
              get_full_name()), UVM_NONE)
  	endfunction: build_phase
  
	task run_phase(uvm_phase phase);
		super.run_phase(phase);

		forever begin
			seq_item_port.get_next_item(req);

			drive_item(req);

			seq_item_port.item_done();
	end
	endtask: run_phase

	task drive_item(fifo_item req);
		// Verificação de condições
        if(req.wr_en && vif.full) begin
            `uvm_error("DRV_ERR", "Write attempt on full FIFO")
            return;
        end
        
        if(req.rd_en && vif.empty) begin
            `uvm_error("DRV_ERR", "Read attempt on empty FIFO")
            return;
        end
        
        // Operação de drive
		vif.wr_en <= req.wr_en;
		vif.rd_en <= req.rd_en;
		vif.din   <= req.din;

		@ (posedge vif.clk);

		 // Reset dos sinais de controle
        vif.wr_en <= 0;
        vif.rd_en <= 0;
	endtask: drive_item

	// Constructor: new
	function new(string name = "fifo_driver", uvm_component parent);
		super.new(name, parent);
	endfunction
	
endclass: fifo_driver