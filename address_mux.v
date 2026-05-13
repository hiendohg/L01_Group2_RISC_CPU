`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/06/2026 10:29:41 PM
// Design Name: 
// Module Name: address_mux
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


module address_mux #(
    parameter WIDTH = 32
) (
    input sel,
    input wire [WIDTH-1:0] address_instruction,  //instruction register
    input wire [WIDTH-1:0] address_program,  //PC address
    output wire [WIDTH-1:0] address
);
  assign address = (sel == 1'b1) ? address_program : address_instruction;
endmodule
