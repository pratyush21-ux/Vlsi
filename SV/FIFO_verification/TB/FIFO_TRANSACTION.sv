class FIFO_TRANSACTION;
rand logic wr_en;
rand logic rd_en;
rand logic [7:0] wdata;
logic [7:0] rdata;
logic full;
logic empty;

// at least one op per cycle; simultaneous read+write allowed
constraint one_op
{
    (wr_en || rd_en);
}
constraint write_bias
{
    wr_en dist {1 := 70, 0 := 30};
}

function void display(string tag = "Transaction");
    $display("[%s] wr_en=%0b rd_en=%0b wdata=0x%02h | rdata=0x%02h full=%0b empty=%0b",
             tag, wr_en, rd_en, wdata, rdata, full, empty);
endfunction

function FIFO_TRANSACTION do_copy();
    FIFO_TRANSACTION copy = new();
    copy.wr_en = this.wr_en;
    copy.rd_en = this.rd_en;
    copy.wdata = this.wdata;
    copy.rdata = this.rdata;
    copy.full  = this.full;
    copy.empty = this.empty;
    return copy;
endfunction

endclass