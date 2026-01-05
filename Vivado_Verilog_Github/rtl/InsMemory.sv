`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2025 10:40:34 PM
// Design Name: 
// Module Name: InsMemory
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
module InsMemory #(parameter length = 182 , width = 32 , N = 8)
    ( 
    input logic [width-1:0] addr,
    output logic [width-1:0] dataR 
     );
     
     logic [N-1:0] InsMem [0:length-1];
     
     
     initial
     begin
     $readmemh("IMdata.mem" , InsMem);
     end
     
     always_comb
     begin
       dataR = {InsMem[addr+3],InsMem[addr+2],InsMem[addr+1],InsMem[addr]};
     end
endmodule
