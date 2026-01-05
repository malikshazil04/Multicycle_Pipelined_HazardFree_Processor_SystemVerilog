`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 03:13:18 PM
// Design Name: 
// Module Name: dataMem
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
module data_mem #(
    parameter DEPTH = 1024
)(
    input  logic        clk,
    input  logic        mem_read,
    input  logic        mem_write,
    input  logic [2:0]  funct3,
    input  logic [31:0] addr,
    input  logic [31:0] dataW,
    output logic [31:0] dataR
);

    logic [7:0] mem [0:DEPTH-1];

    initial begin
        $readmemh("DataMemory.mem", mem);
    end

    logic [31:0] word;
    logic [31:0] write_word;
    logic [31:0] result;

    always_comb begin
        word = { mem[addr+3], mem[addr+2], mem[addr+1], mem[addr] };

        case(funct3)
            3'b000: result = {{24{mem[addr][7]}}, mem[addr]};                  
            3'b100: result = {24'b0, mem[addr]};                               

            3'b001: result = {{16{word[15]}}, word[15:0]};                     
            3'b101: result = {16'b0, word[15:0]};                              

            3'b010: result = word;                                             

            default: result = 32'h0;
        endcase

        if(mem_read)
            dataR = result;
        else
            dataR = 32'h0;
    end

    always_ff @(posedge clk) 
    begin
        if(mem_write)
         begin
            case(funct3)
                3'b000: mem[addr] <= dataW[7:0];                                

                3'b001: begin                                                    
                    mem[addr]   <= dataW[7:0];
                    mem[addr+1] <= dataW[15:8];
                end

                3'b010: begin                                                    
                    mem[addr]   <= dataW[7:0];
                    mem[addr+1] <= dataW[15:8];
                    mem[addr+2] <= dataW[23:16];
                    mem[addr+3] <= dataW[31:24];
                end
            endcase
        end
    end

    final begin
        $writememh("DataMemory.mem", mem);
    end

endmodule

