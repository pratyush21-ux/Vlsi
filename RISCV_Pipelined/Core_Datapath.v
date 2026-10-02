module Core_Datapath(
    input clk,
    input reset,
    input [1:0] ResultSrc,
    input ALUSrc,
    input PcSrc,
    input RegWrite,
    input [1:0]ImmSrc,
    input [3:0] ALUControl,
    input [31:0] ReadData,
    input [31:0] Instr,
    output Zero,
    output [31:0] ALUResult,
    output [31:0] PC,
    output [31:0] WriteData
);
wire [31:0] PCNext, PCPlus4, PCTarget;
wire [31:0] ImmExt;
wire [31:0] SrcA,SrcB;
wire [31:0] Result;
PC pc_inst(
    .PCNext(PCNext),
    .reset(reset),
    .clk(clk),
    .Pc(PC)
);
Pc_Plus_4 pc_plus_4_inst(
    .Pc(PC),
    .PCPlus4(PCPlus4)
);
PC_Mux pc_mux_inst(
    .PC_Target(PCTarget),
    .PC_Plus_4(PCPlus4),
    .PC_Next(PCNext),
    .PCSrc(PcSrc)
);
REG_MEM_BLOCK reg_mem_block_inst(
    .clk(clk),
    .we3(RegWrite),
    .ra1(Instr[19:15]),    
    .ra2(Instr[24:20]), 
    .ra3(Instr[11:7]),      
    .wd3(Result),   
    .rd1(SrcA),   
    .rd2(WriteData)    
);
Extend extend_inst(
    .Instr(Instr[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
);
ALU_Mux alu_mux_inst(
    .WD(WriteData),
    .ImmExt(ImmExt),
    .ALUSrc(ALUSrc),
    .B(SrcB)
);
ALU alu_inst(
    .A(SrcA),
    .B(SrcB),
    .con(ALUControl),
    .zero(Zero),
    .res(ALUResult)
);
Result_Mux result_mux_inst(
    .ALUResult(ALUResult),
    .ReadData(ReadData),
    .Pc_Plus_4(PCPlus4),
    .ResultSrc(ResultSrc),
    .Result(Result)
);
endmodule