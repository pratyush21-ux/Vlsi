module PC(input [31:0] PCNext,input reset,input clk,output reg [31:0]Pc);
    always@(posedge clk or posedge reset)
    begin
        if (reset)
            Pc<=32'b00;
        else
            Pc<=PCNext;
    end
endmodule
