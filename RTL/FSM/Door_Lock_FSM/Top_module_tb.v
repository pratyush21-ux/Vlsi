`timescale 1ns / 1ps

module Top_module_tb;

    reg clk;
    reg rst;
    reg [3:0] key_in;
    reg enter;
    wire locked;
    wire red_light;
    wire green_light;
    wire alarm;

    Top_module uut (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .enter(enter),
        .locked(locked),
        .red_light(red_light),
        .green_light(green_light),
        .alarm(alarm)
    );

    always #5 clk = ~clk;

    task enter_digit(input [3:0] digit);
        begin
            key_in = digit;
            enter = 1;
            #10;
            enter = 0;
            #40;
        end
    endtask

    initial begin
        $dumpfile("Top_module_tb.vcd");
        $dumpvars(0, Top_module_tb);

        clk = 0;
        rst = 1;
        key_in = 0;
        enter = 0;

        #20;
        rst = 0;
        #50;
        $display("----------------------------------------------");
        $display("Starting Password Entry at time = %t", $time);
        $display("----------------------------------------------");
        enter_digit(4'd2);
        enter_digit(4'd2);
        enter_digit(4'd3);
        enter_digit(4'd4);
        #1000;
        if (!locked)
        begin
            $display("----------------------------------------------");
            $display(" Door unlocked successfully at time = %t", $time);
            $display("----------------------------------------------");
        end
        else
        begin
            $display("----------------------------------------------");
            $display(" Door did not unlock!");
            $display("----------------------------------------------");
        end

        #5_000_000;
        #100;

        if (locked)
        begin
        $display("----------------------------------------------");
            $display(" Door auto-locked again at time = %t", $time);
            $display("----------------------------------------------");
        end
        else
            $display(" Door is still unlocked!");

        $finish;
    end
    

endmodule
