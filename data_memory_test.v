module data_memory_test;
    reg clk;
    reg we;
    reg [31:0] A;
    reg [31:0] wd;
    wire [31:0] rd;
    data_memory uut (
        .clk(clk),
        .we(we),
        .A(A),
        .wd(wd),
        .rd(rd)
    );
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
    initial begin 
        $monitor("rd=%b,wd=%b,we=%b,A=%b",rd,wd,we,A);
    end
    initial begin
        we = 0;
        A = 0;
        wd = 0;
        #10 we = 1; A = 32'd4; wd = 32'd50; 
        #10 we = 1; A = 32'd8; wd = 32'd100; 
        #10 we = 0; A = 32'd4; 
        #10 
        #10 A = 32'd8; 
        #10 
        #20 $finish;
    end

endmodule
