module Fsm_con(
    input clk,
    input rst,
    input [3:0] key_in,
    input enter,
    output reg red_light,
    output reg green_light,
    output reg buzzer_alarm,
    output reg check,
    output reg locked
);
    wire door_unlocked;
    wire incorrect_flag;

    reg [2:0] current_state, next_state;
    reg [1:0] digit_count;

    // FSM States
    parameter IDLE        = 3'b000;
    parameter INPUT_WAIT  = 3'b001;
    parameter CHECKING    = 3'b010;
    parameter WAIT_RESULT = 3'b011;
    parameter UNLOCKED    = 3'b100;
    parameter ALARM       = 3'b101;

    // Instantiate Password Checker
    Password_checker pw_inst (
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .enter(enter),
        .check(check),
        .door_unlocked(door_unlocked),
        .incorrect_flag(incorrect_flag)
    );

    // State & digit counter logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= IDLE;
            digit_count <= 0;
        end else begin
            current_state <= next_state;
            if (current_state == INPUT_WAIT && enter)
                digit_count <= digit_count + 1;
            else if (current_state == IDLE)
                digit_count <= 0;
        end
    end

    // FSM combinational logic
    always @(*) begin
        // Default output values
        red_light = 1;
        green_light = 0;
        buzzer_alarm = 0;
        locked = 1;
        check = 0;

        next_state = current_state;

        case (current_state)
            IDLE: begin
                if (enter)
                    next_state = INPUT_WAIT;
            end

            INPUT_WAIT: begin
                if (digit_count == 3 && !enter)
                    next_state = CHECKING;
            end

            CHECKING: begin
                check = 1;
                next_state = WAIT_RESULT;
            end

            WAIT_RESULT: begin
                if (door_unlocked)
                    next_state = UNLOCKED;
                else if (incorrect_flag)
                    next_state = ALARM;
                else
                    next_state = INPUT_WAIT; // allow retry
            end

            UNLOCKED: begin
                red_light = 0;
                green_light = 1;
                locked = 0;
                next_state = IDLE;
            end

            ALARM: begin
                buzzer_alarm = 1;
                red_light = 1;
                green_light = 0;
                next_state = IDLE;
            end
        endcase
    end
endmodule
