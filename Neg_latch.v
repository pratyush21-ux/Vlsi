module Neg_latch(clk,rst,q,d);
    input clk,rst,d;
    output reg q;
    always@(*)
    begin
        if(rst)
            q<=1'b0;
        else if(!clk)
            q<=d;
    end
endmodule
