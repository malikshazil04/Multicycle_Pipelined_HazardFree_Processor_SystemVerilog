`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 04:29:03 PM
// Design Name: 
// Module Name: topControl
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



module top_control_alu(
    input  logic [6:0] opcode,   
    input  logic [2:0] funct3,  
    input  logic  funct7,   
    output logic [3:0] alu_ctrl, 
    output logic       regwrite,
    output logic       alusrc,
    output logic       memread,
    output logic       memwrite,
    output logic       memtoreg,
    output logic       branch
);

   
    logic [1:0] aluop;

    control_unit CU (
        .opcode(opcode),
        .regwrite(regwrite),
        .alusrc(alusrc),
        .memread(memread),
        .memwrite(memwrite),
        .memtoreg(memtoreg),
        .branch(branch),
        .aluop(aluop)
    );

    alucontrol ALUCTRL (
        .op(aluop),
        .x(funct3),
        .y(funct7),
        .out(alu_ctrl)
    );

endmodule

