`timescale 1ns/ps
module 2x1_mux_test;
reg [1:0]i;
reg s;
wire y;
2x1_mux uut(.i(i),.s(s),.y(y));
initial begin
$minitor("i=%b,s=%b,y=%b",i,s,y);
end 
initial begin


