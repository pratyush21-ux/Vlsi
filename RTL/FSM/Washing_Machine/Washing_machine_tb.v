`timescale 1ns / 1ps

module Washing_machine_tb;

    reg clk = 0;
    reg rst = 0;
    reg srt = 0;

    wire fill, wash, rinse, spin, done, red, green, buzzer;

    Washing_machine dut (
        .clk(clk),
        .rst(rst),
        .srt(srt),
        .fill(fill),
        .wash(wash),
        .rinse(rinse),
        .spin(spin),
        .done(done),
        .red(red),
        .green(green),
        .buzzer(buzzer)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("washing_machine.vcd");
        $dumpvars(0, Washing_machine_tb);

        rst = 1;
        #10 rst = 0;
        #10 srt = 1;
        #10 srt = 0;

        #2000 $finish;
    end

endmodule
