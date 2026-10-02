module Writeback_cycle(
    input clk,
    input rst,
    input [1:0] ResultSrcW,
    input [31:0] PCPlus4W, ALU_ResultW, ReadDataW,
    output reg [31:0] ResultW
);
    always @(*) begin
        case(ResultSrcW)
            2'b00: ResultW = ALU_ResultW;   // ALU result
            2'b01: ResultW = ReadDataW;     // Memory data
            2'b10: ResultW = PCPlus4W;      // PC+4 (for JAL/JALR)
            default: ResultW = ALU_ResultW; // Safe default
        endcase
    end
endmodule
