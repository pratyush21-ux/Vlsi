module tb_fir_filter;
    reg clk, rst;
    reg [7:0] x_in;
    wire [15:0] y_out;

    Fir_filter dut (
        .clk(clk),
        .rst(rst),
        .x_in(x_in),
        .y_out(y_out)
    );

    always #5 clk = ~clk;

    initial begin
        $display("Time\tclk\tx_in\ty_out");
        $monitor("%0t\t%b\t%d\t%d", $time, clk, x_in, y_out);

        clk = 0;
        rst = 1;
        x_in = 0;

        #10 rst = 0;

        x_in = 8'd1; #10;
        x_in = 8'd2; #10;
        x_in = 8'd3; #10;
        x_in = 8'd4; #10;
        x_in = 8'd5; #10;
        x_in = 8'd6; #10;
        x_in = 8'd0; #20;

        $finish;
    end
    initial begin
        $dumpfile("tb_fir_filter.vcd");
        $dumpvars(0, tb_fir_filter);
    end
endmodule
