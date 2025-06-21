module PC_Mux(PC_Target,PC_Plus_4,PC_Next,PCSrc);
    input [31:0]PC_Target,PC_Plus_4;
    input PCSrc;
    output [31:0] PC_Next;
    assign PC_Next=(PCSrc)?PC_Target:PC_Plus_4;
endmodule


