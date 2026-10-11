// ============================================================================
//  simple_cpu_v4.v  --  5-stage pipelined SimpleCPU (v4)
//
//  Verilog re-implementation of Mike Freeman's pipelined SimpleCPU v4
//  (https://simplecpudesign.com/simple_cpu_v4/) for an RTL-to-GDS tutorial.
//
//  * 16-bit data, 16-bit fixed-length instructions, 12-bit address space
//  * 8 general purpose registers RA..RH (RA = r0 ... RH = r7)
//  * Pipeline : IF -> ID -> EX -> MA -> WB
//  * ONE single-port memory for instructions AND data (von Neumann)
//      -> structural hazard on LOAD/STORE  : stall IF+ID while MA uses memory
//  * RAW hazards  : ID compares its source regs with the destination regs of
//                   valid instructions in EX / MA / WB and stalls (no forwarding)
//  * Control      : branch resolved in EX; no fetch while a jump is in ID/EX
//  * Bubbles are VALID=0 slots (no NOP instruction needed)
//
//  Instruction set (IR15..IR12 = opcode)
//    0000 MOVE  Rd,K      Rd = sext(K8)
//    0001 ADD   Rd,K      Rd = Rd + sext(K8)
//    0010 SUB   Rd,K      Rd = Rd - sext(K8)
//    0011 AND   Rd,K      Rd = Rd & zext(K8)
//    0100 LOAD  RA,A(Rs)  RA = MEM[Rs + sext(A9)]
//    0101 STORE RA,A(Rs)  MEM[Rs + sext(A9)] = RA
//    1000 JUMPU A12       PC = A12
//    1001 JUMPZ  Rs,A9    PC = (Rs==0) ? PC + sext(A9) : PC+1
//    1010 JUMPNZ Rs,A9    PC = (Rs!=0) ? PC + sext(A9) : PC+1
//    1100 JAL   A12       RH = PC+1 ; PC = A12
//    1111 register-register group, IR3..IR0 = function
//         0000 JR    Rs      PC = Rs          (Rs in IR11..IR9)
//         0001 MOVE  Rd,Rs   Rd = Rs          (Rd IR11..9, Rs IR8..6)
//         0010 ADD   Rd,Rs   Rd = Rd + Rs
//         0011 SUB   Rd,Rs   Rd = Rd - Rs
//         0100 AND   Rd,Rs   Rd = Rd & Rs
//    (PC in relative jumps = address of the jump instruction itself)
// ============================================================================
`timescale 1ns/1ps
`default_nettype none

