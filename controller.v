`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 10:44:26 AM
// Design Name: 
// Module Name: controller
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


module controller (
    input [2:0] opcode,
    input clk,
    input rst,
    input is_zero,
    output reg sel,
    rd,
    ld_ir,
    halt,
    inc_pc,
    ld_ac,
    ld_pc,
    wr,
    data_e
);
  parameter HLT = 3'b000;
  parameter SKZ = 3'b001;
  parameter ADD = 3'b010;
  parameter AND = 3'b011;
  parameter XOR = 3'b100;
  parameter LDA = 3'b101;
  parameter STO = 3'b110;
  parameter JMP = 3'b111;
  localparam INST_ADDR = 3'd0;
  localparam INST_FETCH = 3'd1;
  localparam INST_LOAD = 3'd2;
  localparam IDLE = 3'd3;
  localparam OP_ADDR = 3'd4;
  localparam OP_FETCH = 3'd5;
  localparam ALU_OP = 3'd6;
  localparam STORE = 3'd7;
  reg [2:0] state;
  always @(posedge clk) begin
    if (rst) begin
      state <= 3'd0;
    end else begin
      state <= state + 1;
    end
  end
  always @(*) begin
    sel = 0;
    rd = 0;
    ld_ir = 0;
    halt = 0;
    inc_pc = 0;
    ld_ac = 0;
    ld_pc = 0;
    wr = 0;
    data_e = 0;  //kh?i t?o m?c ??nh, tránh latch
    case (state)
      INST_ADDR: begin
        sel = 1;
      end
      INST_FETCH: begin
        sel = 1;
        rd  = 1;
      end
      INST_LOAD: begin
        sel = 1;
        rd = 1;
        ld_ir = 1;
      end
      IDLE: begin
        sel = 1;
        rd = 1;
        ld_ir = 1;
      end
      OP_ADDR: begin
        halt   = (opcode == HLT);
        inc_pc = 1;
      end

      OP_FETCH: begin
        if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
          rd = 1;
        end else begin
          rd = 0;
        end
      end
      ALU_OP: begin
        if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
          rd = 1;
        end else begin
          rd = 0;
        end
        inc_pc = (opcode == SKZ) && is_zero;
        ld_pc  = (opcode == JMP);
        data_e = (opcode == STO);
      end
      STORE: begin
        if (opcode == ADD || opcode == AND || opcode == XOR || opcode == LDA) begin
          rd = 1;
          ld_ac = 1;
        end else begin
          rd = 0;
          ld_ac = 0;
        end
        ld_pc = (opcode == JMP);
        wr = (opcode == STO);
        data_e = (opcode == STO);
      end

    endcase

  end
endmodule
