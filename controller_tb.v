`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/10/2026 10:44:52 AM
// Design Name: 
// Module Name: controller_tb
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

module controller_tb();
    reg [2:0] opcode_tb;
    reg clk_tb, rst_tb, is_zero_tb;
    wire sel_tb, rd_tb, ld_ir_tb, halt_tb;
    wire inc_pc_tb, ld_ac_tb, ld_pc_tb, wr_tb, data_e_tb;

    controller dut (
        .clk(clk_tb), .rst(rst_tb), .is_zero(is_zero_tb),
        .sel(sel_tb), .rd(rd_tb), .ld_ir(ld_ir_tb), .halt(halt_tb),
        .inc_pc(inc_pc_tb), .ld_ac(ld_ac_tb), .ld_pc(ld_pc_tb),
        .opcode(opcode_tb), .wr(wr_tb), .data_e(data_e_tb)
    );

    always #5 clk_tb = ~clk_tb;

    initial begin
    $monitor("Time=%0t | clk=%b rst=%b opcode=%b is_zero=%b | sel=%b rd=%b ld_ir=%b halt=%b inc_pc=%b ld_ac=%b ld_pc=%b wr=%b data_e=%b",
          $time, clk_tb, rst_tb, opcode_tb, is_zero_tb,
          sel_tb, rd_tb, ld_ir_tb, halt_tb, inc_pc_tb, ld_ac_tb, ld_pc_tb, wr_tb, data_e_tb);
        clk_tb     = 0;
        rst_tb     = 1;  // reset mức cao
        opcode_tb  = 3'b000;
        is_zero_tb = 0;

        repeat(2) @(posedge clk_tb);
        rst_tb = 0;      // thả reset, bắt đầu chạy

        // HLT
        opcode_tb = 3'b000;
        repeat(8) @(posedge clk_tb);

        // SKZ, is_zero=0
        opcode_tb = 3'b001; is_zero_tb = 0;
        repeat(8) @(posedge clk_tb);

        // SKZ, is_zero=1
        opcode_tb = 3'b001; is_zero_tb = 1;
        repeat(8) @(posedge clk_tb);

        // ADD
        opcode_tb = 3'b010; is_zero_tb = 0;
        repeat(8) @(posedge clk_tb);

        // AND
        opcode_tb = 3'b011;
        repeat(8) @(posedge clk_tb);

        // XOR
        opcode_tb = 3'b100;
        repeat(8) @(posedge clk_tb);

        // LDA
        opcode_tb = 3'b101;
        repeat(8) @(posedge clk_tb);

        // STO
        opcode_tb = 3'b110;
        repeat(8) @(posedge clk_tb);

        // JMP
        opcode_tb = 3'b111;
        repeat(8) @(posedge clk_tb);

        $finish;
    end
endmodule