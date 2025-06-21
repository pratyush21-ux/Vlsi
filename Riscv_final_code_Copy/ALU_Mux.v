module ALU_Mux(input [31:0]WD,
    input [31:0] ImmExt,
    input ALUSrc,
    output [31:0]B
);
    assign B=(ALUSrc)?ImmExt:WD;
endmodule
