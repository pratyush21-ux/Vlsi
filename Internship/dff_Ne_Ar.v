module dff_Ne_Ar(q,d,clk,rst);
input d,clk,rst;
output reg q;
always@(negedge clk or posedge rst)
if(rst)
q<=1'b0;
else
q<=d;
endmodule
