class FIFO_COVERAGE;
mailbox #(FIFO_TRANSACTION) mon2cov;
virtual FIFO_INTERFACE vif;

logic wr_en;
logic rd_en;
logic [7:0] wdata;
logic [7:0] rdata;
logic full;
logic empty;

covergroup cg_txn;
    cp_empty: coverpoint empty {
        bins not_empty = {0};
        bins is_empty  = {1};
    }
    cp_full: coverpoint full {
        bins not_full = {0};
        bins is_full  = {1};
    }
    cp_wdata: coverpoint wdata {
        bins zero    = {8'h00};
        bins low     = {[8'h01:8'h3F]};
        bins middle  = {[8'h40:8'h7F]};
        bins high    = {[8'h80:8'hFE]};
        bins all_one = {8'hFF};
    }
    cp_op: coverpoint {wr_en, rd_en} {
        bins idle       = {2'b00};
        bins write_only = {2'b10};
        bins read_only  = {2'b01};
        bins simul      = {2'b11};
    }
    cross_op_full  : cross cp_op, cp_full;
    cross_op_empty : cross cp_op, cp_empty;
endgroup

covergroup cg_fifo_state;
    cp_full_trans: coverpoint full {
        bins became_full     = (0 => 1);
        bins no_longer_full  = (1 => 0);
    }
    cp_empty_trans: coverpoint empty {
        bins became_empty    = (0 => 1);
        bins no_longer_empty = (1 => 0);
    }
endgroup

function new(mailbox #(FIFO_TRANSACTION) mon2cov, virtual FIFO_INTERFACE vif);
    this.mon2cov = mon2cov;
    this.vif = vif;
    cg_txn = new();
    cg_fifo_state = new();
endfunction

task run();
    FIFO_TRANSACTION tx;
    forever begin
        mon2cov.get(tx);
        wr_en = tx.wr_en;
        rd_en = tx.rd_en;
        wdata = tx.wdata;
        rdata = tx.rdata;
        full  = tx.full;
        empty = tx.empty;
        cg_txn.sample();
        cg_fifo_state.sample();
    end
endtask

function void report();
    $display("Transaction coverage = %0.2f %%", cg_txn.get_coverage());
    $display("FIFO state coverage  = %0.2f %%", cg_fifo_state.get_coverage());
endfunction

endclass