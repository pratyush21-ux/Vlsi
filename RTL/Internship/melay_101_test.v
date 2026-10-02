module melay_101_test;
    reg CLK, RST, din;
    wire Y;
    mealy_101 uut(Y, CLK, RST, din);
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end
    initial begin
        $monitor("din=%b,Y=%b",din,Y);
    end
    initial begin
        RST = 1; din = 0;
        #10 RST = 0;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
        din = 1; #10;
        din = 0; #10;
        din = 1; #10;
        $stop;
        $finish;
    end
endmodule

