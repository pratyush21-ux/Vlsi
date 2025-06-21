`timescale 1ns/1ps
module Bit4_alu_test;
  reg [3:0]a,b,sel;
  wire [4:0]y;
  Bit4_alu uut(.a(a),.b(b),.sel(sel),.y(y));
  initial begin
    $monitor("a=%b b=%b sel=%b | y=%b",a,b,sel,y);
  end
  initial begin
        a = 4'b0011; b = 4'b1001; sel = 4'b0000;
    #10 a = 4'b1010;b=4'b1001; sel = 4'b0001;
    #10 a = 4'b1111;b=4'b1010; sel = 4'b0010;
    #10 a = 4'b1001; b = 4'b0110; sel = 4'b0011;
    #10 a = 4'b0010; b = 4'b0110; sel = 4'b0100;
    #10 a = 4'b1001; b = 4'b1010; sel = 4'b0101;
    #10 a = 4'b1010; sel = 4'b0110;
    #10 a = 4'b1111; b = 4'b0001; sel = 4'b0111;
    #10 a = 4'b1010; b = 4'b0011; sel = 4'b1000;
  end 
endmodule
