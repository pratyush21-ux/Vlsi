`timescale 1ns / 1ps
module rom_4x4_async_test;
    reg [1:0] address;
    wire [3:0] data_out;
    rom_4x4_async uut (
        .data_out(data_out),
        .address(address)
    );
    initial begin
        $monitor("Time = %0t | Address = %b | Data Out = %b", $time, address, data_out);
        address = 2'b00; #10;
        address = 2'b01; #10;
        address = 2'b10; #10;
        address = 2'b11; #10;
        address = 2'b01; #10;
        address = 2'b00; #10;

        
        $finish;
    end
endmodule

