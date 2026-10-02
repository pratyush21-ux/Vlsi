module counter_sec(cn, cin, clk, rst,min,hr);
    input clk, rst;
    input [5:0] cin;
    output reg [5:0] cn,cn1,c2;
    output reg [5:0] min
    output reg [5:0] hr;
    reg [5:0]count,count1;
    always @(posedge clk or negedge rst) 
    begin: FOR_SEC_CLOCK
        if (!rst)
            cn <= 4'b0000;
         else
         begin
             if(cn==5'b1111)
             begin
                 cn<=5'b00000;
                 count<=5'b00001;
             end
             else
                 cn <= cn + 1;
         end
        always@(*)
        begin: FOR_MIN_CLOCK
            if(count==1)
            begin
                 if(cn1==5'b11111)
             begin
                 cn1<=5'b00000;
                 count2<=5'b00001;
             end
             else
                 cn1 <= cn1 + 1;
         end
            always@(*)
            begin:FOR_HR_CLOCK
                if(count2==1)
            begin
                 if(cn2==5'b11111)
             begin
                 cn2<=5'b00000;
             end
             else
                 cn2 <= cn2 + 1;
         end
endmodule



