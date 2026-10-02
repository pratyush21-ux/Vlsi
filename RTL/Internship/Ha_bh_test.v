`timescale 1ns/1ps
module Ha_bh_test;
reg a,b;
wire s,c;
Ha_bh uut(.s(s),.c(c),.a(a),.b(b));
initial begin
$monitor("s=%b,c=%b,a=%b,b=%b",s,c,a,b);
end
initial
begin
#10 a=1'b0;b=1'b0;
#10 a=1;b=1'b0;
#10 a=0;b=1;
#10 a=1;b=1;
end 
initial begin
    $dumpfile("Hawave.vcd");
    $dumpvars();
  end
endmodule

