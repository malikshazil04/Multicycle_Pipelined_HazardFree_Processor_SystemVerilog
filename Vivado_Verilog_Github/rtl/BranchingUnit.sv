`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2025 07:13:25 PM
// Design Name: 
// Module Name: BranchingUnit
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


module BranchingUnit(
    input  logic       branch,
    input  logic [2:0] func3,
    input  logic       zeroFlag,
    input  logic       alu_result_bit,   // not really used except placeholder
    output logic       branch_taken
);
    always_comb begin
        branch_taken = 1'b0;
        if (branch) begin
            unique case (func3)
                3'b000: branch_taken =  zeroFlag;   // BEQ
                3'b001: branch_taken = !zeroFlag;   // BNE
                default: branch_taken = 1'b0;       // others not implemented
            endcase
        end
    end
endmodule
