module Control_unit(
    input [6:0] op,
    input [2:0] funct3,
    input funct7b5,
    input zero,
    output [1:0] ResultSrc,
    output ALUSrc,
    output PcSrc,
    output RegWrite,
    output MemWrite,
    output Jump,
    output [1:0] ImmSrc,
    output [3:0] ALUControl
);
    wire [1:0] ALUOp;
    wire Branch;
    
    Main_Decoder main_decoder(
        .op(op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUop(ALUOp),
        .Jump(Jump)
    );
    
    ALUDecoder alu_decoder(
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .ALUOp(ALUOp),
        .ALUControl(ALUControl)
    );
    
    assign PcSrc = (Branch & zero) | Jump;
endmodule
