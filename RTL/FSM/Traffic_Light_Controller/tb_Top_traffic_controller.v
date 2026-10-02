`timescale 1ns / 1ps

module tb_Top_traffic_controller;

    reg clk;
    reg reset_n;

    wire NS_R, NS_Y, NS_G;
    wire EW_R, EW_Y, EW_G;

    Top_traffic_controller uut (
        .clk(clk),
        .reset_n(reset_n),
        .NS_R(NS_R),
        .NS_Y(NS_Y),
        .NS_G(NS_G),
        .EW_R(EW_R),
        .EW_Y(EW_Y),
        .EW_G(EW_G)
    );

    // 100MHz Clock (10ns)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset_n = 0;

        $dumpfile("traffic_test.vcd");
        $dumpvars(0, tb_Top_traffic_controller); // ✅ Full dump

        $display("Time\tNS_R NS_Y NS_G\tEW_R EW_Y EW_G");
        $monitor("%0t\t%b   %b   %b\t%b   %b   %b", 
                 $time, NS_R, NS_Y, NS_G, EW_R, EW_Y, EW_G);

        #100;
        reset_n = 1;

        #1000000;
        $finish;
    end
endmodule
