module fetch_cycle (
    input clk,
    input rst,
    input PCSrcE,
    input [31:0] PCTargetE,
    output [31:0] InstrD,
    output [31:0] PcPlus4D,
    output [31:0] PCD
);
    wire [31:0] PC_Next, PCF, PcPlus4F;
    wire [31:0] InstrF;
    reg [31:0] InstrF_reg, PCF_reg, PcPlus4F_reg;

    // PC selection mux
    PC_Mux Mux_Pc(
        .PC_Target(PCTargetE),
        .PC_Plus_4(PcPlus4F),
        .PCSrc(PCSrcE),
        .PC_Next(PC_Next)
    );

    // Program counter register
    PC Program_counter(
        .PCNext(PC_Next),
        .reset(rst),
        .clk(clk),
        .Pc(PCF)
    );

    // Instruction memory
    Instruction_Memory I_M(
        .address(PCF),
        .data(InstrF)
    );

    // PC + 4 adder
    Pc_Plus_4 P4(
        .Pc(PCF),
        .PCPlus4(PcPlus4F)
    );

    // Pipeline registers (IF/ID)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            InstrF_reg   <= 32'h00000000;
            PCF_reg      <= 32'h00000000;
            PcPlus4F_reg <= 32'h00000000;
        end else begin
            InstrF_reg   <= InstrF;
            PCF_reg      <= PCF;
            PcPlus4F_reg <= PcPlus4F;
        end
    end

    assign InstrD   = rst ? 32'h00000000 : InstrF_reg;
    assign PCD      = rst ? 32'h00000000 : PCF_reg;
    assign PcPlus4D = rst ? 32'h00000000 : PcPlus4F_reg;
endmodule
