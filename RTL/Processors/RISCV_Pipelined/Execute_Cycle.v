module Execute_Cycle (
    input clk,
    input rst, 
    input RegWriteE,
    input ALUSrcE,
    input MemWriteE,
    input [1:0] ResultSrcE,
    input BranchE,
    input [3:0] ALUControlE,
    input [31:0] RD1_E, RD2_E, ImmExt_E,
    input [4:0] RD_E,
    input [31:0] PCE, PCPlus4E,
    input [31:0] ResultW,
    input [31:0] ALU_ResultM,
    input [1:0] ForwardA_E, ForwardB_E,

    output PCSrcE,
    output RegWriteM,
    output MemWriteM,
    output [1:0] ResultSrcM,
    output [4:0] RD_M, 
    output [31:0] PCPlus4M, WriteDataM, ALU_ResultM_out,
    output [31:0] PCTargetE
);
    // Internal wires
    wire [31:0] Src_A, Src_B_interim, Src_B;
    wire [31:0] ResultE;
    wire ZeroE;

    // Pipeline registers
    reg RegWriteE_r, MemWriteE_r;
    reg [1:0] ResultSrcE_r;
    reg [4:0] RD_E_r;
    reg [31:0] PCPlus4E_r, RD2_E_r, ResultE_r;

    // Forwarding Mux (3:1 implemented with ternary)
    assign Src_A = (ForwardA_E == 2'b00) ? RD1_E :
                   (ForwardA_E == 2'b01) ? ResultW :
                   (ForwardA_E == 2'b10) ? ALU_ResultM :
                   RD1_E;

    assign Src_B_interim = (ForwardB_E == 2'b00) ? RD2_E :
                           (ForwardB_E == 2'b01) ? ResultW :
                           (ForwardB_E == 2'b10) ? ALU_ResultM :
                           RD2_E;

    // ALUSrc mux (2:1)
    assign Src_B = (ALUSrcE) ? ImmExt_E : Src_B_interim;

    // ALU
    ALU alu (
        .A(Src_A),
        .B(Src_B),
        .res(ResultE),
        .con(ALUControlE),
        .zero(ZeroE)
    );

    // Branch target adder
    Pc_Adder branch_adder (
        .a(PCE),
        .b(ImmExt_E),
        .c(PCTargetE)
    );

    // Pipeline register update
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteE_r <= 1'b0; 
            MemWriteE_r <= 1'b0; 
            ResultSrcE_r <= 2'b00;
            RD_E_r <= 5'h00;
            PCPlus4E_r <= 32'h00000000; 
            RD2_E_r <= 32'h00000000; 
            ResultE_r <= 32'h00000000;
        end else begin
            RegWriteE_r <= RegWriteE; 
            MemWriteE_r <= MemWriteE; 
            ResultSrcE_r <= ResultSrcE;
            RD_E_r <= RD_E;
            PCPlus4E_r <= PCPlus4E; 
            RD2_E_r <= Src_B_interim;
            ResultE_r <= ResultE;
        end
    end

    // Outputs
    assign PCSrcE         = ZeroE & BranchE;
    assign RegWriteM      = RegWriteE_r;
    assign MemWriteM      = MemWriteE_r;
    assign ResultSrcM     = ResultSrcE_r;
    assign RD_M           = RD_E_r;
    assign PCPlus4M       = PCPlus4E_r;
    assign WriteDataM     = RD2_E_r;
    assign ALU_ResultM_out = ResultE_r;
endmodule