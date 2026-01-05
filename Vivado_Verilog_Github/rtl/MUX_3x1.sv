`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2025 02:44:09 PM
// Design Name: 
// Module Name: MUX_3x1
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
module MUX_3x1 #(parameter WIDTH = 32)(
    input  logic [WIDTH-1:0] a0,   // normal
    input  logic [WIDTH-1:0] a1,   // from MEM/WB (wdata)
    input  logic [WIDTH-1:0] a2,   // from EX/MEM (ALU result)
    input  logic [1:0]       sel,
    output logic [WIDTH-1:0] y
);
    always_comb begin
        case (sel)
            2'b00: y = a0;
            2'b01: y = a1;
            2'b10: y = a2;
            default: y = a0;
        endcase
    end
endmodule
