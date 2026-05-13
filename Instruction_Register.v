`timescale 1ns / 1ps
module Instruction_Register(
 input wire clk,
 input wire rst,
 input wire ld_ir,
 input wire [31:0] instruction_data,
 output reg [2:0] opcode,
 output reg [31:0] address_instruction
    );
    always @(posedge clk) begin
     if(rst) begin
       opcode <= 3'b0;
       address_instruction <= 32'b0;
      end else if(ld_ir)begin 
        opcode <= instruction_data[31:29];
        address_instruction <= {27'b0, instruction_data[4:0]};
       end
    end
    
endmodule
