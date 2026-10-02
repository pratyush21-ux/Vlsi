`timescale 1ns/1ps
module Path_test;
    reg [7:0] inA,inB;
    reg clk,rst,s;
    wire [8:0]y;
    reg [3:0]op;
    Path uut(.inA(inA),.inB(inB),.clk(clk),.rst(rst),.y(y),.op(op),.s(s));
    initial begin
        $monitor("inA=%b,inB=%b,y=%b,s=%b,op=%b",inA,inB,y,s,op);
    end
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
    initial begin
        #10 inA=8'b00001111;inB=8'b11110000;s=1'b1;op=4'b0000;rst=1'b0;
        #10 inA=8'b00001111;inB=8'b11110000;s=1'b0;op=4'b0000;rst=1'b0;
    end
endmodule

