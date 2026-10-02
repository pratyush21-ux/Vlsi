module data_memory(clk,we,A,wd,rd);
    input clk,we;
    input [31:0]A,wd;
    output [31:0]rd;
    integer i;
    reg [31:0]ram[0:63];
    assign rd=ram[A[31:2]];
    always@(posedge clk)
        if(we)
            ram[A[31:2]]<=wd;
    initial
    begin
        for(i=0;i<64;i++)
            ram[i]=32'd0;
    end
endmodule
