`timescale 1ns / 1ps
module Memory_tb();
reg clk_tb;
reg rd_tb;
reg wr_tb;
reg [31:0] address_tb;
wire[31:0] data_tb;
reg [31:0] data_drive;

assign data_tb =(wr_tb)? data_drive: 32'bz;

Memory dut (.clk(clk_tb), .rd(rd_tb), .wr(wr_tb), .address(address_tb), .data(data_tb));

 initial clk_tb =0;
 always #10 clk_tb = ~clk_tb;
 
 task write_mem;
        input [31:0] addr;
        input [31:0] wdata;
        begin
            @(negedge clk_tb);
            address_tb  = addr;
            data_drive  = wdata;
            wr_tb       = 1; rd_tb = 0;
            @(posedge clk_tb); #1;
            $display("WRITE | addr=%0d | data=%h", addr, wdata);
            wr_tb = 0;
        end
    endtask
    
  task read_mem;
  input [31:0] addr;
  begin
            @(negedge clk_tb);
            address_tb = addr;
            rd_tb = 1; wr_tb = 0;
            #1; 
            $display("READ  | addr=%0d | data=%h", addr, data_tb);
            @(posedge clk_tb); #1;
            rd_tb = 0;
        end
    endtask
     initial begin
        rd_tb = 0; wr_tb = 0;
        address_tb  = 0; data_drive = 0;
        
      $display("--- TC1: Write Operations ---");
        write_mem(32'd0,  32'hDEAD_BEEF);
        write_mem(32'd1,  32'hCAFE_BABE);
        write_mem(32'd5,  32'h1234_5678);
        write_mem(32'd31, 32'hFFFF_FFFF);
        $display("--- TC2: Read Back Verify ---");
        read_mem(32'd0);   
        read_mem(32'd1);   
        read_mem(32'd5);   
        read_mem(32'd31);  

        $display("--- TC3: Overwrite ---");
        write_mem(32'd0, 32'hAAAA_AAAA);
        read_mem(32'd0);  
        $display("--- TC4: Uninitialized Read ---");
        read_mem(32'd10);  
        $display("--- TC5: Idle (high-Z) ---");
        @(negedge clk_tb);
        rd_tb = 0; wr_tb = 0;
        #1;
        $display("IDLE  | data=%h (should be Z)", data_tb);
        $display("--- DONE ---");
        $finish;
    end

endmodule
