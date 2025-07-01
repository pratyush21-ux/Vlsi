module seg7_control(
    input clk_100MHz,
    input reset,
    input [3:0] ones,
    input [3:0] tens,
    input [3:0] hundreds,
    input [3:0] thousands,
    output reg [0:6] seg,       // segment pattern 0-9
    output reg [3:0] digit      // digit select signals
    );
    
    // Parameters for segment patterns
    parameter ZERO  = 7'b000_0001;  // 0
    parameter ONE   = 7'b100_1111;  // 1
    parameter TWO   = 7'b001_0010;  // 2 
    parameter THREE = 7'b000_0110;  // 3
    parameter FOUR  = 7'b100_1100;  // 4
    parameter FIVE  = 7'b010_0100;  // 5
    parameter SIX   = 7'b010_0000;  // 6
    parameter SEVEN = 7'b000_1111;  // 7
    parameter EIGHT = 7'b000_0000;  // 8
    parameter NINE  = 7'b000_0100;  // 9
    parameter A = 7'b000_1000;  // A
    parameter B = 7'b110_0000;  // B
    parameter C = 7'b011_0001;  // C
    parameter D = 7'b100_0010;  // D
    parameter E = 7'b011_0000;  // E
    parameter F = 7'b011_1000;  // F
    // To select each digit in turn
    reg [1:0] digit_select;     // 2 bit counter for selecting each of 4 digits
    reg [16:0] digit_timer;     // counter for digit refresh
    // Logic for controlling digit select and digit time
    always @(posedge clk_100MHz or negedge reset) begin
        if(reset==1'b0) begin
            digit_select <= 0;
            digit_timer <= 0; 
        end
        else                                                   
            if(digit_timer == 99_999) begin                        
                digit_timer <= 0;                   
                digit_select <=  digit_select + 1;
            end
            else
                digit_timer <=  digit_timer + 1;
    end
    // Logic for driving the 4 bit anode output based on digit select
    always @(digit_select) 
    begin
        case(digit_select) 
            2'b00 : digit = 4'b1110;   // Turn on ones digit
            2'b01 : digit = 4'b1101;   // Turn on tens digit
            2'b10 : digit = 4'b1011;   // Turn on hundreds digit
            2'b11 : digit = 4'b0111;   // Turn on thousands digit
        endcase
    end
    
    // Logic for driving segments based on which digit is selected and the value of each digit
    always @*
        case(digit_select)
            2'b00 : begin       // ONES DIGIT
                        case(ones)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F;
                        endcase
                    end
               
            2'b01 : begin       // TENS DIGIT
                        case(tens)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F;
                        endcase
                    end
                    
            2'b10 : begin       // HUNDREDS DIGIT
                        case(hundreds)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F;
                        endcase
                    end
                    
            2'b11 : begin       
                        case(thousands)
                            4'b0000 : seg = ZERO;
                            4'b0001 : seg = ONE;
                            4'b0010 : seg = TWO;
                            4'b0011 : seg = THREE;
                            4'b0100 : seg = FOUR;
                            4'b0101 : seg = FIVE;
                            4'b0110 : seg = SIX;
                            4'b0111 : seg = SEVEN;
                            4'b1000 : seg = EIGHT;
                            4'b1001 : seg = NINE;
                            4'b1010 : seg = A;
                            4'b1011 : seg = B;
                            4'b1100 : seg = C;
                            4'b1101 : seg = D;
                            4'b1110 : seg = E;
                            4'b1111 : seg = F;
                        endcase
                    end
        endcase
endmodule
module Clock_count1(cn, clk, rst, min, hr);
    input clk, rst;
    output reg [5:0] cn;
    output reg [5:0] min;
    output reg [5:0] hr;
    reg [5:0] count_min;
    reg [5:0] count_hr;
    always @(posedge clk or negedge rst) 
    begin : FOR_SEC_CLOCK
        if (!rst) 
        begin
            cn <= 6'b000000;
            count_min <= 6'b000000;
        end
       else 
       begin
            if (cn == 6'd59) 
            begin
                cn <= 6'b000000;
               count_min <= 6'b000001;
            end 
            else 
            begin
                cn <= cn + 1;
                count_min <= 6'b000000;
            end
        end
    end
    always @(posedge clk or negedge rst) 
    begin : FOR_MIN_CLOCK
        if (!rst) 
        begin
            min <= 6'b000000;
            count_hr <= 6'b000000;
        end 
        else if (count_min == 6'b000001) 
        begin
            if (min == 6'd59) 
            begin
                min <= 6'b000000;
                count_hr <= 6'b000001;
            end 
            else 
            begin
                min <= min + 1;
                count_hr <= 6'b000000;
            end
        end
    end
    always @(posedge clk or negedge rst)
    begin : FOR_HR_CLOCK
        if (!rst) 
        begin
            hr <= 6'b000000;
        end
        else if (count_hr == 6'b000001) 
        begin
            if (hr == 6'd23) 
            begin
                hr <= 6'b000000;
            end 
            else
            begin
                hr <= hr + 1;
            end
        end
    end
endmodule
module clk_divider(clk100,clk1hz);

    input clk100;
    output reg clk1hz;
    reg [31:0]cnt;
    
    always@(posedge clk100)
        if(cnt<5000000)
            cnt<=cnt+1;
            else
            begin
                cnt<=0;
                clk1hz<=~clk1hz;
            end
endmodule
module top_clock(
    input clk_100MHz,
    input reset,
    output [0:6] seg,
    output [3:0] digit
    );
    wire clk_1Hz;
    wire [5:0] sec, min, hr;
    clk_divider U1 (.clk100(clk_100MHz), .clk1hz(clk_1Hz));
    Clock_count1 U2 (.cn(sec), .clk(clk_1Hz), .rst(reset), .min(min), .hr(hr));
    wire [3:0] ones_digit_sec = sec % 10;
    wire [3:0] tens_digit_sec = sec / 10;
    wire [3:0] ones_digit_min = min % 10;
    wire [3:0] tens_digit_min = min / 10;
    seg7_control U3 (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .ones(ones_digit_sec),
        .tens(tens_digit_sec),
        .hundreds(ones_digit_min),
        .thousands(tens_digit_min),
        .seg(seg),
        .digit(digit)
    );
endmodule



