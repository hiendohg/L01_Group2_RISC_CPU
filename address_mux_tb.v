`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 10:30:22 PM
// Design Name: 
// Module Name: address_mux_tb
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


module address_mux_tb ();
  parameter WIDTH_tb = 32;
  reg sel_tb;
  reg [WIDTH_tb-1:0] address_instruction_tb;  //instruction register
  reg [WIDTH_tb-1:0] address_program_tb;  //PC address
  wire [WIDTH_tb-1:0] address_tb;
  address_mux #(
      .WIDTH(WIDTH_tb)
  ) am (
      .sel(sel_tb),
      .address_instruction(address_instruction_tb),
      .address_program(address_program_tb),
      .address(address_tb)
  );
  initial begin
  $monitor("Time=%0t | sel=%b | addr_instr=%h, addr_pc=%h | address=%h",
            $time, sel_tb, address_instruction_tb, address_program_tb, address_tb);
    address_instruction_tb = 32'hAFFB_1610;
    address_program_tb = 32'hAACF_9010;
    sel_tb = 1'b0;
    #20 sel_tb = 1'b1;
    #20 sel_tb = 1'b0;
    address_instruction_tb = 16'hAB16;
    address_program_tb = 16'hA8F9;
    sel_tb = 1'b0;
    #20 sel_tb = 1'b1;
    #20 sel_tb=1'b0;
    #20 $finish;
  end

endmodule
