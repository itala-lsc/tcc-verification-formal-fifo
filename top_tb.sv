// Module top_tb
//
`timescale 1ns / 1ps
`include "uvm_macros.svh"

module top_tb;

    parameter DWIDTH = 8;    // Largura de dados
    parameter DEPTH = 16;    // Profundidade da FIFO

    // Inclusão da interface
    import uvm_pkg::*;
    import fifo_pkg::*;

    // Sinais de clock e reset
    reg clk;
    reg rstn;

    // Interface física conectada ao DUT
    fifo_if dut_if (clk, rstn);

    // Instância do DUT
    sync_fifo #(
        .DWIDTH (DWIDTH),
        .DEPTH  (DEPTH)
    ) dut (
        .clk    (dut_if.clk),
        .rstn   (dut_if.rstn),
        .wr_en  (dut_if.wr_en),
        .rd_en  (dut_if.rd_en),
        .din    (dut_if.din),
        .dout   (dut_if.dout),
        .empty  (dut_if.empty),
        .full   (dut_if.full)
    );
    
    initial begin
        clk = 1'b0;
    end

endmodule: top_tb
