// Class fifo_assertions
//
// `include "uvm_macros.svh"
// import uvm_pkg::*;
//

module fifo_assertions #(parameter DEPTH=8, DWIDTH=16) (
  fifo_if #(DWIDTH) intf
  );

  //Não escrever quando o FIFO estiver cheio
  property write_only_when_not_full;
    @(posedge intf.clk) disable iff (!intf.rstn)
    intf.wr_en |-> !intf.full;
  endproperty
  ap_write_only_when_not_full: assert property (write_only_when_not_full);

  //Não ler quando o FIFO estiver vazio
  property read_only_when_not_empty;
    @(posedge intf.clk) disable iff (!intf.rstn)
    intf.rd_en |-> !intf.empty;
  endproperty
  ap_read_only_when_not_empty: assert property (read_only_when_not_empty);

endmodule