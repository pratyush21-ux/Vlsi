module rom_4x4_async(data_out,address);
    input [1:0]address;
    output reg [3:0]data_out;
    reg [3:0]ROM[0:3];
    initial
    begin
        ROM[0]=4'b1110;
        ROM[1]=4'b0010;
        ROM[2]=4'b1111;
        ROM[3]=4'b0100;
    end
    always@(address)
        data_out=ROM[address];
endmodule
