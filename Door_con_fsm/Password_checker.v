module Password_checker (
    input clk,
    input rst,
    input [3:0] key_in,
    input enter,
    input check,
    output reg door_unlocked,
    output reg incorrect_flag
);

    reg [3:0] password [3:0];
    reg [3:0] entered_password [3:0];
    reg [1:0] idx; // input index
    reg [1:0] attempts;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            password[0] <= 4'd2;
            password[1] <= 4'd2;
            password[2] <= 4'd3;
            password[3] <= 4'd4;

            idx <= 0;
            attempts <= 0;
            incorrect_flag <= 0;
            door_unlocked <= 0;
            entered_password[0] <= 0;
            entered_password[1] <= 0;
            entered_password[2] <= 0;
            entered_password[3] <= 0;
        end else begin
            // Enter digits
            if (enter && idx < 4) begin
                entered_password[idx] <= key_in;
                idx <= idx + 1;
            end

            // Check when all digits entered
            if (check) begin
                if (entered_password[0] == password[0] &&
                    entered_password[1] == password[1] &&
                    entered_password[2] == password[2] &&
                    entered_password[3] == password[3]) begin
                        door_unlocked <= 1;
                        incorrect_flag <= 0;
                        attempts <= 0;
                end else begin
                    door_unlocked <= 0;
                    attempts <= attempts + 1;
                    incorrect_flag <= (attempts == 2);
                end
                entered_password[0] <= 0;
                entered_password[1] <= 0;
                entered_password[2] <= 0;
                entered_password[3] <= 0;
                idx <= 0;
            end
        end
    end
endmodule
