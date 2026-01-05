`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2025 03:15:41 PM
// Design Name: 
// Module Name: HazardDetectionUnit
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
`timescale 1ns / 1ps

module HazardDetectionUnit(
    input  logic       ID_EX_memread,      
    input  logic [4:0] ID_EX_rd,          
    input  logic [4:0] IF_ID_rs1,         
    input  logic [4:0] IF_ID_rs2,
    input  logic       ID_branch,
    input  logic       branch_taken,
    output logic       PCWrite,
    output logic       IF_ID_Write,
    output logic       ID_EX_Flush
);
    always_comb begin
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        ID_EX_Flush = 1'b0;

        if (ID_EX_memread &&
            (ID_EX_rd != 5'd0) &&
            ((ID_EX_rd == IF_ID_rs1) || (ID_EX_rd == IF_ID_rs2))) begin
            PCWrite     = 1'b0;
            IF_ID_Write = 1'b0;
            ID_EX_Flush = 1'b1;
        end
        else if (ID_branch && branch_taken) begin
            IF_ID_Write = 1'b0;
            ID_EX_Flush = 1'b1;
        end
    end
endmodule

