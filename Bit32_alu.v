module Bit32_alu(
    input [31:0] A,
    input [31:0] B,
    input [3:0] con,
    output reg [31:0] res,
    output reg neg,
    output reg carry,
    output reg overflow,
    output reg zero
);
    wire slt = (A[31] == B[31]) ? (A < B) : A[31];
    wire sltu = (A < B);
    reg [32:0] temp;
    always @(*) 
    begin
        case (con)
            4'b0000: 
                begin
                temp = A + B;
                res = temp[31:0];
                carry = temp[32];
                overflow = (~(A[31] ^ B[31])) & (A[31] ^ res[31]);
            end
            4'b0001: begin
                temp = A - B;
                res = temp[31:0];
                carry = temp[32];
                overflow = (A[31] ^ B[31]) & (A[31] ^ res[31]);
            end
            4'b0010: res = A & B;
            4'b0011: res = A | B;
            4'b0100: res = A ^ B;
            4'b0101: res = {31'b0, slt};
            4'b0110: res = {31'b0, sltu};
            4'b0111: res = {A[31:12], 12'b0};
            4'b1000: res = A + {B[31:12], 12'b0};
            4'b1001: res = {B[31:12], 12'b0};
            4'b1010: res = A << B;
            4'b1011: res = A >>> B;
            4'b1100: res = A >> B;
            default: res = 32'bx;
        endcase
        zero = (res == 0);
        neg = res[31];
    end
endmodule

