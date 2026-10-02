module 2x1_mux(y,i,s);
input[1:0]i;
input s;
output reg y;
always@(*)
if(s)
y=i[1];
else 
y=i[0];
endmodule;
