//Class fifo_if
//
`timescale 1ns / 1ps
`ifndef fifo_if__sv
`define fo_if__sv

//Definição da interface física para conexão com o DUT
interface fifo_if #(parameter DWIDTH = 16) (input logic clk, input logic rstn);
	
	//Inputs
	logic wr_en;
	logic rd_en;
	logic [DWIDTH-1:0] din;

	//Outputs
	logic [DWIDTH-1:0] dout;
	logic empty;
	logic full;

endinterface: fifo_if

`endif
