module Result_Mux(
    input [31:0] ALUResult,
    input [31:0] ReadData,
    input [31:0] Pc_Plus_4,
    input [1:0] ResultSrc,
    output reg [31:0] Result
);
    always @(*) begin
        case(ResultSrc)
            2'b00: Result = ALUResult;
            2'b01: Result = ReadData;
            2'b10: Result = Pc_Plus_4;
            2'b11: Result = Pc_Plus_4;
            default: Result = 32'bx;
        endcase
    end
endmodule