module simple_cpu_v4 (
    input  wire        clk,
    input  wire        rst,        // synchronous, active high
    // single-port memory interface (asynchronous read)
    output wire [11:0] mem_addr,
    input  wire [15:0] mem_rdata,
    output wire [15:0] mem_wdata,
    output wire        mem_we,
    // debug
    output wire [11:0] dbg_pc
);

    // ------------------------------------------------------------------ opcodes
    localparam OP_MOVI = 4'b0000, OP_ADDI = 4'b0001, OP_SUBI = 4'b0010,
               OP_ANDI = 4'b0011, OP_LOAD = 4'b0100, OP_STOR = 4'b0101,
               OP_JMPU = 4'b1000, OP_JMPZ = 4'b1001, OP_JMNZ = 4'b1010,
               OP_JAL  = 4'b1100, OP_REG  = 4'b1111;

    localparam F_JR = 4'b0000, F_MOV = 4'b0001, F_ADD = 4'b0010,
               F_SUB = 4'b0011, F_AND = 4'b0100;

    // ALU operations carried down the pipe
    localparam A_PASSB = 3'd0, A_ADD = 3'd1, A_SUB = 3'd2, A_AND = 3'd3,
               A_LINK  = 3'd4;

    localparam RA = 3'd0, RH = 3'd7;

    // ============================================================ register file
    reg [15:0] rf [0:7];

    // ================================================================ PC / IF
    reg [11:0] pc;

    // IF/ID
    reg        id_valid;
    reg [15:0] id_ir;
    reg [11:0] id_pc;

    // ID/EX
    reg        ex_valid;
    reg [2:0]  ex_alu;
    reg [15:0] ex_a, ex_b;        // ALU operands
    reg [2:0]  ex_rd;
    reg        ex_wen;
    reg        ex_load, ex_store;
    reg [15:0] ex_sdata;          // store data (RA)
    reg        ex_jump;           // any control-flow instruction
    reg [1:0]  ex_jkind;          // 0:uncond 1:if zero 2:if not zero
    reg [11:0] ex_jtarget;
    reg [15:0] ex_jtest;          // register tested by JUMPZ/JUMPNZ
    reg [11:0] ex_pc;

    // EX/MA
    reg        ma_valid;
    reg [15:0] ma_res;
    reg [2:0]  ma_rd;
    reg        ma_wen;
    reg        ma_load, ma_store;
    reg [15:0] ma_sdata;

    // MA/WB
    reg        wb_valid;
    reg [15:0] wb_res;
    reg [2:0]  wb_rd;
    reg        wb_wen;

    // ================================================================== DECODE
    wire [3:0]  op   = id_ir[15:12];
    wire [3:0]  fn   = id_ir[3:0];
    wire [2:0]  r_hi = id_ir[11:9];   // Rd (or Rs for LOAD/STORE/JUMPx/JR)
    wire [2:0]  r_lo = id_ir[8:6];    // Rs for reg-reg ops
    wire [15:0] k8s  = {{8{id_ir[7]}}, id_ir[7:0]};
    wire [15:0] k8z  = {8'h00, id_ir[7:0]};
    wire [15:0] a9s  = {{7{id_ir[8]}}, id_ir[8:0]};
    wire [11:0] a12  = id_ir[11:0];

    wire is_reg  = (op == OP_REG);
    wire is_jr   = is_reg & (fn == F_JR);
    wire is_rmov = is_reg & (fn == F_MOV);
    wire is_ralu = is_reg & ((fn == F_ADD) | (fn == F_SUB) | (fn == F_AND));
    wire is_imm  = (op == OP_MOVI) | (op == OP_ADDI) | (op == OP_SUBI) | (op == OP_ANDI);
    wire is_load = (op == OP_LOAD);
    wire is_stor = (op == OP_STOR);
    wire is_jcnd = (op == OP_JMPZ) | (op == OP_JMNZ);
    wire is_jump = (op == OP_JMPU) | is_jcnd | (op == OP_JAL) | is_jr;

    // ---- which registers does the instruction in ID read? (for RAW check)
    // src1 : r_hi used by ADDI/SUBI/ANDI, reg-reg ADD/SUB/AND, LOAD, STORE,
    //        JUMPZ/JUMPNZ, JR
    wire       rd_src1 = (is_imm & (op != OP_MOVI)) | is_ralu | is_load |
                         is_stor | is_jcnd | is_jr;
    wire [2:0] src1    = r_hi;
    // src2 : r_lo for reg-reg MOVE/ADD/SUB/AND ; RA for STORE
    wire       rd_src2 = is_rmov | is_ralu | is_stor;
    wire [2:0] src2    = is_stor ? RA : r_lo;

    // ---- destination register / write enable
    wire       d_wen = is_imm | is_rmov | is_ralu | is_load | (op == OP_JAL);
    wire [2:0] d_rd  = is_load ? RA : (op == OP_JAL) ? RH : r_hi;

    // ================================================================ HAZARDS
    // destination of each later stage, only if that stage really writes a reg
    wire ex_w = ex_valid & ex_wen;
    wire ma_w = ma_valid & ma_wen;
    wire wb_w = wb_valid & wb_wen;

    wire hit1 = rd_src1 & ((ex_w & (ex_rd == src1)) |
                           (ma_w & (ma_rd == src1)) |
                           (wb_w & (wb_rd == src1)));
    wire hit2 = rd_src2 & ((ex_w & (ex_rd == src2)) |
                           (ma_w & (ma_rd == src2)) |
                           (wb_w & (wb_rd == src2)));

    wire raw_stall    = id_valid & (hit1 | hit2);
    wire struct_stall = ma_valid & (ma_load | ma_store);        // memory busy
    wire id_stall     = raw_stall | struct_stall;
    wire id_issue     = id_valid & ~id_stall;

    // fetch only when memory free, ID not blocked, and no jump in flight
    wire ctrl_block   = (id_valid & is_jump) | (ex_valid & ex_jump);
    wire fetch        = ~id_stall & ~ctrl_block;

    // ============================================================= EX stage
    reg [15:0] alu_y;
    always @* begin
        case (ex_alu)
            A_ADD  : alu_y = ex_a + ex_b;
            A_SUB  : alu_y = ex_a - ex_b;
            A_AND  : alu_y = ex_a & ex_b;
            A_LINK : alu_y = {4'h0, ex_pc + 12'd1};
            default: alu_y = ex_b;
        endcase
    end

    wire ex_taken = ex_valid & ex_jump &
                    ( (ex_jkind == 2'd0) |
                      ((ex_jkind == 2'd1) & (ex_jtest == 16'd0)) |
                      ((ex_jkind == 2'd2) & (ex_jtest != 16'd0)) );

    // ============================================================ MEMORY port
    wire ma_mem = ma_valid & (ma_load | ma_store);
    assign mem_addr  = ma_mem ? ma_res[11:0] : pc;
    assign mem_we    = ma_valid & ma_store;
    assign mem_wdata = ma_sdata;
    assign dbg_pc    = pc;

    // ============================================================ SEQUENTIAL
    integer i;
    always @(posedge clk) begin
        if (rst) begin
            pc       <= 12'd0;
            id_valid <= 1'b0;  id_ir <= 16'd0;  id_pc <= 12'd0;
            ex_valid <= 1'b0;
            ma_valid <= 1'b0;
            wb_valid <= 1'b0;
            for (i = 0; i < 8; i = i + 1) rf[i] <= 16'd0;
        end else begin
            // ---------------------------------------------------------- WB
            if (wb_valid & wb_wen) rf[wb_rd] <= wb_res;

            // ---------------------------------------------------------- MA -> WB
            wb_valid <= ma_valid;
            wb_rd    <= ma_rd;
            wb_wen   <= ma_wen;
            wb_res   <= ma_load ? mem_rdata : ma_res;

            // ---------------------------------------------------------- EX -> MA
            ma_valid <= ex_valid;
            ma_res   <= alu_y;
            ma_rd    <= ex_rd;
            ma_wen   <= ex_wen;
            ma_load  <= ex_load;
            ma_store <= ex_store;
            ma_sdata <= ex_sdata;

            // ---------------------------------------------------------- ID -> EX
            ex_valid <= id_issue;              // bubble when stalled / empty
            if (id_issue) begin
                ex_pc      <= id_pc;
                ex_rd      <= d_rd;
                ex_wen     <= d_wen;
                ex_load    <= is_load;
                ex_store   <= is_stor;
                ex_sdata   <= rf[RA];
                ex_jump    <= is_jump;
                ex_jtest   <= rf[r_hi];
                ex_jkind   <= (op == OP_JMPZ) ? 2'd1 : (op == OP_JMNZ) ? 2'd2 : 2'd0;
                ex_jtarget <= is_jr  ? rf[r_hi][11:0] :
                              is_jcnd ? (id_pc + a9s[11:0]) : a12;
                // ALU operands
                ex_a <= rf[r_hi];
                case (1'b1)
                    (op == OP_MOVI)        : begin ex_alu <= A_PASSB; ex_b <= k8s; end
                    (op == OP_ADDI)        : begin ex_alu <= A_ADD;   ex_b <= k8s; end
                    (op == OP_SUBI)        : begin ex_alu <= A_SUB;   ex_b <= k8s; end
                    (op == OP_ANDI)        : begin ex_alu <= A_AND;   ex_b <= k8z; end
                    (is_load | is_stor)    : begin ex_alu <= A_ADD;   ex_b <= a9s; end
                    (op == OP_JAL)         : begin ex_alu <= A_LINK;  ex_b <= 16'd0; end
                    (is_rmov)              : begin ex_alu <= A_PASSB; ex_b <= rf[r_lo]; end
                    (is_reg & fn == F_ADD) : begin ex_alu <= A_ADD;   ex_b <= rf[r_lo]; end
                    (is_reg & fn == F_SUB) : begin ex_alu <= A_SUB;   ex_b <= rf[r_lo]; end
                    (is_reg & fn == F_AND) : begin ex_alu <= A_AND;   ex_b <= rf[r_lo]; end
                    default                : begin ex_alu <= A_PASSB; ex_b <= 16'd0; end
                endcase
            end

            // ---------------------------------------------------------- IF -> ID
            if (fetch) begin
                id_valid <= 1'b1;
                id_ir    <= mem_rdata;
                id_pc    <= pc;
            end else if (id_issue) begin
                id_valid <= 1'b0;              // instruction left, nothing new
            end
            // (raw/struct stall: IF/ID simply holds)

            // ---------------------------------------------------------- PC
            if (ex_taken)   pc <= ex_jtarget;
            else if (fetch) pc <= pc + 12'd1;
        end
    end

endmodule

`default_nettype wire

