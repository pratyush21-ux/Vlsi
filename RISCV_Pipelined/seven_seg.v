module seven_seg_with_pipeline(
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

// Signals from the processor
wire [31:0] WriteDataM_out;
wire MemWriteM_out;
wire [31:0] ALU_ResultM_out;
wire [31:0] ResultW_out;
wire RegWriteW_out;

parameter FINAL_VALUE = 16'd6765;

// Instantiate the modified pipeline processor
Pipeline_top_with_outputs processor(
    .clk(one_second_enable),
    .rst(reset),
    .WriteDataM_out(WriteDataM_out),
    .MemWriteM_out(MemWriteM_out),
    .ALU_ResultM_out(ALU_ResultM_out),
    .ResultW_out(ResultW_out),
    .RegWriteW_out(RegWriteW_out)
);

// Generate a 1-second pulse for slow processor operation
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        one_second_counter <= 0;
    else if (one_second_counter >= 49999999)  // 50MHz for 1Hz
        one_second_counter <= 0;
    else
        one_second_counter <= one_second_counter + 1;
end

assign one_second_enable = (one_second_counter == 49999999);

// Update displayed number when there's a memory write or register write
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        displayed_number <= 0;
    else if ((MemWriteM_out || RegWriteW_out) && (displayed_number != FINAL_VALUE)) begin
        // Display either memory write data or writeback result
        if (MemWriteM_out)
            displayed_number <= WriteDataM_out[15:0];
        else
            displayed_number <= ResultW_out[15:0];
    end
end

// Refresh counter for display multiplexing
always @(posedge clk_100mhz or posedge reset) begin
    if (reset)
        refresh_counter <= 0;
    else
        refresh_counter <= refresh_counter + 1;
end

assign LED_activating_counter = refresh_counter[19:18];

// Digit activation and BCD extraction
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
        default: LED_out = 7'b0000001; // 0
    endcase
end

endmodule
