`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2025 11:36:31 PM
// Design Name: 
// Module Name: PC
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

module PC #(
    parameter WIDTH = 32
)(
    input  logic             clk,
    input  logic             reset,
    input  logic             enable,
    input  logic [WIDTH-1:0] pc_in,
    output logic [WIDTH-1:0] add   // your original name
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            add <= '0;
        else if (enable)
            add <= pc_in;
    end
endmodule

