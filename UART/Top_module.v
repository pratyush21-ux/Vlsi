module Top_UART_Loopback(
    input clk,
    input rst,
    output tx,             
    output [7:0] rx_data,  
    output rx_done         
);

    wire tick;
    wire tx_busy;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'b11000001; 
    Baud_generator #(
        .clk_feq(50000000),
        .baud_rate(9600)
    ) bg (
        .clk(clk),
        .rst(rst),
        .tick(tick)
    );
    uart_tx tx_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tick(tick),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    uart_rx rx_inst (
        .clk(clk),
        .rst(rst),
        .rx(tx),
        .tick(tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );
    reg [3:0] state = 0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx_start <= 0;
            state <= 0;
        end else begin
            case (state)
                0: if (!tx_busy) begin
                    tx_start <= 1; 
                    state <= 1;
                end
                1: begin
                    tx_start <= 0; 
                    state <= 2;
                end
                default: ;
            endcase
        end
    end

endmodule
