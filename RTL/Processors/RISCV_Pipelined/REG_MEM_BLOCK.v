module REG_MEM_BLOCK(
    input [4:0] ra1,    
    input [4:0] ra2, 
    input [4:0] ra3,      
    input [31:0] wd3,   
    input we3,          
    input clk,          
    output wire [31:0] rd1,   
    output wire [31:0] rd2    
);
    reg [31:0] regfile [0:31];
    integer i;

    initial begin
        for (i = 0; i < 32; i = i + 1)
            regfile[i] = 0;
    end

    always @(posedge clk) begin
        if (we3 && (ra3 != 0))
            regfile[ra3] <= wd3; 
    end

    assign rd1 = (ra1 != 0) ? ((we3 && (ra1 == ra3)) ? wd3 : regfile[ra1]) : 0;
    assign rd2 = (ra2 != 0) ? ((we3 && (ra2 == ra3)) ? wd3 : regfile[ra2]) : 0;
endmodule
