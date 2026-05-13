`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2026 05:54:46 PM
// Design Name: 
// Module Name: ACC
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


module ACC(
    input              clk,
    input              rst,
    input              ld_ac,
    input              data_e,
    input       [31:0] alu_out,
    output reg  [31:0] data_out   // lưu giá trị ACC
    
);

    always @(posedge clk) begin
        if (rst)
            data_out <= 32'b0;
        else if (ld_ac)
            data_out <= alu_out;
    end
    
endmodule
