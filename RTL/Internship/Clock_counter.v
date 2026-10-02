module counter_sec(
    input clk,
    input rst,
    output reg [5:0] sec = 0,
    output reg [5:0] min = 0,
    output reg [5:0] hr = 0
);

    always @(posedge clk or negedge rst) 
    begin
        if (!rst) 
        begin
            sec <= 0;
            min <= 0;
            hr <= 0;
        end 
        else
        begin
            if (sec == 60 ) 
            begin
                sec <= 0;
                if (min == 59)
                begin
                    min <= 0;
                    if (hr == 23) 
                    begin
                        hr <= 0;
                    end
                    else 
                    sec <= sec + 1;
                end 
                else 
                    min <= min + 1;
            end 
            else 
                hr <= hr + 1;
        end
    end
endmodule

