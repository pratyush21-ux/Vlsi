`timescale 1ns/1ps
module conter_4bit_updown_test;
    reg clk,rst,ud,en,load;
    reg [3:0]cin;
    wire [3:0]cn;
    counter_4bit_updown uut(.clk(clk),.rst(rst),.ud(ud),.en(en),.load(load),.cin(cin),.cn(cn));
    
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
    initial begin
        $monitor("rst=%b,ud=%b,en=%b,load=%b,cin=%b,cn=%b",rst,ud,en,load,cin,cn,);
    end
    initial begin
        rst=1'b1;ud=1'b1;en=1'b1;load=1'b0;cin=4'b0000;
        #20 rst=1'b1;ud=1'b1;en=1'b1;load=1'b0;cin=4'b0000;
        #20 rst=1'b1;ud=1'b1;en=1'b1;load=1'b1;cin=4'b0100;
        #20 rst=1'b0;ud=1'b1;en=1'b1;load=1'b0;cin=4'b0000;
    end
endmodule
