`timescale 1ns/1ps

module decoder_2x4_test;

    reg [1:0] I;
    reg E;
    wire [3:0] Y;
    decoder_2x4 uut (
        .I(I),
        .E(E),
        .Y(Y)
    );
    initial begin
        $monitor("Time = %0t | En = %b | I = %b | Y = %b", $time, E, I, Y);
        E = 0; I = 2'b00; #10;
        I = 2'b01; #10;
        I = 2'b10; #10;
        I = 2'b11; #10;

        E = 1; I = 2'b00; #10;
        I = 2'b01; #10;
        I = 2'b10; #10;
        I = 2'b11; #10;

        $finish;
    end
endmodule

