`timescale 1ns / 1ps
module Clock_count1_test;
    reg clk;
    reg rst;
    wire [5:0] cn;
    wire [5:0] min;
    wire [5:0] hr;
    Clock_count1 uut (
        .cn(cn),
        .clk(clk),
        .rst(rst),
        .min(min),
        .hr(hr)
    );
initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
 initial begin
    $monitor("Time=%0t, cn=%d, min=%d, hr=%d,clk=%b, rst=%b", $time, cn, min,hr, clk, rst);
     rst = 1;
     #10 $display("hr=%d,min=%d,sec=%d",hr,min,cn);
     #60

    #10 $finish;
  end
endmodule
