`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/25/2025 09:41:06 PM
// Design Name: 
// Module Name: BranchUnit
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
module BranchUnit(
    input  logic     branch,
    input  logic [2:0] func3,
    input  logic       zeroFlag,
    input  logic      alu_result,
    output logic       branch_taken
);
    always_comb begin
    branch_taken = 0;
    if (branch) begin
        case(func3)
            3'b000: if (zeroFlag) branch_taken = 1;     
            3'b001: if (!zeroFlag) branch_taken = 1;     
            3'b100: if (alu_result == 1) branch_taken = 1; 
            3'b101: if (alu_result == 0) branch_taken = 1; 
            3'b110: if (alu_result == 1) branch_taken = 1; 
            3'b111: if (alu_result == 0) branch_taken = 1; 
        endcase
    end
    end

endmodule

