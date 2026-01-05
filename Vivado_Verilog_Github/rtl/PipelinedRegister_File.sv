`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2025 04:47:05 PM
// Design Name: 
// Module Name: PipelinedRegister_File
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
module PipelinedRegister_File #(
    parameter WIDTH = 32
)(
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic             flush,
    input  logic [WIDTH-1:0] in,
    output logic [WIDTH-1:0] out
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            out <= '0;
        else if (flush)
            out <= '0;
        else if (enable)
            out <= in;
    end
endmodule

