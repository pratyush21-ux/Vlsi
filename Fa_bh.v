module Ha_bh(s,c,a,b);
input a,b;
output reg s,c;
always@(a,b)
begin
s=a^b;
c=a&b;
end
endmodule
module Fa_bh(s,c,a,b,cin);
input a,b,cin;
output s,c;
wire n1,n2,n3;
Ha_bh Ha_bh1(n1,n2,a,b);
Ha_bh Ha_bh2(s,n3,n1,cin);
assign c=n3|n2;
endmodule
