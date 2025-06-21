module Single_Cycle_Core(
    input clk,
    input reset,
    input [31:0] Instr,
    input [31:0] ReadData,
    output [31:0] PC,
    output [31:0] ALUResult,
    output [31:0] WriteData,
    output MemWrite
);
wire ALUSrc,RegWrite,Zero,PcSrc,Jump;
wire [1:0] ResultSrc,ImmSrc;
wire [3:0] ALUControl;
Control_unit control_unit_inst(
    .op(Instr[6:0]),
    .funct3(Instr[14:12]),
    .funct7b5(Instr[30]),
    .zero(Zero),
    .ResultSrc(ResultSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .Jump(Jump),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .PcSrc(PcSrc)
);
Core_Datapath core_datapath_inst(
    .clk(clk),
    .reset(reset),
    .ResultSrc(ResultSrc),
    .ALUSrc(ALUSrc),
    .PcSrc(PcSrc),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .ReadData(ReadData),
    .Instr(Instr),
    .Zero(Zero),
    .ALUResult(ALUResult),
    .PC(PC),
    .WriteData(WriteData)
);
endmodule
    