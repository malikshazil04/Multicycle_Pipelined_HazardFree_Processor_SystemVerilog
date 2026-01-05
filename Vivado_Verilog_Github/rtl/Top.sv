`timescale 1ns / 1ps
module Top#(
    parameter A       = 32,   
    parameter B       = 182,
    parameter E       = 32,  
    parameter D       = 8,
    parameter NUM_REG = 32,
    parameter G       = 5,
    parameter H       = 32,
    parameter I       = 7
)(
    input  logic clk,
    input  logic reset
);
    logic [A-1:0] pc_out , pc_in;
    logic [E-1:0] instruction;
    logic [G-1:0] rsadd1, rsadd2, rdadd;
    logic [I-1:0] opcode;
    logic [E-1:0] wdata, reg_result1, reg_result2;
    logic [E-1:0] alu_result, imm_res, memresult;
    logic [2:0]   func3;
    logic [6:0]   func7;
    logic [3:0]   op;
    logic         regWrite, aluSrc, memwrite, memread, memtoreg, branch;
    logic         zeroFlag, branch_taken;
    logic [1:0]   aluop;
    logic [A-1:0] add1 , add2 , shift;
    
    logic [63:0]  IF_ID_out;
    logic [154:0] ID_EX_out;   // expanded to include rs1/rs2 numbers
    logic [109:0] EX_MEM_out;
    logic [70:0]  MEM_WB_out;

    // Hazard / forwarding
    logic        PCWrite, PCWrite_final;
    logic        IF_ID_Write;
    logic        ID_EX_Flush_hazard;
    logic        ID_EX_Flush_total;
    logic [1:0]  forwardA, forwardB;

    // Control bus for bubble insertion
    logic [7:0] ctrl_ID;
    logic [7:0] ctrl_IDEX;

    logic       regWrite_IDEX, aluSrc_IDEX, memread_IDEX, memwrite_IDEX, memtoreg_IDEX, branch_IDEX;
    logic [1:0] aluop_IDEX;

    // -----------------------
    // PC & Fetch
    // -----------------------
    

    PC #(.WIDTH(A)) pc_inst (
        .clk   (clk),
        .reset (reset),
        .enable(1),
        .pc_in (pc_in),
        .add   (pc_out)
    );

    InsMemory #(B, E, D) insmemory_inst (
        .addr (pc_out),
        .dataR(instruction)
    );    

    // Flush IF/ID when branch taken
    PipelinedRegister_File #(64) IF_ID_reg (
        .clk   (clk),
        .reset (reset),
        .enable(IF_ID_Write),
        .flush (branch_taken),
        .in    ({pc_out, instruction}),
        .out   (IF_ID_out)
    );

    // -----------------------
    // Decode
    // -----------------------
    Decoder decoder_inst (
        .instruction(IF_ID_out[31:0]),
        .opcode     (opcode),
        .rdadd      (rdadd),
        .func3      (func3),
        .rsadd1     (rsadd1),
        .rsadd2     (rsadd2),
        .func7      (func7)
    ); 
    
    HazardDetectionUnit hdu (
        .ID_EX_memread(ID_EX_out[3]),      
        .ID_EX_rd     (ID_EX_out[12:8]),   
        .IF_ID_rs1    (rsadd1),
        .IF_ID_rs2    (rsadd2),
        .ID_branch    (branch),           
        .branch_taken (branch_taken),      
        .PCWrite      (PCWrite),
        .IF_ID_Write  (IF_ID_Write),
        .ID_EX_Flush  (ID_EX_Flush_hazard)
    ); 
    
    Reg_file #(E, NUM_REG, G) regfile_inst (
        .clk  (clk), 
        .we   (MEM_WB_out[0]), 
        .rs1  (rsadd1), 
        .rs2  (rsadd2), 
        .rsw  (MEM_WB_out[6:2]), 
        .dataw(wdata), 
        .data1(reg_result1), 
        .data2(reg_result2)
    );

    // Use latched instruction for ImmGen
    ImmGen imm_inst (
        .instr(IF_ID_out[31:0]),
        .imm  (imm_res)
    );

    control_unit cu_inst (
        .opcode   (opcode),
        .regwrite (regWrite),
        .alusrc   (aluSrc),
        .memread  (memread),
        .memwrite (memwrite),
        .memtoreg (memtoreg),
        .branch   (branch),
        .aluop    (aluop)
    ); 

    // -----------------------
    // ID -> EX pipeline
    // -----------------------
    // ctrl_ID = {aluop[1:0], regWrite, aluSrc, memread, memwrite, memtoreg, branch}
    assign ctrl_ID = {aluop, regWrite, aluSrc, memread, memwrite, memtoreg, branch};

    assign ID_EX_Flush_total = ID_EX_Flush_hazard | branch_taken;

    mux #(8) ctrl_mux (
        .ri (ctrl_ID),          
        .li (8'b0),             
        .sl (ID_EX_Flush_total),    
        .res(ctrl_IDEX)
    );

    assign aluop_IDEX    = ctrl_IDEX[7:6];
    assign regWrite_IDEX = ctrl_IDEX[5];
    assign aluSrc_IDEX   = ctrl_IDEX[4];
    assign memread_IDEX  = ctrl_IDEX[3];
    assign memwrite_IDEX = ctrl_IDEX[2];
    assign memtoreg_IDEX = ctrl_IDEX[1];
    assign branch_IDEX   = ctrl_IDEX[0];

    // ID_EX_out layout (MSB -> LSB):
    // [154:123] PC
    // [122:91]  rs1 value
    // [90:59]   rs2 value
    // [58:27]   imm
    // [26:24]   func3
    // [23]      func7[5]
    // [22:18]   rs1 index
    // [17:13]   rs2 index
    // [12:8]    rd index
    // [7:6]     aluop
    // [5]       regWrite
    // [4]       aluSrc
    // [3]       memread
    // [2]       memwrite
    // [1]       memtoreg
    // [0]       branch

    PipelinedRegister_File #(155) ID_EX_reg (
        .clk   (clk),
        .reset (reset),
        .enable(1'b1),
        .flush (ID_EX_Flush_total),
        .in    ({ IF_ID_out[63:32],     // PC
                  reg_result1,          // rs1 value
                  reg_result2,          // rs2 value
                  imm_res,              // immediate
                  func3,                // func3
                  func7[5],             // func7 bit 5
                  rsadd1,               // rs1 index
                  rsadd2,               // rs2 index
                  rdadd,                // rd index
                  aluop_IDEX,
                  regWrite_IDEX,
                  aluSrc_IDEX,
                  memread_IDEX,
                  memwrite_IDEX,
                  memtoreg_IDEX,
                  branch_IDEX
                }),
        .out   (ID_EX_out)
    );

    // -----------------------
    // EX stage
    // -----------------------
    alucontrol alu_ctrl_inst (
        .op (ID_EX_out[7:6]),
        .x  (ID_EX_out[26:24]),
        .y  (ID_EX_out[23]),
        .out(op)
    );

    // Forwarding unit uses EX-stage rs1/rs2
    ForwardingUnit fwd_unit (
        .ID_EX_rs1      (ID_EX_out[22:18]),
        .ID_EX_rs2      (ID_EX_out[17:13]),
        .EX_MEM_rd      (EX_MEM_out[10:6]),
        .MEM_WB_rd      (MEM_WB_out[6:2]),
        .EX_MEM_regWrite(EX_MEM_out[4]),
        .MEM_WB_regWrite(MEM_WB_out[0]),
        .forwardA       (forwardA),
        .forwardB       (forwardB)
    );

    // Base operands
    logic [E-1:0] alu_srcA_pre, alu_srcB_pre, alu_srcB_no_imm;
    logic [E-1:0] alu_srcA, alu_srcB;

    assign alu_srcA_pre   = ID_EX_out[122:91]; 
    assign alu_srcB_pre   = ID_EX_out[90:59];  

    // Select between rs2 and imm
    mux #(32) mux_inst (
        .ri (alu_srcB_pre),         
        .li (ID_EX_out[58:27]),     
        .sl (ID_EX_out[4]),         // aluSrc
        .res(alu_srcB_no_imm)
    );

    // Apply forwarding
    MUX_3x1 #(E) fwdA_mux (
        .a0 (alu_srcA_pre),
        .a1 (wdata),
        .a2 (EX_MEM_out[74:43]),
        .sel(forwardA),
        .y  (alu_srcA)
    );

    MUX_3x1 #(E) fwdB_mux (
        .a0 (alu_srcB_no_imm),
        .a1 (wdata),
        .a2 (EX_MEM_out[74:43]),
        .sel(forwardB),
        .y  (alu_srcB)
    );

    ALU #(H) alu_inst(
        .A       (alu_srcA),
        .B       (alu_srcB),
        .opcode  (op),
        .result  (alu_result),
        .zeroFlag(zeroFlag)
    );

    // Branch target: PC + (imm << 1)
    assign shift = ID_EX_out[58:27] << 1;
    assign add1  = pc_out + 4;
    assign add2  = ID_EX_out[154:123] + shift;

    // Branch decision in EX
    BranchingUnit bu(
        .branch      (ID_EX_out[0]),
        .func3       (ID_EX_out[26:24]),
        .zeroFlag    (zeroFlag),
        .alu_result_bit(alu_result[0]),
        .branch_taken(branch_taken)
    );

    // PC mux: next PC
    mux #(32) branch_mux (
        .ri (add1), 
        .li (add2), 
        .sl (branch_taken), 
        .res(pc_in)
    );       

    // -----------------------
    // EX -> MEM pipeline
    // -----------------------
    PipelinedRegister_File #(110) EX_MEM_reg (
        .clk   (clk),
        .reset (reset),
        .enable(1'b1),  
        .flush (1'b0),
        .in    ({ ID_EX_out[26:24],        // func3
                  add2,                    // branch target
                  alu_result,              // ALU result
                  ID_EX_out[90:59],        // rs2 data (store)
                  ID_EX_out[12:8],         // rd
                  zeroFlag,                // zero
                  ID_EX_out[5],            // regWrite
                  ID_EX_out[3],            // memread
                  ID_EX_out[2],            // memwrite
                  ID_EX_out[1],            // memtoreg
                  ID_EX_out[0]             // branch
                }),
        .out   (EX_MEM_out)
    );

    // -----------------------
    // MEM stage
    // -----------------------
    data_mem #(1024) datamem_inst (
        .clk      (clk),
        .mem_read (EX_MEM_out[3]),
        .mem_write(EX_MEM_out[2]),
        .funct3   (EX_MEM_out[109:107]),         
        .addr     (EX_MEM_out[74:43]),
        .dataW    (EX_MEM_out[42:11]),
        .dataR    (memresult)
    );   

    // -----------------------
    // MEM -> WB pipeline
    // -----------------------
    PipelinedRegister_File #(71) MEM_WB_reg (
        .clk   (clk),
        .reset (reset),
        .enable(1'b1),   
        .flush (1'b0),
        .in    ({ EX_MEM_out[74:43],   // ALU result
                  memresult,           // Load data
                  EX_MEM_out[10:6],    // rd
                  EX_MEM_out[1],       // memtoreg
                  EX_MEM_out[4]        // regWrite
                }),
        .out   (MEM_WB_out)
    );

    // -----------------------
    // Writeback
    // -----------------------
    mux #(32) wb_mux (
        .ri  (MEM_WB_out[70:39]), 
        .li  (MEM_WB_out[38:7]), 
        .sl  (MEM_WB_out[1]), 
        .res (wdata)
    );

endmodule
