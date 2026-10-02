`timescale 1ns/1ps
interface FIFO_INTERFACE
(
    input logic clk
);
logic rst;
logic wr_en;
logic rd_en;
logic [7:0] wdata;
logic full;
logic empty;
logic [7:0] rdata;

clocking drv_cb @(posedge clk);
    default output #1;
    output wr_en, rd_en, wdata;
endclocking

clocking mon_cb @(negedge clk);
    default input #1step;
    input full, empty, rdata;
    input wr_en, rd_en, wdata;
endclocking

modport DRV (clocking drv_cb, input clk, input rst);
modport MON (clocking mon_cb, input clk, input rst);

endinterface