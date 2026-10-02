module Baud_generator #(
    parameter clk_feq = 50000000,
    parameter baud_rate = 9600
)(
    input clk,
    input rst,
    output reg tick
);
    localparam integer count_max = clk_feq / baud_rate;

    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            tick <= 0;
        end 
        else begin
            if (count == (count_max / 2)) begin
                tick <= 1;
            end else begin
                tick <= 0;
            end
            if (count >= count_max) begin
                count <= 0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule
