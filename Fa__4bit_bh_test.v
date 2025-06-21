`timescale 1ns/1ps
module Fa__4bit_bh_test;
reg [3:0]a,b;
reg cin;
wire [3:0]s;
wire cout;
Fa__4bit_bh uut(.s(s),.cout(cout),.a(a),.b(b),.cin(cin));
initial
begin
$monitor("a=%b , b=%b ,cin=%b ,s=%b ,cout=%b",a,b,cin,s,cout);
end
initial
begin 
a=4'b0000;b=4'b0000;cin=1'b0;
#10 a=4'b0001;b=4'b0001;cin=1'b1;
#10 a=4'b0010;b=4'b0010;cin=1'b0;
#10 a=4'b0011;b=4'b0011;cin=1'b1;
#10 a=4'b0100;b=4'b0100;cin=1'b0;
#10 a=4'b0101;b=4'b0101;cin=1'b1;
#10 a=4'b0111;b=4'b0111;cin=1'b0;
#10 a=4'b1110;b=4'b1110;cin=1'b1;
#10 a=4'b1111;b=4'b1111;cin=1'b0;
end
initial begin
    $dumpfile("Fawave1.vcd");
    $dumpvars();
  end
endmodule
