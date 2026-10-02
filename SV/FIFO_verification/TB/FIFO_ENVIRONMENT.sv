class FIFO_ENVIRONMENT;
FIFO_GENERATOR  gen;
FIFO_DRIVER     drv;
FIFO_COVERAGE   cov;
FIFO_MONITOR    mon;
FIFO_SCOREBOARD scb;

mailbox #(FIFO_TRANSACTION) gen2drv;
mailbox #(FIFO_TRANSACTION) mon2scb;
mailbox #(FIFO_TRANSACTION) mon2cov;

virtual FIFO_INTERFACE vif;

int num_transactions;
string test_mode;

function new(virtual FIFO_INTERFACE vif, int num_transactions = 1000, string test_mode = "random");
    this.vif = vif;
    this.num_transactions = num_transactions;
    this.test_mode = test_mode;
endfunction

task build();
    gen2drv = new(1);
    mon2cov = new();
    mon2scb = new();

    gen = new(.gen2drv(gen2drv), .num_transactions(num_transactions), .test_mode(test_mode));
    drv = new(.vif(vif), .gen2drv(gen2drv));
    mon = new(.vif(vif), .mon2scb(mon2scb), .mon2cov(mon2cov));
    scb = new(.mon2scb(mon2scb));
    cov = new(.vif(vif), .mon2cov(mon2cov));
endtask

task reset();
    drv.reset();
endtask

task run();
    fork
        gen.run();
        drv.run();
        mon.run();
        scb.run();
        cov.run();
    join_none
    wait(gen.done);
    wait(drv.drv_count == gen.gen_count);
    @(vif.drv_cb);
    drv.idle();
    repeat(10) @(vif.drv_cb);
    disable fork;
endtask

task report();
    $display("Generator created : %0d transactions", gen.gen_count);
    $display("Driver drove      : %0d transactions", drv.drv_count);
    $display("Monitor observed  : %0d transactions", mon.mon_count);
    scb.report();
    cov.report();
endtask

task test();
    build();
    reset();
    run();
    report();
endtask

endclass