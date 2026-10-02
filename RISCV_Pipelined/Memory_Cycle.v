module Memory_Cycle(
    input clk,
    input rst,
    input RegWriteM,
    input MemWriteM,
    input [1:0] ResultSrcM,
    input [4:0] RD_M, 
    input [31:0] PCPlus4M, WriteDataM, ALU_ResultM_out,
    
    output RegWriteW,
    output MemWriteW,
    output [1:0] ResultSrcW,
    output [4:0] RD_W,
    output [31:0] PCPlus4W, ALU_ResultW, ReadDataW
);
    wire [31:0] ReadDataM;
    reg RegWriteM_r, MemWriteM_r;
    reg [1:0] ResultSrcM_r;
    reg [4:0] RD_M_r;
    reg [31:0] PCPlus4M_r, ALU_ResultM_out_r, ReadDataM_r;
    
    // Data memory
    Data_mem datmem(
        .A(ALU_ResultM_out),
        .WE(MemWriteM),
        .WD(WriteDataM),
        .clk(clk),
        .RD(ReadDataM)
    );
    
    // Pipeline registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            RegWriteM_r <= 0;
            MemWriteM_r <= 0;
            ResultSrcM_r <= 2'b00;
            RD_M_r <= 0;
            PCPlus4M_r <= 0;
            ALU_ResultM_out_r <= 0;
            ReadDataM_r <= 0;
        end else begin
            RegWriteM_r <= RegWriteM;
            MemWriteM_r <= MemWriteM;
            ResultSrcM_r <= ResultSrcM;
            RD_M_r <= RD_M;
            PCPlus4M_r <= PCPlus4M;
            ALU_ResultM_out_r <= ALU_ResultM_out;
            ReadDataM_r <= ReadDataM;
        end
    end
    
    // Outputs
    assign RegWriteW = RegWriteM_r;
    assign RD_W = RD_M_r;
    assign ResultSrcW = ResultSrcM_r;
    assign ALU_ResultW = ALU_ResultM_out_r;
    assign PCPlus4W = PCPlus4M_r;
    assign ReadDataW = ReadDataM_r;
    assign MemWriteW = MemWriteM_r;
endmodule
