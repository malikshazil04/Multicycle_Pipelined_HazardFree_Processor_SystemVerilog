`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 03:13:42 PM
// Design Name: 
// Module Name: Reg_file
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Reg_file#(
    parameter DATA_WIDTH = 32,   
    parameter NUM_REGS   = 32,
    parameter e =5
)( 
    input logic clk,
    input logic we,
    input logic [e-1:0]rs1,
    input logic [e-1:0]rs2,
    input logic [e-1:0]rsw,
    input logic [DATA_WIDTH-1:0]dataw,
    output logic [DATA_WIDTH-1:0]data1,
    output logic [DATA_WIDTH-1:0]data2
);
    logic [DATA_WIDTH-1:0] regfile [0:NUM_REGS-1];
   initial 
   begin
   $readmemh("rfdata.mem" , regfile);
   end
     
   always_ff@(posedge clk)
   begin
   if(we && rsw !=0)
     begin
        regfile[rsw] <= dataw;
     end
   end

   assign data1 = regfile[rs1];
   assign data2 = regfile[rs2];
  endmodule
