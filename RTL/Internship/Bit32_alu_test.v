`timescale 1ns / 1ps
module Bit32_alu_tb;
    reg [31:0] A;
    reg [31:0] B;
    reg [3:0] con;
    wire [31:0] res;
    wire neg, carry, overflow, zero;
    Bit32_alu uut (
        .A(A),
        .B(B),
        .con(con),
        .res(res),
        .neg(neg),
        .carry(carry),
        .overflow(overflow),
        .zero(zero)
    );
    initial begin
        $monitor("Time=%0d A=%b B=%b con=%b res=%b carry=%b zero=%b neg=%b overflow=%b", $time, A, B, con, res, carry, zero, neg,overflow);
            A = 32'h00000005; B = 32'h00000003; con=4'b0000;
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b0001;  
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b0100;
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b0101;
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b0110; 
        #10 A = -32'hFFFFFFF8; B = 32'hFFFFFFF8; con=4'b0000;
        #10 A =  32'h7FFFFFFF; B= 32'h7FFFFFFF;con=4'b0000;
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1000; 
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1001;
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1111; 
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b0111;

        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1010; 
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1011; 
        #10 A = 32'hFFFFFFF8; B = 32'h00000004; con=4'b1100; 
        $finish;
    end
endmodule

