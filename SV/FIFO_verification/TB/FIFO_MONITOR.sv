class FIFO_MONITOR;
virtual FIFO_INTERFACE vif;
mailbox #(FIFO_TRANSACTION)mon2scb;
mailbox #(FIFO_TRANSACTION)mon2cov;
int mon_count=0;

function new
(
    virtual FIFO_INTERFACE vif,
    mailbox #(FIFO_TRANSACTION)mon2scb,
    mailbox #(FIFO_TRANSACTION)mon2cov
);
this.vif=vif;
this.mon2scb=mon2scb;
this.mon2cov=mon2cov;
endfunction

task run();
FIFO_TRANSACTION tx;
wait(vif.rst===1'b0);

forever begin 
    @(vif.mon_cb);
    tx=new();
    tx.wr_en=vif.mon_cb.wr_en;
    tx.rd_en=vif.mon_cb.rd_en;
    tx.wdata=vif.mon_cb.wdata;
    tx.full=vif.mon_cb.full;
    tx.empty=vif.mon_cb.empty;
    tx.rdata=vif.mon_cb.rdata;
    tx.display("MONITOR");
    mon2scb.put(tx.do_copy());
    mon2cov.put(tx.do_copy());
    mon_count++;
end 

endtask

endclass
