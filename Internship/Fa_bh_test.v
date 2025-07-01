`timescale 1ns/1ps
module Fa_bh_test;
reg a,b,cin;
wire s,c;
Fa_bh uut(.s(s),.c(c),.a(a),.b(b),.cin(cin));
initial begin
$monitor("s=%b,c=%b,a=%b,b=%b,cin=%b",s,c,a,b,cin);
end 
initial 
begin
#10 a=0;b=0;cin=0;
#10 a=0;b=0;cin=1;
#10 a=0;b=1;cin=0;
#10 a=0;b=1;cin=1;
#10 a=1;b=0;cin=0;
#10 a=1;b=0;cin=1;
#10 a=1;b=1;cin=0;
#10 a=1;b=1;cin=1;
end
initial begin
$dumpfile("Fawave.vcd");
$dumpvars();
end 
endmodule
