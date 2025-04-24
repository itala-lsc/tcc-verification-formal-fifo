//  Class: fifo_item
//
class fifo_item extends uvm_sequence_item;

    //Variáveis para o driver
	rand bit wr_en;
	rand bit rd_en;
	rand bit [15:0] din;

    //Variáveis para o monitor > Captura saída do fifo
    bit [15:0] dout;
	bit full;
	bit empty;

    // Utils
    `uvm_object_utils_begin(fifo_item)
        `uvm_field_int(wr_en, UVM_DEFAULT)
        `uvm_field_int(rd_en, UVM_DEFAULT)
        `uvm_field_int(din, UVM_DEFAULT)
        `uvm_field_int(dout, UVM_DEFAULT)
        `uvm_field_int(full, UVM_DEFAULT)
        `uvm_field_int(empty, UVM_DEFAULT)
    `uvm_object_utils_end

    // Construtor
    function new(string name = "fifo_item");
        super.new(name);
    endfunction: new
    
endclass: fifo_item
