module Top_module(
    input clk,
    input rst,
    input [3:0] key_in,
    input enter,
    output reg locked,
    output red_light,
    output green_light,
    output alarm
);
    wire check;
    wire door_unlocked;
    wire incorrect_flag;
    reg [23:0] unlock_timer;
    reg unlock_timer_enable;
    wire temp_locked;
    Password_checker PCint(
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .enter(enter),
        .check(check),
        .door_unlocked(door_unlocked),
        .incorrect_flag(incorrect_flag)
    );
    Fsm_con fsm_con_int(
        .clk(clk),
        .rst(rst),
        .key_in(key_in),
        .enter(enter),
        .red_light(red_light),
        .green_light(green_light),
        .buzzer_alarm(alarm),
        .check(check),
        .locked(temp_locked)
    );
    parameter UNLOCK_TIME = 100;  

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            locked <= 1;
            unlock_timer <= 0;
            unlock_timer_enable <= 0;
        end else begin
            if (!temp_locked && !unlock_timer_enable) begin
                locked <= 0;
                unlock_timer_enable <= 1;
                unlock_timer <= 0;
            end

            if (unlock_timer_enable) begin
                unlock_timer <= unlock_timer + 1;

                if (unlock_timer >= UNLOCK_TIME) begin
                    locked <= 1;  
                    unlock_timer_enable <= 0;
                    unlock_timer <= 0;
                end
            end
        end
    end
endmodule
