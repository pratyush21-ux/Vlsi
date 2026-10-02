module Main_Decoder(op,RegWrite,ImmSrc,ALUSrc,MemWrite,ResultSrc,Branch,ALUop,Jump);
    input [6:0]op;
    output reg RegWrite,ALUSrc,MemWrite,Branch,Jump;
    output reg [1:0]ImmSrc,ResultSrc,ALUop;
    always@(*)
    begin 
        case(op)
            7'b000_000_0:
                begin
                    RegWrite=1'b0;ImmSrc=2'b00;ALUSrc=1'b0;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b00;Jump=1'b0;
                 end
            7'b000_001_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite=1'b0;ResultSrc=2'b01;Branch=1'b0;ALUop=2'b00;Jump=1'b0;
                end

            7'b010_001_1:
                begin
                    RegWrite=1'b0;ImmSrc=2'b01;ALUSrc=1'b1;MemWrite=1'b1;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b00;Jump=1'b0;
                end

            7'b011_001_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'bxx;ALUSrc=1'b0;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b10;Jump=1'b0;
                end

            7'b001_001_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b10;Jump=1'b0;
                end

            7'b110_001_1:
                begin
                    RegWrite=1'b0;ImmSrc=2'b10;ALUSrc=1'b0;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b1;ALUop=2'b01;Jump=1'b0;
                end

            7'b110_111_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b11;ALUSrc=1'b0;MemWrite=1'b0;ResultSrc=2'b10;Branch=1'b0;ALUop=2'b00;Jump=1'b1;
                end

            7'b110_011_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite=1'b0;ResultSrc=2'b10;Branch=1'b0;ALUop=2'b00;Jump=1'b1;
                end

            7'b011_011_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b11;Jump=1'b0;
                end

            7'b001_011_1:
                begin
                    RegWrite=1'b1;ImmSrc=2'b00;ALUSrc=1'b1;MemWrite=1'b0;ResultSrc=2'b00;Branch=1'b0;ALUop=2'b01;Jump=1'b0;
                end
        endcase
    end
endmodule