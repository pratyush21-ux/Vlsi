module encoder_4x2(I, Y, E, V);
    input [3:0] I;
    input E;
    output reg [1:0] Y;
    output reg V;

    always @(*) begin
        if (E) begin
            if (I[3])       
                {Y, V} = 3'b110; 
            else if (I[2])  
                {Y, V} = 3'b101; 
            else if (I[1])  
                {Y, V} = 3'b011; 
            else if (I[0])  
                {Y, V} = 3'b001; 
            else            
                {Y, V} = 3'b000; 
        end else begin
            {Y, V} = 3'b000; 
        end
    end
endmodule
      
