//  Class: fifo_cov_agent
//
class fifo_cov_agent extends uvm_component;
	`uvm_component_utils(fifo_cov_agent)

  	//  Group: Analysis Ports
	`uvm_analysis_imp_decl(_active)
	`uvm_analysis_imp_decl(_passive)
  
	uvm_analysis_imp_active #(fifo_item, fifo_cov_agent) imp_active;
	uvm_analysis_imp_passive #(fifo_item, fifo_cov_agent) imp_passive;
  
 
	// 1. Declaração do covergroup
	covergroup fifo_cg with function sample (fifo_item item);
	  option.per_instance = 1;
	  option.name = "fifo_coverage";

	//Operações
	wr_cp: coverpoint item.wr_en {
		bins write = {1};
		bins no_write = {0};
	}
  
	rd_cp: coverpoint item.rd_en {
		bins read = {1};
		bins no_read = {0};
	}
	  
	// Estados
	status_cp: coverpoint {item.full, item.empty} {
		bins empty = {2'b00};
		bins normal = {2'b01};
		bins full = {2'b10};
		illegal_bins invalid = {2'b11}; // Nunca deve estar full e empty juntos
	}

	// Dados para 16 bits
	  data_in_cp: coverpoint item.din {
		bins zero = {0};
		bins low  = {[1:100]};
		bins high = {[65535-100:65535]};
		bins others = default;
	}
  
	// Cruzamentos importantes
		wr_x_rd: cross wr_cp, rd_cp;
		op_x_status: cross wr_cp, rd_cp, status_cp;
	endgroup: fifo_cg
    
	// Criação do covergroup no build_phase
	function void build_phase(uvm_phase phase);
	  super.build_phase(phase);

	  imp_active = new("imp_active", this);
	  imp_passive = new("imp_passive", this);
	endfunction: build_phase

	function void write_active(fifo_item item);
        sample_item(item, "ACTIVE");
	endfunction: write_active
    
    function void write_passive(fifo_item item);
        sample_item(item, "PASSIVE");
	endfunction: write_passive

	// Metodo para tratamento de itens
    protected function void sample_item(fifo_item item, string prefix);
        `uvm_info("COV_AGT", 
                 $sformatf("[%s] Item %0d: wr=%b, rd=%b, din=%h, full=%b, empty=%b",
                 prefix, item.get_inst_id(), 
                 item.wr_en, item.rd_en, item.din, item.full, item.empty),
                 UVM_HIGH)
        fifo_cg.sample(item);
	endfunction: sample_item

  	//  Constructor: new
	function new(string name = "fifo_cov_agent", uvm_component parent = null);
		super.new(name, parent);
		fifo_cg = new();
	endfunction: new

	function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("COV_REPORT", $sformatf("Coverage: %.2f%%", fifo_cg.get_coverage()), UVM_MEDIUM)
	endfunction: report_phase
	
  endclass: fifo_cov_agent