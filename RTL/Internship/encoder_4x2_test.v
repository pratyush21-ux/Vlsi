`timescale 1ns/1ps

module encoder_4x2_test;

    reg [3:0] I;
    reg E;
    wire [1:0] Y;
    wire V;

    encoder_4x2 uut (
        .I(I),
        .Y(Y),
        .V(V),
        .E(E)
    );

    initial begin
        $monitor("Time = %0t | En = %b | I = %b | Y = %b | V = %b", $time, E, I, Y, V);

        E = 0; I = 4'b0001; #10;
        I = 4'b0010; #10;

        E = 1; I = 4'b0001; #10;
        I = 4'b0010; #10;
        I = 4'b0100; #10;
        I = 4'b1000; #10;

        I = 4'b0000; #10;

        $finish;
    end
endmodule

