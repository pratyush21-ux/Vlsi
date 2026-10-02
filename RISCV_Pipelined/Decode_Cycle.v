module Decode_Cycle (
    input clk,
    input rst,
    input RegWriteW,
    input [4:0] RdW,
    input [31:0] InstrD,
    input [31:0] PCD,
    input [31:0] PcPlus4D,
    input [31:0] ResultW,

    output RegWriteE,
    output ALUSrcE,
    output MemWriteE,
    output [1:0] ResultSrcE,
    output JumpE,
    output [3:0] ALUControlE,
    output [31:0] RD1_E, RD2_E, ImmExt_E,
    output [4:0] RS1_E, RS2_E, RD_E,
    output [31:0] PCE, PCPlus4E
);
    // Control signals in decode stage
    wire RegWriteD, ALUSrcD, MemWriteD, JumpD;
    wire [1:0] ResultSrcD, ImmSrcD;
    wire [3:0] ALUControlD;
    wire [31:0] RD1_D, RD2_D, ImmExtD;

    // Pipeline registers
    reg RegWriteD_r, ALUSrcD_r, MemWriteD_r, JumpD_r;
    reg [1:0] ResultSrcD_r;
    reg [3:0] ALUControlD_r;
    reg [31:0] RD1_D_r, RD2_D_r, ImmExtD_r;
    reg [4:0] RS1_D_r, RS2_D_r, RD_D_r;
    reg [31:0] PCD_r, PCPlus4D_r;

    // Control Unit
    Control_unit control (
        .op(InstrD[6:0]),
        .funct3(InstrD[14:12]),
        .funct7b5(InstrD[30]),
        .zero(1'b0),
        .ResultSrc(ResultSrcD),
        .ALUSrc(ALUSrcD),
        .PcSrc(),
        .RegWrite(RegWriteD),
        .MemWrite(MemWriteD),
        .Jump(JumpD),
        .ImmSrc(ImmSrcD),
        .ALUControl(ALUControlD)
    );

    // Register File
    REG_MEM_BLOCK regfile (
        .clk(clk),
        .we3(RegWriteW),
        .ra1(InstrD[19:15]),
        .ra2(InstrD[24:20]),
        .ra3(RdW),
        .wd3(ResultW),
        .rd1(RD1_D),
        .rd2(RD2_D)
    );

    // Immediate Extend
    Extend ext (
        .Instr(InstrD[31:7]),
        .ImmSrc(ImmSrcD),
        .ImmExt(ImmExtD)
    );

    // Pipeline Register Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteD_r   <= 1'b0;
            ALUSrcD_r     <= 1'b0;
            MemWriteD_r   <= 1'b0;
            JumpD_r       <= 1'b0;
            ResultSrcD_r  <= 2'b00;
            ALUControlD_r <= 4'b0000;
            RD1_D_r       <= 32'h0;
            RD2_D_r       <= 32'h0;
            ImmExtD_r     <= 32'h0;
            RD_D_r        <= 5'h0;
            RS1_D_r       <= 5'h0;
            RS2_D_r       <= 5'h0;
            PCD_r         <= 32'h0;
            PCPlus4D_r    <= 32'h0;
        end else begin
            RegWriteD_r   <= RegWriteD;
            ALUSrcD_r     <= ALUSrcD;
            MemWriteD_r   <= MemWriteD;
            JumpD_r       <= JumpD;
            ResultSrcD_r  <= ResultSrcD;
            ALUControlD_r <= ALUControlD;
            RD1_D_r       <= RD1_D;
            RD2_D_r       <= RD2_D;
            ImmExtD_r     <= ImmExtD;
            RD_D_r        <= InstrD[11:7];
            RS1_D_r       <= InstrD[19:15];
            RS2_D_r       <= InstrD[24:20];
            PCD_r         <= PCD;
            PCPlus4D_r    <= PcPlus4D;
        end
    end

    // Outputs
    assign RegWriteE   = RegWriteD_r;
    assign ALUSrcE     = ALUSrcD_r;
    assign MemWriteE   = MemWriteD_r;
    assign ResultSrcE  = ResultSrcD_r;
    assign JumpE       = JumpD_r;
    assign ALUControlE = ALUControlD_r;
    assign RD1_E       = RD1_D_r;
    assign RD2_E       = RD2_D_r;
    assign ImmExt_E    = ImmExtD_r;
    assign RD_E        = RD_D_r;
    assign RS1_E       = RS1_D_r;
    assign RS2_E       = RS2_D_r;
    assign PCE         = PCD_r;
    assign PCPlus4E    = PCPlus4D_r;
endmodule