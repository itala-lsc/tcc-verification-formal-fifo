// Class fifo_sequencer
//
class fifo_sequencer extends uvm_sequencer #(fifo_item);
	`uvm_component_utils(fifo_sequencer)
	
	//  Group: Components


  	//  Group: Variables


  	//  Group: Functions

  	//  Constructor: new
  	function new(string name = "fifo_sequencer", uvm_component parent);
	  super.new(name, parent);
	endfunction

endclass: fifo_sequencer