module seven_seg(
    input clk_100mhz,
    input reset,
    output reg [3:0] Anode_Activate,
    output reg [6:0] LED_out
);

reg [26:0] one_second_counter; 
wire one_second_enable;
reg [15:0] displayed_number;
reg [3:0] LED_BCD;
reg [19:0] refresh_counter;
wire [1:0] LED_activating_counter;
wire [31:0] result;
wire MemWrite;  // <-- New wire for MemWrite

parameter FINAL_VALUE = 16'd6765;  // 6765 in decimal

// Instantiate your RISC-V processor
single_cycle_top tt01(
    .clk(one_second_enable),
    .reset(reset),
    .WriteData(result),
    .MemWrite(MemWrite)
);

// Generate a 1-second pulse for slow update
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        one_second_counter <= 0;
    else if (one_second_counter >= 64999999)
        one_second_counter <= 0;
    else
        one_second_counter <= one_second_counter + 1;
end

assign one_second_enable = (one_second_counter == 64999999);

// Update the displayed number **only when MemWrite is high and displayed_number != 6765**
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        displayed_number <= 0;
    else if (MemWrite && (displayed_number != FINAL_VALUE))
        displayed_number <= result[15:0];  // Use lower 16 bits for display
end

// Refresh counter for multiplexing the 4-digit display
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        refresh_counter <= 0;
    else
        refresh_counter <= refresh_counter + 1;
end

assign LED_activating_counter = refresh_counter[19:18];

// Activate one digit at a time and set BCD value accordingly
always @(*) begin
    case (LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111;
            LED_BCD = displayed_number / 1000;
        end
        2'b01: begin
            Anode_Activate = 4'b1011;
            LED_BCD = (displayed_number % 1000) / 100;
        end
        2'b10: begin
            Anode_Activate = 4'b1101;
            LED_BCD = ((displayed_number % 1000) % 100) / 10;
        end
        2'b11: begin
            Anode_Activate = 4'b1110;
            LED_BCD = ((displayed_number % 1000) % 100) % 10;
        end
    endcase
end

// BCD to seven-segment decoder
always @(*) begin
    case (LED_BCD)
        4'd0: LED_out = 7'b0000001; // 0
        4'd1: LED_out = 7'b1001111; // 1
        4'd2: LED_out = 7'b0010010; // 2
        4'd3: LED_out = 7'b0000110; // 3
        4'd4: LED_out = 7'b1001100; // 4
        4'd5: LED_out = 7'b0100100; // 5
        4'd6: LED_out = 7'b0100000; // 6
        4'd7: LED_out = 7'b0001111; // 7
        4'd8: LED_out = 7'b0000000; // 8
        4'd9: LED_out = 7'b0000100; // 9
        default: LED_out = 7'b0000001; // 0 (default)
    endcase
end

endmodule
