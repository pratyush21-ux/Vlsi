module Clock_divider(
    input clk100,
    input reset,
    output reg clk1hz
);
    reg [15:0] cnt; // reduced width for simulation

    always @(posedge clk100) begin
        if (reset) begin
            cnt <= 0;
            clk1hz <= 0;
        end else begin
            if (cnt == 50 - 1) begin // faster for simulation
                cnt <= 0;
                clk1hz <= ~clk1hz;
            end else begin
                cnt <= cnt + 1;
            end
        end
    end
endmodule
