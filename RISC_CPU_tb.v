`timescale 1ns / 1ps

module RISC_CPU_tb;

reg clk;
reg rst;

wire [31:0] PC_out;
wire [2:0]  opcode;
wire [31:0] ACC_val;
wire [31:0] ALU_val;
wire        is_zero;
wire        sel, rd, wr, ld_ir, ld_ac, ld_pc, inc_pc, data_e, halt;
wire [31:0] data_bus;
wire [31:0] address_bus;

// ========== Instantiate ==========
RISC_CPU uut (
    .clk (clk),
    .rst (rst)
);

// ========== Alias ?? waveform d? ??c ==========
assign PC_out      = uut.u_pc.address_program;
assign opcode      = uut.u_ir.opcode;
assign ACC_val     = uut.u_acc.data_out;
assign ALU_val     = uut.u_alu.alu_out;
assign is_zero     = uut.u_alu.is_zero;
assign data_bus    = uut.data;
assign address_bus = uut.address;
assign sel         = uut.u_controller.sel;
assign rd          = uut.u_controller.rd;
assign wr          = uut.u_controller.wr;
assign ld_ir       = uut.u_controller.ld_ir;
assign ld_ac       = uut.u_controller.ld_ac;
assign ld_pc       = uut.u_controller.ld_pc;
assign inc_pc      = uut.u_controller.inc_pc;
assign data_e      = uut.u_controller.data_e;
assign halt        = uut.u_controller.halt;

// ========== Clock 10ns ==========
initial clk = 0;
always #5 clk = ~clk;

// ========== Reset ==========
initial begin
    rst = 1;
    #20;
    rst = 0;
end

// ========== N?p ch??ng trình ==========
initial begin
    @(negedge rst);
    #1;

    // D? li?u
    uut.u_memory.mem[16] = 32'd5;
    uut.u_memory.mem[17] = 32'd3;
    uut.u_memory.mem[18] = 32'd0;

    // L?nh
    uut.u_memory.mem[0] = {3'b101, 29'd16}; // LDA 16
    uut.u_memory.mem[1] = {3'b010, 29'd17}; // ADD 17
    uut.u_memory.mem[2] = {3'b110, 29'd18}; // STO 18
    uut.u_memory.mem[3] = {3'b000, 29'd0};  // HLT
end

// ========== In header ==========
initial begin
    @(negedge rst);
    #2;
    $display("========================================================");
    $display("           RISC CPU SIMULATION - BEHAVIORAL             ");
    $display("========================================================");
    $display("  Chuong trinh: LDA 16 -> ADD 17 -> STO 18 -> HLT");
    $display("  MEM[16] = 5  (toan hang A)");
    $display("  MEM[17] = 3  (toan hang B)");
    $display("  Mong doi: MEM[18] = 8  (A + B)");
    $display("========================================================");
    $display("  TIME(ns) | PC | OPCODE |  ACC  | ALU_OUT | rd wr halt");
    $display("--------------------------------------------------------");
end

// ========== In tr?ng thái m?i chu k? ==========
// Ch? in khi ld_ac ho?c wr ho?c halt thay ??i ?? d? ??c
always @(posedge clk) begin
    if (!rst) begin
        // In khi n?p ACC (k?t qu? ALU vào ACC)
        if (ld_ac) begin
            case (opcode)
                3'b101: $display("  %0t ns  | PC=%0d | LDA    | ACC<=%0d (doc tu MEM[%0d])",
                            $time, PC_out, ALU_val, uut.u_ir.address_instruction);
                3'b010: $display("  %0t ns  | PC=%0d | ADD    | ACC<=%0d (%0d + %0d)",
                            $time, PC_out, ALU_val,
                            uut.u_acc.data_out, uut.u_memory.mem[uut.u_ir.address_instruction]);
                3'b011: $display("  %0t ns  | PC=%0d | AND    | ACC<=%0d",
                            $time, PC_out, ALU_val);
                3'b100: $display("  %0t ns  | PC=%0d | XOR    | ACC<=%0d",
                            $time, PC_out, ALU_val);
                default: $display("  %0t ns  | PC=%0d | op=%b  | ACC<=%0d",
                            $time, PC_out, opcode, ALU_val);
            endcase
        end

        // In khi ghi memory (STO)
        if (wr) begin
            $display("  %0t ns  | PC=%0d | STO    | MEM[%0d] <= %0d (tu ACC)",
                $time, PC_out,
                uut.u_ir.address_instruction,
                uut.u_acc.data_out);
        end

        // In khi nh?y (JMP)
        if (ld_pc) begin
            $display("  %0t ns  | PC=%0d | JMP    | PC <= %0d",
                $time, PC_out, uut.u_ir.address_instruction);
        end

        // In khi SKZ skip
        if (inc_pc && opcode == 3'b001) begin
            $display("  %0t ns  | PC=%0d | SKZ    | ACC=0, bo qua lenh tiep theo",
                $time, PC_out);
        end

        // In khi HALT
        if (halt) begin
            $display("--------------------------------------------------------");
            $display("  %0t ns  | PC=%0d | HLT    | CPU DUNG", $time, PC_out);
        end
    end
end

// ========== Ki?m tra k?t qu? khi HALT ==========
initial begin
    @(negedge rst);
    forever begin
        @(posedge clk);
        if (uut.u_controller.halt == 1'b1) begin
            #1;
            $display("========================================================");
            $display("  KET QUA CUOI:");
            $display("  MEM[16] = %0d  (A)", uut.u_memory.mem[16]);
            $display("  MEM[17] = %0d  (B)", uut.u_memory.mem[17]);
            $display("  MEM[18] = %0d  (A + B, mong doi: 8)", uut.u_memory.mem[18]);
            $display("  ACC     = %0d", uut.u_acc.data_out);
            $display("========================================================");
            if (uut.u_memory.mem[18] == 32'd8)
                $display("  >>> PASS: 5 + 3 = 8 <<<");
            else
                $display("  >>> FAIL: ket qua = %0d <<<", uut.u_memory.mem[18]);
            $display("========================================================");
            $stop;
        end
    end
end

// ========== Timeout ==========
initial begin
    repeat (2000) @(posedge clk);
    $display(">>> TIMEOUT: CPU khong HALT sau 2000 chu ky <<<");
    $stop;
end

endmodule
