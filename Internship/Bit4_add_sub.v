module Bit4_add_sub(y,cout,a,b,cin);
    input [3:0]a,b;   
    input cin;
    output [3:0]y;
    output cout;
    assign {cout,y}=a|(~b)|cin;
endmodule
