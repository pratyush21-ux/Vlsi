module Pc_Plus_4(
    input [31:0] Pc,
    output [31:0] PCPlus4
);
    assign PCPlus4 = Pc + 32'd4;
endmodule