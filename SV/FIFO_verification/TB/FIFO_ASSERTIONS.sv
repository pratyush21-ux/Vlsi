module FIFO_ASSERTIONS(
    input logic clk,
    input logic rst,
    input logic wr_en,
    input logic rd_en,
    input logic [7:0] wdata,
    input logic [7:0] rdata,
    input logic full,
    input logic empty
);

property empty_after_reset;
    @(posedge clk)
    $fell(rst) |=> (empty === 1'b1);
endproperty
assert_empty_after_reset: assert property (empty_after_reset)
else $error("FIFO is not empty after reset = %b", empty);

property not_full_after_reset;
    @(posedge clk)
    $fell(rst) |=> (full === 1'b0);
endproperty
assert_not_full_after_reset: assert property (not_full_after_reset)
else $error("FIFO is full after reset = %b", full);

property full_empty_not_both;
    @(posedge clk) disable iff(rst)
    !(full && empty);
endproperty
assert_full_empty_not_both: assert property (full_empty_not_both)
else $error("Full and empty both high");

endmodule