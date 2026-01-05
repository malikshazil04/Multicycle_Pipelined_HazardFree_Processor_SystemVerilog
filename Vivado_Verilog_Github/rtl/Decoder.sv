`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2025 01:43:20 AM
// Design Name: 
// Module Name: Decoder
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
module Decoder(
    input  logic [31:0] instruction,
    output logic [6:0]  opcode,
    output logic [4:0]  rdadd,
    output logic [2:0]  func3,
    output logic [4:0]  rsadd1,
    output logic [4:0]  rsadd2,
    output logic [6:0]  func7
);
    always_comb begin
        opcode  = instruction[6:0];
        rdadd   = instruction[11:7];
        func3   = instruction[14:12];
        rsadd1  = instruction[19:15];
        rsadd2  = instruction[24:20];
        func7   = instruction[31:25];
    end
endmodule
