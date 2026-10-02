`timescale 1ns/1ps

module dff_Ne_Ar_test;

  reg d, clk, rst;
  wire q;

  dff_Ne_Ar uut (.q(q), .d(d), .clk(clk), .rst(rst));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  initial begin
    $monitor("Time=%0t, q=%b, d=%b, clk=%b, rst=%b", $time, q, d, clk, rst);
    d = 0; rst = 1;
    #12 rst = 0; d = 1;
    #10 d = 0;
    #10 d = 1;
    #10 rst = 1;
    #5  rst = 0;
    #10 d = 0;
    #10 $finish;
  end

endmodule   
