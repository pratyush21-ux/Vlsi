`timescale 1ns/1ps

module Pos_latch_test;

  reg d, clk, rst;
  wire q;

  Pos_latch uut (.q(q), .d(d), .clk(clk), .rst(rst));

  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
    initial begin
    $dumpfile("Poswave.vcd");
    $dumpvars();
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

