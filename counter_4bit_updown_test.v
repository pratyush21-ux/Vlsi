`timescale 1ns/1ps


module counter_4bit_updown_test;
    reg clk, rst, ud, en, load;
    reg [3:0] cin;
    wire [3:0] cn;
   counter_4bit_updown uut (
        .cn(cn),
        .cin(cin),
        .clk(clk),
        .rst(rst),
        .ud(ud),
        .en(en),
        .load(load)
    );
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $monitor("rst=%b,en=%b,ud=%b,load=%b,cin=%b,cn=%b",rst,en,ud,load,cin,cn);
        rst=0;
        #10 rst = 1; en = 1; ud = 1; load = 0; cin = 4'b0000;
        #60
        rst=0;
        #10 rst=1;en=1;ud=0;load=1;cin=4'b1111;
        #60
        $finish;
    end


endmodule

