module Washing_machine(
    input clk,
    input rst,
    input srt,
    output reg fill,
    output reg wash,
    output reg rinse,
    output reg spin,
    output reg done,
    output reg red,
    output reg green,
    output reg buzzer
);

    // FSM State Definitions
    reg [2:0] current_state, next_state;
    parameter Idle  = 3'b000,
              Fill  = 3'b001,
              Wash  = 3'b010,
              Rinse = 3'b011,
              Spin  = 3'b100,
              Done  = 3'b101;

    // Timer Register
    reg [3:0] timer; // 4-bit timer (max 15)

    // Duration for each stage (in clock cycles)
    parameter TIME_FILL  = 4,
              TIME_WASH  = 4,
              TIME_RINSE = 4,
              TIME_SPIN  = 4;

    // FSM state update
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= Idle;
        else
            current_state <= next_state;
    end

    // Timer control logic
    always @(posedge clk or posedge rst) begin
        if (rst)
            timer <= 0;
        else if (current_state == Idle)
            timer <= 0;
        else if (timer < 15)
            timer <= timer + 1;
        else
            timer <= 0;
    end

    // Next state logic and output control
    always @(*) begin
        // Default outputs
        fill = 0;
        wash = 0;
        rinse = 0;
        spin = 0;
        done = 0;
        red = 0;
        green = 0;
        buzzer = 0;
        next_state = current_state;

        case (current_state)
            Idle: begin
                if (srt)
                    next_state = Fill;
            end

            Fill: begin
                fill = 1;
                red = 1;
                if (timer == TIME_FILL)
                    next_state = Wash;
            end

            Wash: begin
                wash = 1;
                red = 1;
                if (timer == TIME_WASH)
                    next_state = Rinse;
            end

            Rinse: begin
                rinse = 1;
                red = 1;
                if (timer == TIME_RINSE)
                    next_state = Spin;
            end

            Spin: begin
                spin = 1;
                red = 1;
                if (timer == TIME_SPIN)
                    next_state = Done;
            end

            Done: begin
                red = 0;
                done = 1;
                green = 1;
                buzzer = 1;
                next_state = Idle; // Optional: restart cycle
            end

            default: next_state = Idle;
        endcase
    end

endmodule
