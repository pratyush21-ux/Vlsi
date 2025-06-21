module Data_mem(
    input [31:0] A,
    input WE,
    input [31:0]WD,
    input clk,
    output [31:0] RD
);
reg[31:0]mem[63:0];
assign RD = mem[A[31:2]];
always @(posedge clk) 
begin
    if (WE)
     begin
        mem[A[31:2]] <= WD;
    end
end
endmodule