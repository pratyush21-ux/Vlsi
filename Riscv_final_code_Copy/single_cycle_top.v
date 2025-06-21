module single_cycle_top(
    input clk,
    input reset,
    output [31:0] WriteData,
    output [31:0] ALU_OUTPUT,
    output MemWrite
);
wire [31:0] PC,Instr,ReadData;
Single_Cycle_Core single_cycle_core_inst(
    .clk(clk),
    .reset(reset),
    .Instr(Instr),
    .ReadData(ReadData),
    .PC(PC),
    .ALUResult(ALU_OUTPUT),
    .WriteData(WriteData),
    .MemWrite(MemWrite)
);
Instruction_Memory instruction_memory_inst(
    .address(PC),
    .data(Instr)
);
Data_mem data_mem_inst(
    .A(ALU_OUTPUT),
    .WD(WriteData),
    .clk(clk),
    .WE(MemWrite),
    .RD(ReadData)
);
endmodule