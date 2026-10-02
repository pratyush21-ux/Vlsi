module data_memory (
    input [31:0] A,        
    input [31:0] WD,       
    input CLK,             
    input WE,             
    output reg [31:0] RD);
    reg [31:0] MEM [0:63]; 

    always @(*)
    begin
        RD = MEM[A[5:0]];
    end
    always @(posedge CLK)
    begin
        if (WE)
            MEM[A[5:0]] <= WD;
    end
endmodule

