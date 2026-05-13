`timescale 1ns /1ps


module Memory(
input wire clk,
input wire rd,
input wire wr,
 inout wire [31:0] data,
input wire [31:0] address
    );
    reg [31:0] mem [31:0];
    always @(posedge clk) begin
    if (wr==1'b1 && rd == 1'b0) begin
     mem[address[4:0]] <= data;
     end 
    end 
    assign data=(rd == 1'b1 && wr ==1'b0)? mem[address[4:0]]: 32'bz;
    
endmodule
