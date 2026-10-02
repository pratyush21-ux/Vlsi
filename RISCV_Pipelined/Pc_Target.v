module Pc_Target(
    input [31:0] Pc,
    input [31:0] ImmExt,
    output [31:0] PcTarget
);
    assign PcTarget=Pc+ImmExt;
endmodule
