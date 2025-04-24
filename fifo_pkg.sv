//  Package: fifo_pkg
//
`timescale 1ns / 1ps
package fifo_pkg;
    //  Group: UVM
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    //  Group: Includes
    // `include "fifo_if.sv"

    //  Objetcs
    `include "fifo_item.sv"
    `include "fifo_base_seq.sv"

    // Components
    `include "fifo_sequencer.sv"
    `include "fifo_driver.sv"
    `include "fifo_monitor.sv"

    `include "fifo_agent.sv"

    `include "fifo_scoreboard.sv"
    `include "fifo_cov_agent.sv"

    `include "fifo_env.sv"

    `include "fifo_base_test.sv" 

endpackage: fifo_pkg