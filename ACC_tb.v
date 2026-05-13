`timescale 1ns / 1ps

module ACC_tb;
    reg         clk;
    reg         rst;
    reg         ld_ac;
    reg         data_e; 
    reg  [31:0] alu_out; 
    wire [31:0] data_out; 
    
    ACC uut (
        .clk      (clk),
        .rst      (rst),
        .ld_ac    (ld_ac),
        .data_e   (data_e),
        .alu_out  (alu_out),
        .data_out (data_out)
    );
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    task display_state;
        input [8*5:1] tc_name;
        begin
            @(posedge clk);
            #1; // Đợi dữ liệu ổn định sau cạnh lên
            $display("%s | rst=%b | ld_ac=%b | alu_out=%0d | data_out=%0d", 
                      tc_name, rst, ld_ac, alu_out, data_out);
        end
    endtask

    initial begin
        rst = 1; ld_ac = 0; data_e = 1; alu_out = 32'd0;
        #10;

        // -- TC1: Kiểm tra chức năng reset hệ thống --
        $display("--- TC1: System Reset ---");
        display_state("TC1  "); 
        rst = 0;

        // -- TC2: Kiểm tra chức năng nạp dữ liệu (ld_ac = 1) --
        $display("--- TC2: Load Data (ALU Result) ---");
        ld_ac = 1;
        alu_out = 32'd150; 
        display_state("TC2.1"); 
        
        alu_out = 32'd300;
        display_state("TC2.2"); 

        // -- TC3: Kiểm tra tính ổn định dữ liệu (ld_ac = 0) --
        $display("--- TC3: Data Stability (Idle/Fetch) ---");
        ld_ac = 0;
        alu_out = 32'd999; 
        display_state("TC3.1"); // Kỳ vọng data_out vẫn giữ 300
        display_state("TC3.2"); 

        // -- TC4: Kiểm tra phản hồi --
        $display("--- TC4: Feedback Check ---");
        display_state("TC4  "); 

        // -- TC5: Tương tác Bus --
        $display("--- TC5: Interaction with Data Bus ---");
        ld_ac = 1;
        alu_out = 32'd500;
        display_state("TC5.1"); 
        ld_ac = 0;
        display_state("TC5.2"); 

        // -- TC6: Ưu tiên Reset --
        $display("--- TC6: Reset Priority Check ---");
        ld_ac = 1; alu_out = 32'd4444;
        rst = 1; 
        display_state("TC6.1"); // Kỳ vọng data_out = 0
        rst = 0;
        display_state("TC6.2"); // data_out = 4444

        // -- TC7: Giá trị biên 32-bit --
        $display("--- TC7: Boundary Values ---");
        ld_ac = 1;
        alu_out = 32'hFFFF_FFFF; 
        display_state("TC7.1"); 
        alu_out = 32'h0000_0000; 
        display_state("TC7.2");

        // -- TC8: Stress Test --
        $display("--- TC8: Rapid Toggling ---");
        ld_ac = 1;
        alu_out = 32'hAAAA_AAAA; display_state("TC8.1");
        alu_out = 32'h5555_5555; display_state("TC8.2");
        ld_ac = 0;
        alu_out = 32'h1234_5678; display_state("TC8.3"); // Giữ 5555_5555

        $display("--- DONE ---");
        $finish;
    end
    
endmodule