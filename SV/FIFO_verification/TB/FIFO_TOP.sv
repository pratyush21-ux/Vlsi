`timescale 1ns/1ps
`include "FIFO_TRANSACTION.sv"
`include "FIFO_GENERATOR.sv"
`include "FIFO_DRIVER.sv"
`include "FIFO_MONITOR.sv"
`include "FIFO_SCOREBOARD.sv"
`include "FIFO_COVERAGE.sv"
`include "FIFO_ENVIRONMENT.sv"

module FIFO_TOP;
logic clk;
initial clk = 0;
always #5 clk = ~clk;

FIFO_INTERFACE fif(clk);

fifo dut (
    .clk(clk),
    .rst(fif.rst),
    .wr_en(fif.wr_en),
    .rd_en(fif.rd_en),
    .wdata(fif.wdata),
    .rdata(fif.rdata),
    .full(fif.full),
    .empty(fif.empty)
);

bind fifo FIFO_ASSERTIONS dut_assert(
    .clk(clk),
    .rst(rst),
    .wr_en(wr_en),
    .rd_en(rd_en),
    .wdata(wdata),
    .rdata(rdata),
    .full(full),
    .empty(empty)
);

FIFO_ENVIRONMENT env;
string test_name = "random";
int num_txn = 200;

initial begin
    $display("FIFO VERIFICATION TESTBENCH (with Assertions + Cov)");
    if ($value$plusargs("TESTNAME=%s", test_name))
        $display("[TOP] Running test from command line: %s", test_name);
    if ($value$plusargs("NUMTXN=%d", num_txn))
        $display("[TOP] Number of transactions from command line: %0d", num_txn);
    env = new(fif, num_txn, test_name);
    env.test();
    $finish;
end

initial begin
    #1_000_000;
    $display("Forcing finish.");
    $finish;
end

endmodule