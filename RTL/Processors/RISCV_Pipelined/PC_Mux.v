module PC_Mux(
    input [31:0] PC_Target,
    input [31:0] PC_Plus_4,
    input PCSrc,
    output [31:0] PC_Next
);
    assign PC_Next = (PCSrc) ? PC_Target : PC_Plus_4;
endmodule