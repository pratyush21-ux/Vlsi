module uart_tx (
    input        clk,
    input        rst,
    input        tx_start,
    input  [7:0] tx_data,
    input        tick,
    output reg   tx,
    output reg   tx_busy
);

    reg [3:0] bit_index;
    reg [9:0] tx_buffer;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;           
            tx_busy <= 1'b0;
            bit_index <= 0;
            tx_buffer <= 10'b0;
        end else begin
            if (tx_start && !tx_busy) begin
                
                tx_buffer <= {1'b1, tx_data, 1'b0}; 
                tx_busy <= 1'b1;
                bit_index <= 0;
            end else if (tx_busy && tick) begin
                tx <= tx_buffer[bit_index];
                bit_index <= bit_index + 1;

                if (bit_index == 9) begin
                    tx_busy <= 0;
                    tx <= 1'b1;  
                end
            end
        end
    end

endmodule
