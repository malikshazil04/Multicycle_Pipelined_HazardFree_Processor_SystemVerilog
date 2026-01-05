`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/11/2025 03:26:05 PM
// Design Name: 
// Module Name: ForwardingUnit
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
module ForwardingUnit(
    input  logic [4:0] ID_EX_rs1,        
    input  logic [4:0] ID_EX_rs2,        
    input  logic [4:0] EX_MEM_rd,        
    input  logic [4:0] MEM_WB_rd,        
    input  logic       EX_MEM_regWrite,
    input  logic       MEM_WB_regWrite,
    output logic [1:0] forwardA,
    output logic [1:0] forwardB
);
    always_comb begin
        forwardA = 2'b00;
        forwardB = 2'b00;

        if (EX_MEM_regWrite && (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == ID_EX_rs1))
            forwardA = 2'b10;

        if (EX_MEM_regWrite && (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == ID_EX_rs2))
            forwardB = 2'b10;


        if (MEM_WB_regWrite && (MEM_WB_rd != 5'd0) &&
            !(EX_MEM_regWrite && (EX_MEM_rd != 5'd0) &&
              (EX_MEM_rd == ID_EX_rs1)) &&
            (MEM_WB_rd == ID_EX_rs1))
            forwardA = 2'b01;

        if (MEM_WB_regWrite && (MEM_WB_rd != 5'd0) &&
            !(EX_MEM_regWrite && (EX_MEM_rd != 5'd0) &&
              (EX_MEM_rd == ID_EX_rs2)) &&
            (MEM_WB_rd == ID_EX_rs2))
            forwardB = 2'b01;
    end
endmodule

