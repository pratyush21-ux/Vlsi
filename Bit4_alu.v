module  Bit4_alu(a,b,sel,y);

    input [3:0]a,b,sel;
    output  [4:0]y;
    reg flag;reg [3:0]y1;
    always@(a,b,sel)
    begin
        case(sel)
      4'b0000: {flag,y1} = a + b;
      4'b0001: {flag,y1} = a - b;
      4'b0010: y1 = a & b;
      4'b0011: y1 = a | b;
      4'b0100: y1 = a ^ b;
      4'b0101: y1 = a~^b;  
      4'b0110: y1 = (~a);
      4'b0111: y1 = a >> b; 
      4'b1000: y1 = a << b;
            default:y1=4'bz;
        endcase
    end
        assign y=(sel==4'b0000)?{flag,y1}:y1;
        assign y=(sel==4'b0001)?{flag,y1}:y1;
endmodule


