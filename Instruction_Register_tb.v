`timescale 1ns / 1ps
module Instruction_Register_tb();
reg clk_tb;
reg rst_tb;
reg ld_ir_tb;
reg[31:0] instruction_data_tb;
wire[2:0] opcode_tb;
wire[31:0] address_instruction_tb;

Instruction_Register dut (
 .clk (clk_tb),
 .rst (rst_tb),
 .ld_ir (ld_ir_tb),
 .instruction_data (instruction_data_tb),
 .opcode (opcode_tb),
 .address_instruction (address_instruction_tb));
 
 initial clk_tb = 0;
    always #10 clk_tb = ~clk_tb;
    
 task display_state;
        input [8*6:1] tc_name; 
        begin
            @(posedge clk_tb); #2;
            $display("[%0t ns] %s | rst=%b ld_ir=%b | Data In=%h | Opcode Out=%b | Addr Out=%h",
                     $time, tc_name, rst_tb, ld_ir_tb, 
                     instruction_data_tb, opcode_tb, address_instruction_tb);
        end
    endtask
    
 initial begin 
rst_tb = 1; 
ld_ir_tb = 0;
instruction_data_tb = 32'h0;

$display("\n--- TC1: System Reset ---");
        display_state("TC1   ");
   rst_tb = 0;     

$display("\n--- TC2: Load ADD instruction ---");
        ld_ir_tb = 1;
        instruction_data_tb = 32'h40000005; 
        display_state("TC2   ");
 $display("\n--- TC3: Load LDA instruction ---");
        instruction_data_tb = 32'hA000001F; 
        display_state("TC3   ");
        
 $display("\n--- TC4: Hold data when ld_ir=0 ---");
        ld_ir_tb = 0;
        instruction_data_tb = 32'hFFFFFFFF; 
        display_state("TC4.1 "); 
        display_state("TC4.2 ");    
        
 $display("\n--- TC5: Load JMP instruction ---");
        ld_ir_tb = 1;
        instruction_data_tb = 32'hE000000A; 
        display_state("TC5   ");
        
 $display("\n--- TC6: Reset Priority ---");
        rst_tb = 1; 
        ld_ir_tb = 1;
        instruction_data_tb = 32'hFFFFFFFF;
        display_state("TC6   ");        
 $display("\n--- ALL TESTS COMPLETED ---");
        $finish;
    end   
endmodule
