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
module counter_4bit_updown(cn, cin, clk, rst, ud, en, load);
    input clk, rst, ud, en, load;
    input [3:0] cin;
    output reg [3:0] cn;

    always @(posedge clk or negedge rst) begin
        if (!rst)
            cn <= 4'b0000;
        else if (en) 
        begin
            if (load)
                cn <= cin;
            else if (ud) 
            begin 
                if(cn==4'b1111)
                    cn<=4'b0000;
                else
                    cn <= cn + 1;
            end 
            else 

            begin 
                if(cn==4'b0000)
                    cn<=4'b1111;
                else
                    cn <= cn - 1;
            end
        end
    end
endmodule
module D_counter(input [3:0] cn_in,output reg [7:0] led_out);
    always@(*)
    begin
        case(cn_in)
            4'b0000: led_out=8'b1100000;
            4'b0001: led_out = 8'b11111001; 
            4'b0010: led_out = 8'b10100100; 
            4'b0011: led_out = 8'b10110000;             
            4'b0100: led_out = 8'b10011001; 
            4'b0101: led_out = 8'b10010010;            
            4'b0110: led_out = 8'b10000010;             
            4'b0111: led_out = 8'b11111000;             
            4'b1000: led_out = 8'b10000000;            
            4'b1001: led_out = 8'b10010000; 
        endcase
    end
endmodule
module top_counter_system(input clk100mhz,     
    input rst,           
    input ud,            
    input en,            
    input load,          
    input [3:0] cin,     
    output [7:0] led_out,
    output [3:0] an;
);
    wire clk1hz;
    wire [3:0] cn;       
    clk_divider u1 (.clk100(clk100mhz),.clk1(clk1hz));
    counter_4bit_updown u2 (.cn(cn),.cin(cin),.clk(clk1hz),.rst(rst),.ud(ud),.en(en),.load(load));
    D_counter u3 (.cn_in(cn),.led_out(led_out));
    assign an = 4'b1110;

endmodule
