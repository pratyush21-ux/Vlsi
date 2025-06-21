module REG_MEM_BLOCK(
    input  [4:0] ra1,    
    input  [4:0] ra2, 
    input  [4:0] ra3,      
    input  [31:0] wd3,   
    input  we3,          
    input  clk,          
    output wire [31:0] rd1,   
    output wire [31:0] rd2    
);

    reg [31:0] regfile [0:31];
    always @(posedge clk)
    begin
        if (we3)
        begin
            regfile[ra3] <= wd3; 
        end
        
    end
    assign rd1=(ra1 != 0) ? regfile[ra1] :0;
    assign rd2=(ra2 != 0) ? regfile[ra2] :0;
endmodule
