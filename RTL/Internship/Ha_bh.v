module Ha_bh(s,c,a,b);
input a,b;
output reg s,c;
always@(a,b)
begin
s=a^b;
c=a&b;
end
endmodule
