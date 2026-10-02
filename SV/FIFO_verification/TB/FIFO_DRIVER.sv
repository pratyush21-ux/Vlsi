class FIFO_DRIVER;
virtual FIFO_INTERFACE vif;
mailbox #(FIFO_TRANSACTION) gen2drv;
int drv_count = 0;

function new(virtual FIFO_INTERFACE vif, mailbox #(FIFO_TRANSACTION) gen2drv);
    this.vif = vif;
    this.gen2drv = gen2drv;
endfunction

task automatic idle();
    vif.drv_cb.wr_en <= 1'b0;
    vif.drv_cb.rd_en <= 1'b0;
    vif.drv_cb.wdata <= 8'b0;
endtask

task automatic reset();
    vif.rst <= 1'b1;
    idle();
    repeat(2) @(vif.drv_cb);
    vif.rst <= 1'b0;
    @(vif.drv_cb);
endtask

task automatic drive(FIFO_TRANSACTION tx);
    vif.drv_cb.wr_en <= tx.wr_en;
    vif.drv_cb.rd_en <= tx.rd_en;
    vif.drv_cb.wdata <= tx.wdata;
endtask

task run();
    FIFO_TRANSACTION tx;
    wait(vif.rst === 1'b0);
    @(vif.drv_cb);
    idle();
    forever begin
        gen2drv.get(tx);
        @(vif.drv_cb);
        drive(tx);
        tx.display("DRV");
        drv_count++;
    end
endtask

endclass