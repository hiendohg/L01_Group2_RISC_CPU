`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/05/2026 05:33:21 PM
// Design Name: 
// Module Name: Program_Counter_tb
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
`timescale 1ns / 1ps
module Program_Counter_tb ();
  reg ld_pc_tb;
  reg inc_pc_tb;
  reg rst_tb;
  reg clk_tb;
  reg [31:0] data_pc_tb;
  wire [31:0] address_program_tb;
  Program_Counter T (
      ld_pc_tb,
      inc_pc_tb,
      rst_tb,
      clk_tb,
      data_pc_tb,
      address_program_tb
  );
  always #10 clk_tb = ~clk_tb;  //chu kì 20ns
  initial begin
  $monitor("Time=%0t | ld_pc=%b, inc_pc=%b, rst=%b, data=%0d | address=%0d", $time, ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb, address_program_tb); 
    clk_tb = 1'b0;
    {ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb} = {
      1'b0, 1'b0, 1'b0, 32'b0
    };  //kh?i t?o tr?ng thái ban ??u 
    #15{ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb} = {1'b1, 1'b0, 1'b1, 32'b1101};  //reset
    #20{ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb} = {1'b1, 1'b0, 1'b0, 32'b1101};  //load
    #20{ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb} = {1'b1, 1'b1, 1'b0, 32'b1101};  //load, count
    #20{ld_pc_tb, inc_pc_tb, rst_tb, data_pc_tb} = {1'b0, 1'b1, 1'b0, 32'b1101};  //count
    #25;
    $finish;
  end
endmodule
