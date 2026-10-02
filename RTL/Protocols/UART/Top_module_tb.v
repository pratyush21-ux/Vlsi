`timescale 1ns/1ps

module Top_UART_Loopback_tb;

    reg clk = 0;
    reg rst = 1;
    wire tx;
    wire [7:0] rx_data;
    wire rx_done;

    // Displayable ASCII character (for $monitor workaround)
    reg [7:0] char_disp;

    // Instantiate the Top Module
    Top_UART_Loopback uut (
        .clk(clk),
        .rst(rst),
        .tx(tx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Generate 50 MHz clock => 20 ns period
    always #10 clk = ~clk;

    // Update char_disp for display
    

    initial begin
        $display("===== UART LOOPBACK TEST START =====");

        $dumpfile("uart_loopback.vcd");
        $dumpvars(0, Top_UART_Loopback_tb);
        $dumpvars(1, uut);

        // Now safe for Icarus Verilog and others
        $monitor("Time=%0t ns | TX=%b | RX_DONE=%b | RX_DATA=%b ",
                 $time, tx, rx_done, rx_data);

        // Hold reset for 30 ns
        #30 rst = 0;

        // Run long enough for transmission + reception
        #2000000; // ~2 ms at 9600 baud

        $display("===== UART LOOPBACK TEST END =====");
        $finish;
    end

endmodule
