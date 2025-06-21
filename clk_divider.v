module clk_divider(clk100,clk1hz);
    input clk100;
    output clk1hz;
    reg [31:0]cnt;
    cnt=0;
    always@(posedge clk100)
        if(cnt<5000000)
            cnt<=cnt+1;
            else
            begin
                cnt<=0;
                clk1hz<=~clk1hz;
            end
endmodule
