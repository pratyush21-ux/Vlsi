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
