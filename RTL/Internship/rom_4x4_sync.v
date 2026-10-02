module rom_4x4_sync(data_out,address,clock);
    input [1:0]address;
    input clk;
    output reg [3:0]data_out;
    initial 
    begin
        ROM[0]=4'b1110;
        ROM[1]=4'b0010;
        ROM[2]=4'b1111;
        ROM[3]=4'b0100;
    end 
    always@(posedge clk)
        data_out=ROM[address];
endmodule
