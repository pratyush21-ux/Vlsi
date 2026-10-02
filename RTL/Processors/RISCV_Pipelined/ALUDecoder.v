module ALUDecoder(
    input opb5,
    input [2:0] funct3,
    input funct7b5,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl
);
    wire RS;
    assign RS = funct7b5 & opb5;
    
    always @(*) begin
        case (ALUOp)
            2'b00: ALUControl = 4'b0000; 
            2'b01: ALUControl = 4'b0001;
            default: begin
                case (funct3)
                    3'b000: ALUControl = (RS) ? 4'b0001 : 4'b0000; 
                    3'b010: ALUControl = 4'b0101; 
                    3'b110: ALUControl = 4'b0011; 
                    3'b111: ALUControl = 4'b0010; 
                    default: ALUControl = 4'b1111; 
                endcase
            end
        endcase
    end
endmodule
