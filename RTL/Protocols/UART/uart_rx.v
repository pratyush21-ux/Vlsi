module uart_rx (
    input  wire       clk,
    input  wire       rst,
    input  wire       rx,
    input  wire       tick,        
    output reg [7:0]  rx_data,
    output reg        rx_done
);

    reg [3:0] tick_count = 0;
    reg [3:0] bit_index  = 0;
    reg [7:0] data_buffer = 0;
    reg [1:0] state = 0; // 0 = idle, 1 = start, 2 = data, 3 = stop

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state       <= 0;
            tick_count  <= 0;
            bit_index   <= 0;
            data_buffer <= 0;
            rx_done     <= 0;
        end else begin
            rx_done <= 0;

            case (state)
                0: begin 
                    if (rx) begin
                        state <= 1;
                        tick_count <= 0;
                    end
                end

                1: begin 
                    if (tick) begin
                        tick_count <= tick_count + 1;
                        if (tick_count == 1) begin 
                            tick_count <= 0;
                            bit_index <= 0;
                            state <= 2;
                        end
                    end
                end

                2: begin 
                    if (tick) begin
                        data_buffer[bit_index] <= rx; // LSB first
                        bit_index <= bit_index + 1;
                        if (bit_index == 7) begin
                            state <= 3;
                            tick_count <= 0;
                        end
                    end
                end

                3: begin // Stop bit
                    if (tick) begin
                        rx_data <= data_buffer;
                        rx_done <= 1;
                        state <= 0;
                    end
                end
            endcase
        end
    end

endmodule
