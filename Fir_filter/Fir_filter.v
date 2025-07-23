module Fir_filter(
    input clk,
    input rst,
    input [7:0]x_in,
    output reg [15:0]y_out
);
parameter N=4;
wire [7:0] coeff [0:N-1];
assign coeff[0] = 8'd1;
assign coeff[1] = 8'd2;
assign coeff[2] = 8'd3;
assign coeff[3] = 8'd4;
integer i;
reg [7:0] x_reg [0:N-1];
always @(posedge clk or posedge rst) begin
    if(rst)
    begin 
        for(i=0;i<N;i=1+i)
        begin
            x_reg[i]<=8'd0;
        end
        y_out <=16'd0;
    end 
    else 
    begin
        for(i=N-1;i>0;i=i-1)
        begin
            x_reg[i]<= x_reg[i-1];
        end
        x_reg[0] <= x_in;
        y_out <= (x_reg[0] * coeff[0]) + 
                  (x_reg[1] * coeff[1]) + 
                  (x_reg[2] * coeff[2]) + 
                  (x_reg[3] * coeff[3]);
        end
    end
endmodule