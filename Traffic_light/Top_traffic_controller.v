module Top_traffic_controller(
    input wire clk,
    input wire reset_n,
    output wire NS_R,
    output wire NS_Y,
    output wire NS_G,
    output wire EW_R,
    output wire EW_Y,
    output wire EW_G
);
    wire clk1hz;
    wire rst = ~reset_n;

    wire [2:0] ns_light;
    wire [2:0] ew_light;

    Clock_divider clkdiv_inst (
        .clk100(clk),
        .reset(rst),
        .clk1hz(clk1hz)
    );

    Traffic_light_con fsm_inst (
        .clk(clk1hz),
        .rst(rst),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    assign NS_R = ns_light[2];
    assign NS_Y = ns_light[1];
    assign NS_G = ns_light[0];

    assign EW_R = ew_light[2];
    assign EW_Y = ew_light[1];
    assign EW_G = ew_light[0];
endmodule
