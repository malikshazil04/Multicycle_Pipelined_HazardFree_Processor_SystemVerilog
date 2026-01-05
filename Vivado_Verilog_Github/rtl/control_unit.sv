`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 02:40:59 PM
// Design Name: 
// Module Name: control_unit
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
module control_unit(
    input logic [6:0]opcode,
    output logic regwrite,
    output logic alusrc,
    output logic memread,
    output logic memwrite,
    output logic memtoreg,
    output logic branch,
    output logic [1:0] aluop
);
    always_comb
    begin
    regwrite = 1'b0;
    alusrc   = 1'b0;
    memread  = 1'b0;
    memwrite = 1'b0;
    memtoreg = 1'b0;
    branch   = 1'b0;
    aluop    = 2'b00;
    
    case(opcode)
      7'b0000011:  //lw
      begin 
    regwrite = 1'b1;
    alusrc   = 1'b1;
    memread  = 1'b1;
    memwrite = 1'b0;
    memtoreg = 1'b1;
    branch   = 1'b0;
    aluop    = 2'b00;
        end
      
      7'b0110011:
        begin 
    regwrite = 1'b1;
    alusrc   = 1'b0;
    memread  = 1'b0;
    memwrite = 1'b0;
    memtoreg = 1'b0;
    branch   = 1'b0;
    aluop    = 2'b10;
        end
      7'b0010011: 
        begin 
    regwrite = 1'b1;
    alusrc   = 1'b1;
    memread  = 1'b0;
    memwrite = 1'b0;
    memtoreg = 1'b0;
    branch   = 1'b0;
    aluop    = 2'b10;
        end 
      7'b0100011: 
        begin 
    regwrite = 1'b0;
    alusrc   = 1'b1;
    memread  = 1'b0;
    memwrite = 1'b1;
    memtoreg = 1'b0;
    branch   = 1'b0;
    aluop    = 2'b00;
        end
      7'b1100011:
        begin 
    regwrite = 1'b0;
    alusrc   = 1'b0;
    memread  = 1'b0;
    memwrite = 1'b0;
    memtoreg = 1'b0;
    branch   = 1'b1;
    aluop    = 2'b01;
        end 
        endcase
end
endmodule
