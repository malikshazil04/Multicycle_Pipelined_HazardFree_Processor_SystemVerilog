`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/16/2025 03:48:31 PM
// Design Name: 
// Module Name: alucontrol
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
module alucontrol(
    input  logic [1:0] op,   
    input  logic [2:0] x,      
    input  logic       y,      
    output logic [3:0] out     
);

always_comb begin
    case(op)
        2'b00: out = 4'b0000; 
        2'b01: out = 4'b0001; 
        2'b10: begin         
            case(x)          
                3'b000: out = y ? 4'b0001 : 4'b0000; 
                3'b010: out = 4'b0101;              
                3'b011: out = 4'b0110;            
                3'b100: out = 4'b0100;              
                3'b110: out = 4'b0011;              
                3'b111: out = 4'b0010;              
                3'b001: out = 4'b0111;              
                3'b101: out = y ? 4'b1001 : 4'b1000; 
                default: out = 4'b0000;
            endcase
        end
        default: out = 4'b0000;
    endcase
end

endmodule
