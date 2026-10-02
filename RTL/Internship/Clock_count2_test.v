`timescale 1ns / 1ps
module Clock_count2_test;
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
    always #5 clk = ~clk;
    initial 
    begin
       
        clk = 0;
        rst = 0;
        #10
        rst = 1;
       
        #37000
        $finish;
    end
    initial begin
        $monitor("Time: %0t | Seconds: %0d | Minutes: %0d | Hours: %0d", $time, cn, min, hr);
    end
endmodule
