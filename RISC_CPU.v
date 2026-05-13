`timescale 1ns / 1ps

module RISC_CPU (
    input clk,
    input rst
);

// ========== Wires ==========
wire [31:0] address_instruction; // IR -> Address_Mux, PC
wire [31:0] address_program;     // PC -> Address_Mux
wire [31:0] address;             // Address_Mux -> Memory
wire [31:0] alu_out;             // ALU -> ACC
wire [31:0] data_out;            // ACC -> ALU inA, drive bus data
wire [2:0]  opcode;              // IR -> Controller, ALU
wire        is_zero;             // ALU -> Controller

// Control signal
wire sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e;

// inout bus: Memory drive khi rd=1, ACC drive khi data_e=1
wire [31:0] data;

// ========== Program_Counter ==========
// Ports: ld_pc, inc_pc, rst, clk, data_pc[31:0], address_program[31:0]
Program_Counter u_pc (
    .clk             (clk),
    .rst             (rst),
    .ld_pc           (ld_pc),
    .inc_pc          (inc_pc),
    .data_pc         (address_instruction),
    .address_program (address_program)
);

// ========== address_mux ==========
// Ports: sel, address_instruction[31:0], address_program[31:0], address[31:0]
address_mux u_addr_mux (
    .sel                 (sel),
    .address_instruction (address_instruction),
    .address_program     (address_program),
    .address             (address)
);

// ========== Memory ==========
// Ports: clk, rd, wr, data[31:0] inout, address[31:0]
Memory u_memory (
    .clk     (clk),
    .rd      (rd),
    .wr      (wr),
    .data    (data),
    .address (address)
);

// ========== Instruction_Register ==========
// Ports: clk, rst, ld_ir, instruction_data[31:0], opcode[2:0], address_instruction[31:0]
Instruction_Register u_ir (
    .clk                 (clk),
    .rst                 (rst),
    .ld_ir               (ld_ir),
    .instruction_data    (data),
    .opcode              (opcode),
    .address_instruction (address_instruction)
);

// ========== ALU ==========
// Ports: inA[31:0], inB[31:0], opcode[2:0], alu_out[31:0], is_zero
ALU u_alu (
    .inA     (data_out),
    .inB     (data),
    .opcode  (opcode),
    .alu_out (alu_out),
    .is_zero (is_zero)
);

// ========== ACC ==========
// Ports: clk, rst, ld_ac, data_e, alu_out[31:0], data_out[31:0]
ACC u_acc (
    .clk      (clk),
    .rst      (rst),
    .ld_ac    (ld_ac),
    .data_e   (data_e),
    .alu_out  (alu_out),
    .data_out (data_out)
);

// ========== controller ==========
// Ports: opcode[2:0], clk, rst, is_zero,
//        sel, rd, ld_ir, halt, inc_pc, ld_ac, ld_pc, wr, data_e
controller u_controller (
    .clk     (clk),
    .rst     (rst),
    .opcode  (opcode),
    .is_zero (is_zero),
    .sel     (sel),
    .rd      (rd),
    .ld_ir   (ld_ir),
    .halt    (halt),
    .inc_pc  (inc_pc),
    .ld_ac   (ld_ac),
    .ld_pc   (ld_pc),
    .wr      (wr),
    .data_e  (data_e)
);

// ========== ACC drive bus data khi STORE (data_e=1) ==========
assign data = data_e ? data_out : 32'bz;

endmodule
