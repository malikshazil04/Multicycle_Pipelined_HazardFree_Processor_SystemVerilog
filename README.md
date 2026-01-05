(Multi-Cycle, Pipelined, Hazard-Free Processor)

# Multi-Cycle Pipelined Hazard-Free Processor – SystemVerilog

## 📌 Project Overview
This repository contains the implementation of a **Multi-Cycle, Pipelined Processor** designed using **SystemVerilog**.  
The processor follows a classical **multi-stage pipeline architecture** and incorporates **hazard handling mechanisms** to ensure correct execution without data or control conflicts.

This project builds upon single-cycle processor concepts and extends them to demonstrate **instruction-level parallelism**, **pipeline control**, and **hardware hazard resolution**, making it suitable for advanced studies in **computer architecture and RTL design**.

---

## 🎯 Key Features
- Multi-cycle instruction execution
- 5-stage pipelined architecture
- Data hazard handling using forwarding
- Load-use hazard detection and stalling
- Control hazard handling via pipeline flushing
- Modular and synthesizable RTL design
- Fully verified using testbenches in Vivado

---

## 🛠 Tools & Technologies
- **Language:** SystemVerilog  
- **Simulation:** Vivado Simulator  
- **Synthesis:** Xilinx Vivado  
- **Design Style:** RTL, pipelined datapath  

---

## 📂 Project Structure


Multi-Cycle-Pipelined-Processor/
│
├── rtl/
│ ├── top.sv
│ ├── pc.sv
│ ├── if_id_reg.sv
│ ├── id_ex_reg.sv
│ ├── ex_mem_reg.sv
│ ├── mem_wb_reg.sv
│ ├── instruction_memory.sv
│ ├── data_memory.sv
│ ├── reg_file.sv
│ ├── alu.sv
│ ├── alu_control.sv
│ ├── control_unit.sv
│ ├── imm_gen.sv
│ ├── forwarding_unit.sv
│ ├── hazard_detection_unit.sv
│ ├── branch_unit.sv
│ ├── mux.sv
│ └── adder.sv
│
├── tb/
│ └── processor_tb.sv
│
├── docs/
│ └── project_report.pdf
│
└── README.md


---

## 🧩 Processor Architecture

### 🔹 Pipeline Stages
The processor implements a classical **5-stage pipeline**:

1. **IF – Instruction Fetch**
2. **ID – Instruction Decode / Register Fetch**
3. **EX – Execute / Address Calculation**
4. **MEM – Memory Access**
5. **WB – Write Back**

Each stage operates in parallel on different instructions, improving throughput compared to single-cycle designs.

---

## 🧩 Module Description (Detailed)

### 🔹 Top Module (`top.sv`)
- Integrates all pipeline stages and control logic
- Coordinates pipeline registers, hazard units, and forwarding paths
- Acts as the main processor wrapper

---

### 🔹 Program Counter (`pc.sv`)
- Stores current instruction address
- Supports:
  - Sequential execution (`PC + 4`)
  - Branch target updates
  - Stall and flush control

---

### 🔹 Pipeline Registers
- **IF/ID (`if_id_reg.sv`)**
- **ID/EX (`id_ex_reg.sv`)**
- **EX/MEM (`ex_mem_reg.sv`)**
- **MEM/WB (`mem_wb_reg.sv`)**

Each pipeline register:
- Stores data and control signals between stages
- Supports stalling and flushing when hazards occur

---

### 🔹 Instruction Memory (`instruction_memory.sv`)
- Read-only memory
- Supplies instructions to IF stage

---

### 🔹 Control Unit (`control_unit.sv`)
- Decodes opcode and instruction fields
- Generates stage-specific control signals
- Works in coordination with hazard logic to suppress incorrect control flow

---

### 🔹 Register File (`reg_file.sv`)
- Two read ports, one write port
- Write-back occurs in WB stage
- Register zero remains constant (RISC-style)

---

### 🔹 Immediate Generator (`imm_gen.sv`)
- Extracts and sign-extends immediates
- Supports multiple instruction formats
- Feeds immediate values into EX stage

---

### 🔹 ALU (`alu.sv`)
- Performs arithmetic and logical operations
- Computes:
  - ALU results
  - Branch comparison results
  - Memory addresses

---

### 🔹 ALU Control (`alu_control.sv`)
- Decodes funct fields and ALUOp signals
- Selects correct ALU operation dynamically

---

### 🔹 Data Memory (`data_memory.sv`)
- Handles load and store instructions
- Accessed in MEM stage

---

### 🔹 Forwarding Unit (`forwarding_unit.sv`)
- Resolves **data hazards** by forwarding results from:
  - EX/MEM stage
  - MEM/WB stage
- Eliminates unnecessary stalls

---

### 🔹 Hazard Detection Unit (`hazard_detection_unit.sv`)
- Detects load-use hazards
- Inserts pipeline stalls when forwarding is insufficient
- Prevents incorrect operand usage

---

### 🔹 Branch Unit (`branch_unit.sv`)
- Evaluates branch conditions
- Controls pipeline flushing on taken branches
- Handles control hazards

---

### 🔹 Multiplexers & Adders
- Select between forwarded and original operands
- Compute PC updates and branch targets

---

## 🧪 Testbench (`processor_tb.sv`)
- Verifies correct pipeline behavior
- Tests:
  - Data forwarding
  - Load-use stalls
  - Branch flushing
- Validated using waveform inspection

---

## 🔁 Execution Flow (High-Level)
1. Instruction fetched into IF stage
2. Decoded in ID stage
3. Executed in EX stage
4. Memory accessed in MEM stage
5. Results written back in WB stage

➡️ Pipeline control logic ensures **hazard-free execution**.

---

## ⚠️ Design Notes
- Fully synchronous pipeline
- No structural hazards assumed
- Emphasis on correctness and clarity
- Suitable foundation for superscalar or out-of-order extensions

---

## 🚀 Possible Extensions
- Branch prediction
- Instruction cache / data cache
- Superscalar execution
- Out-of-order pipeline
- Formal verification

---

## 👤 Author
**Malik Shazil**  
Focus Areas:
- Computer Architecture  
- RTL Design  
- SystemVerilog  

---

## 📜 License
Educational use only.
