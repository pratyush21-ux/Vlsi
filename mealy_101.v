module mealy_101(output reg Y, input wire CLK, RST, din);
    reg [1:0] current_state, next_state;
    parameter S0 = 2'b00, 
              S1 = 2'b01, 
              S2 = 2'b10;
    always@(posedge CLK or posedge RST) begin
        if (RST)
            current_state <= S0;
        else
            current_state <= next_state;
    end
    always@(current_state or din) 
    begin
        case (current_state)
            S0: if (din) 
                    next_state = S1; 
                else
                    next_state = S0;
            S1: if (din==0) 
                    next_state = S2; 
                else 
                    next_state = S1;
            S2: if (din) 
                    next_state = S0; 
                else 
                    next_state = S2;
            default: next_state = current_state;
        endcase
    end
    always @(current_state or din) 
    begin
        case (current_state)
            S0: Y = 0;
            S1: Y = 0;
            S2: if (din) 
                     Y = 1; 
                else 
                     Y = 0;
            default: Y = 0;
        endcase
    end
endmodule

