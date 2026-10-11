// simple_cpu_v4_tb.v - self-checking testbench for the pipelined SimpleCPU v4
`timescale 1ns/1ps
`default_nettype none

module simple_cpu_v4_tb;
    reg         clk = 1'b0, rst = 1'b1;
    wire [11:0] mem_addr, dbg_pc;
    wire [15:0] mem_wdata;
    wire        mem_we;
    reg  [15:0] mem [0:4095];

    // single-port memory: asynchronous read, synchronous write
    wire [15:0] mem_rdata = mem[mem_addr];
    always @(posedge clk) if (mem_we) mem[mem_addr] <= mem_wdata;

    simple_cpu_v4 dut (.clk(clk), .rst(rst), .mem_addr(mem_addr), .mem_rdata(mem_rdata),
                       .mem_wdata(mem_wdata), .mem_we(mem_we), .dbg_pc(dbg_pc));

    always #10 clk = ~clk;                       // 50 MHz

    // ---------------- instruction encoders ----------------
    function [15:0] MOVI (input [2:0] rd, input [7:0] k);  MOVI = {4'b0000, rd, 1'b0, k}; endfunction
    function [15:0] SUBI (input [2:0] rd, input [7:0] k);  SUBI = {4'b0010, rd, 1'b0, k}; endfunction
    function [15:0] ANDI (input [2:0] rd, input [7:0] k);  ANDI = {4'b0011, rd, 1'b0, k}; endfunction
    function [15:0] LOAD (input [2:0] rs, input [8:0] a);  LOAD = {4'b0100, rs, a};       endfunction
    function [15:0] STOR (input [2:0] rs, input [8:0] a);  STOR = {4'b0101, rs, a};       endfunction
    function [15:0] JMPU (input [11:0] a);                 JMPU = {4'b1000, a};           endfunction
    function [15:0] JMPZ (input [2:0] rs, input [8:0] a);  JMPZ = {4'b1001, rs, a};       endfunction
    function [15:0] JMNZ (input [2:0] rs, input [8:0] a);  JMNZ = {4'b1010, rs, a};       endfunction
    function [15:0] JAL  (input [11:0] a);                 JAL  = {4'b1100, a};           endfunction
    function [15:0] JR   (input [2:0] rs);                 JR   = {4'hF, rs, 5'd0, 4'h0}; endfunction
    function [15:0] MOVR (input [2:0] rd, input [2:0] rs); MOVR = {4'hF, rd, rs, 2'b00, 4'h1}; endfunction
    function [15:0] ADDR (input [2:0] rd, input [2:0] rs); ADDR = {4'hF, rd, rs, 2'b00, 4'h2}; endfunction

    localparam RA=3'd0, RB=3'd1, RC=3'd2, RD=3'd3, RE=3'd4, RH=3'd7;

    integer i, errors = 0;
    initial begin
        for (i = 0; i < 4096; i = i + 1) mem[i] = 16'h0000;
        // sum = 10+9+...+1 = 55, store/load it, call a subroutine, test JUMPZ
        mem[0]  = MOVI(RB, 8'd0);          // RB = 0   (sum)
        mem[1]  = MOVI(RC, 8'd10);         // RC = 10  (counter)
        mem[2]  = ADDR(RB, RC);            // loop: RB += RC
        mem[3]  = SUBI(RC, 8'd1);          //       RC -= 1
        mem[4]  = JMNZ(RC, -9'sd2);        //       if RC!=0 goto 2
        mem[5]  = MOVR(RA, RB);            // RA = 55
        mem[6]  = MOVI(RD, 8'd0);          // RD = 0   (base)
        mem[7]  = STOR(RD, 9'd200);        // M[200] = 55
        mem[8]  = MOVI(RA, 8'd0);          // RA = 0
        mem[9]  = LOAD(RD, 9'd200);        // RA = M[200] = 55
        mem[10] = JAL(12'd20);             // call sub, RH = 11
        mem[11] = STOR(RD, 9'd201);        // M[201] = 108
        mem[12] = MOVI(RE, 8'd0);          // RE = 0
        mem[13] = JMPZ(RE, 9'd2);          // RE==0 -> goto 15
        mem[14] = STOR(RD, 9'd202);        // must be SKIPPED
        mem[15] = JMPU(12'd15);            // halt (spin)
        mem[20] = ADDR(RA, RA);            // sub: RA = 110
        mem[21] = ANDI(RA, 8'h7C);         //      RA = 110 & 0x7C = 108
        mem[22] = JR(RH);                  //      return
    end

    initial begin
        $dumpfile("simple_cpu_v4_tb.vcd");
        $dumpvars(0, simple_cpu_v4_tb);
        repeat (3) @(posedge clk);
        rst = 1'b0;
        repeat (300) @(posedge clk);

        $display("M[200] = %0d (expect 55)",  mem[200]);
        $display("M[201] = %0d (expect 108)", mem[201]);
        $display("M[202] = %0d (expect 0)",   mem[202]);
        $display("PC     = %0d (expect 15/16 spin loop)", dbg_pc);
        $display("RB=%0d RC=%0d RH=%0d", dut.rf[1], dut.rf[2], dut.rf[7]);
        if (mem[200] !== 16'd55)  errors = errors + 1;
        if (mem[201] !== 16'd108) errors = errors + 1;
        if (mem[202] !== 16'd0)   errors = errors + 1;
        if (dbg_pc != 12'd15 && dbg_pc != 12'd16) errors = errors + 1;
        if (dut.rf[7] !== 16'd11) errors = errors + 1;
        if (errors == 0) $display("TEST PASSED");
        else             $display("TEST FAILED: %0d errors", errors);
        $finish;
    end
endmodule

`default_nettype wire
