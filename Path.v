module Path(
    input [7:0] inA, inB,
    input clk, rst,
    input s,
    input [3:0] op,
    output reg [8:0] y
);
    // Mux output
    wire [7:0] mux_out;
    assign mux_out = s ? inA : inB;
    // Flip-Flop 1
    reg [7:0] q;
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 8'b0;
        else
            q <= mux_out;
    end
    // Flip-Flop 2
    reg [7:0] q1;
    always @(posedge clk or posedge rst) begin
        if (rst)
            q1 <= 8'b0;
        else
            q1 <= inB;
    end
    // ALU
    reg [7:0] y1;
    reg flag;
    always @(*) begin
        case(op)
            4'b0000: {flag, y1} = q + q1;
            4'b0001: {flag, y1} = q - q1;
            4'b0010: y1 = q & q1;
            4'b0011: y1 = q | q1;
            4'b0100: y1 = q ^ q1;
            4'b0101: y1 = ~(q ^ q1);
            4'b0110: y1 = ~q;
            4'b0111: y1 = q >> q1;
            4'b1000: y1 = q << q1;
            default: y1 = 8'bz;
        endcase
    end
    always @(*) begin
        if (op == 4'b0000 || op == 4'b0001)
            y = {flag, y1};
        else
            y = {1'b0, y1};
    end
endmodule

