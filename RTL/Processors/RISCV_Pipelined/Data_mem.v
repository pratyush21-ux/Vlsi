module Data_mem(
    input [31:0] A,
    input WE,
    input [31:0] WD,
    input clk,
    output [31:0] RD  
);
    reg [31:0] mem[63:0];
    reg [31:0] RD_reg;
    integer i;
    
    initial begin
        for(i = 0; i < 64; i = i + 1)
            mem[i] = 32'b0;
    end
    
    always @(posedge clk) begin
        if (WE)
            mem[A[31:2]] <= WD;
        RD_reg <= mem[A[31:2]];
    end
    
    assign RD = RD_reg;
endmodule