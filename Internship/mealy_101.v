module traffic_light_fsm(
    input wire CLK,
    input wire RST,
    output reg [2:0] NS_light, // {R, Y, G}
    output reg [2:0] EW_light  // {R, Y, G}
);

    // FSM States
    parameter S0 = 3'b000,  // NS Green
              S1 = 3'b001,  // NS Yellow
              S4 = 3'b100,  // Red/Red for 10s
              S2 = 3'b010,  // EW Green
              S3 = 3'b011;  // EW Yellow

    reg [2:0] current_state, next_state;
    reg [2:0] from_state;
    integer timer;

    // State register
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= S0;
            timer <= 0;
        end else begin
            current_state <= next_state;
            timer <= (current_state != next_state) ? 0 : timer + 1;
        end
    end

    // Previous state tracking for S4 exit decision
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            from_state <= S0;
        end else if (next_state == S4 && current_state != S4) begin
            from_state <= current_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            S0: next_state = (timer >= 10) ? S1 : S0;
            S1: next_state = (timer >= 3)  ? S4 : S1;
            S2: next_state = (timer >= 10) ? S3 : S2;
            S3: next_state = (timer >= 3)  ? S4 : S3;
            S4: next_state = (timer >= 10) ? ((from_state == S1) ? S2 : S0) : S4;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            S0: begin
                NS_light = 3'b001; // Green
                EW_light = 3'b100; // Red
            end
            S1: begin
                NS_light = 3'b010; // Yellow
                EW_light = 3'b100; // Red
            end
            S2: begin
                NS_light = 3'b100; // Red
                EW_light = 3'b001; // Green
            end
            S3: begin
                NS_light = 3'b100; // Red
                EW_light = 3'b010; // Yellow
            end
            S4: begin
                NS_light = 3'b100; // Red
                EW_light = 3'b100; // Red (All Stop)
            end
            default: begin
                NS_light = 3'b100;
                EW_light = 3'b100;
            end
        endcase
    end

endmodule
