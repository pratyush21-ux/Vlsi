`timescale 1ns/1ps
module Bit4_mag_comp_test;
    reg [3:0]A,B;
    wire Equal,Greater,Small;
    Bit4_mag_comp uut(.Equal(Equal),.Greater(Greater),.Small(Small),.A(A),.B(B));
    initial begin
        $monitor("Equal=%b,Greater=%b,Small=%b,A=%b,B=%b",Equal,Greater,Small,A,B);
    end
    initial begin
    $dumpfile("Magcomwave.vcd");
    $dumpvars();
  end
    initial begin
            A=4'b0000;B=4'b0000;
        #10 A=4'b0010;B=4'b0000;
        #10 A=4'b0010;B=4'b0100;
        #10 A=4'b0100;B=4'b1000;
    end 
endmodule

