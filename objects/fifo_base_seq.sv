//  Class: fifo_base_seq
//
class fifo_base_seq extends uvm_sequence #(fifo_item);
  
    //  Group: Variables
    rand int num_samples = 10; //Tornado rand para permitir randomização

    //  Group: Constraints
    constraint valid_num_samples {
      num_samples inside {[1:100]}; // Limite razoável para evitar loops infinitos
    }
  
    //  Group: Functions
    `uvm_object_utils(fifo_base_seq)
    
    // Task: body
    task body();
      fifo_item m_item;

      `uvm_info(get_type_name(), $sformatf("Starting sequence with %0d items",
                                          num_samples), UVM_MEDIUM)

      repeat(num_samples) begin
        m_item = fifo_item::type_id::create("m_item");

        start_item(m_item);
        if (!m_item.randomize() with {
          wr_en != rd_en; 
        }) begin
          `uvm_fatal("SEQ_RAND", $sformatf("Unable to randomize for %s",
                    get_full_name()))
        end
        finish_item(m_item);

        `uvm_info(get_type_name(), $sformatf("Item %0d sent: %s", 
                  num_samples, m_item.convert2string()), UVM_HIGH)        
      end
    endtask : body
  
    //  Constructor: new
    function new(string name = "fifo_base_seq");
      super.new(name);
    endfunction: new
  
  endclass: fifo_base_seq
  
  
  
  