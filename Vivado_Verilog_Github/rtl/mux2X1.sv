`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/09/2025 04:21:49 PM
// Design Name: 
// Module Name: mux2X1
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


module mux #(parameter WIDTH = 32)(
    input  logic [WIDTH-1:0] ri,   // 0
    input  logic [WIDTH-1:0] li,   // 1
    input  logic             sl,
    output logic [WIDTH-1:0] res
);
    assign res = sl ? li : ri;
endmodule
