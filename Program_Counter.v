`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2026 05:32:36 PM
// Design Name: 
// Module Name: Program_Counter
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


module Program_Counter (
    input ld_pc,
    input inc_pc,
    input rst,
    input clk,
    input wire [31:0] data_pc,
    output reg [31:0] address_program
);
  always @(posedge clk) begin
    if (rst == 1'b1) begin
      address_program <= 32'b0;
    end else if (ld_pc == 1'b1) begin
      address_program <= data_pc;
    end else if (inc_pc == 1'b1) begin
      address_program <= address_program + 1'b1;
    end
  end
endmodule

