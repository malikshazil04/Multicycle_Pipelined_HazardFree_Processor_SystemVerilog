`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/18/2025 02:47:45 PM
// Design Name: 
// Module Name: ALU
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
module ALU #(
    parameter WIDTH = 32
)(
    input  logic [WIDTH-1:0] A,
    input  logic [WIDTH-1:0] B,
    input  logic [3:0] opcode,   
    output logic [WIDTH-1:0] result,
    output logic zeroFlag
);
    always_comb begin
        case(opcode)
            4'b0000: result = A + B;                   // ADD
            4'b0001: result = A - B;                   // SUB
            4'b0010: result = A & B;                   // AND
            4'b0011: result = A | B;                   // OR
            4'b0100: result = A ^ B;                   // XOR
            4'b0101: result = ($signed(A) < $signed(B)) ? 32'd1 : 32'd0; // SLT
            4'b0110: result = (A < B) ? 32'd1 : 32'd0;                     // SLTU
            4'b0111: result = A << B[4:0];             // SLL
            4'b1000: result = A >> B[4:0];             // SRL
            4'b1001: result = $signed(A) >>> B[4:0];   // SRA

            // New operations added without changing existing sequence
            4'b1010: result = A + B;                   // ADDI (immediate handled as B)
            4'b1011: result = A * B;                   // MULT
            4'b1100: result = A / B;                   // DIV
            4'b1101: result = ~(A | B);                // NOR / XNOR
            4'b1110: result = A << B[4:0];             // SLLI (immediate variant)
            4'b1111: result = A >> B[4:0];             // SRLI (immediate variant)
            // BNE and BEQ can use existing SUB and zeroFlag logic
            default: result = 32'd0;
        endcase
    end
    assign zeroFlag = (result == 32'b0);
endmodule


