module ALUDecoder(
    input opb5,
    input [2:0] funct3,
    input funct7b5,
    input [1:0] ALUOp,
    output reg [3:0] ALUControl
);
wire RS;
assign RS=funct7b5 & opb5;
always @(*) begin
    case (ALUOp)
        2'b00: ALUControl = 3'b000; 
        2'b01: ALUControl = 3'b001;
        default:
        case (funct3)
                3'b000: ALUControl = (RS) ? 3'b001 : 3'b000; 
                3'b010: ALUControl = 3'b101; 
                3'b110: ALUControl = 3'b011; 
                3'b111: ALUControl = 3'b010; 
                default: ALUControl = 3'bxxx; 
            endcase
    endcase
end
endmodule