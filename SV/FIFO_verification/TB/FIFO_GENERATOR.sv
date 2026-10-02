class FIFO_GENERATOR;
mailbox #(FIFO_TRANSACTION) gen2drv;
int num_transactions = 100;
int gen_count = 0;
bit done = 0;
string test_type = "random";

function new(mailbox #(FIFO_TRANSACTION) gen2drv, int num_transactions = 100, string test_mode = "random");
    this.gen2drv = gen2drv;
    this.num_transactions = num_transactions;
    this.test_type = test_mode;
endfunction

task run();
    case(test_type)
        "random"  : random_test();
        "write"   : write_test();
        "read"    : read_test();
        "order"   : order_test();
        "empty"   : empty_test();
        "full"    : full_test();
        "overflow": overflow_test();
        default: begin
            $error("[GEN] Unknown test mode: %s", test_type);
            $finish;
        end
    endcase
    $display("[GEN] Generated %0d transactions total.", gen_count);
    done = 1;
endtask

task put_tx(FIFO_TRANSACTION tx);
    tx.display("GEN");
    gen2drv.put(tx.do_copy());
    gen_count++;
endtask

task random_test();
    FIFO_TRANSACTION tx;
    repeat(num_transactions) begin
        tx = new();
        if(!tx.randomize()) begin
            $error("[GEN] Randomization Failed");
            $finish;
        end
        put_tx(tx);
    end
endtask

task write_test();
    FIFO_TRANSACTION tx;
    for(int i = 0; i < num_transactions; i++) begin
        tx = new();
        tx.wr_en = 1'b1;
        tx.rd_en = 1'b0;
        tx.wdata = i[7:0];
        put_tx(tx);
    end
endtask

task read_test();
    FIFO_TRANSACTION tx;
    int count = (num_transactions > 10) ? 10 : num_transactions/2;

    for(int i = 0; i < count; i++) begin
        tx = new();
        tx.wr_en = 1'b1;
        tx.rd_en = 1'b0;
        tx.wdata = 8'hA0 + i[7:0];
        put_tx(tx);
    end

    for(int i = 0; i < count; i++) begin
        tx = new();
        tx.wr_en = 1'b0;
        tx.rd_en = 1'b1;
        tx.wdata = 8'h00;
        put_tx(tx);
    end
endtask

task order_test();
    FIFO_TRANSACTION tx;
    for(int i = 0; i < 20; i++) begin
        tx = new();
        tx.wr_en = 1'b1; tx.rd_en = 1'b0; tx.wdata = 8'h10 + i[7:0];
        put_tx(tx);
    end
    for(int i = 0; i < 50; i++) begin
        tx = new();
        tx.wr_en = 1'b0; tx.rd_en = 1'b1; tx.wdata = 8'h00;
        put_tx(tx);
        tx = new();
        tx.wr_en = 1'b1; tx.rd_en = 1'b0; tx.wdata = 8'h80 + i[7:0];
        put_tx(tx);
    end
    for(int i = 0; i < 20; i++) begin
        tx = new();
        tx.wr_en = 1'b0; tx.rd_en = 1'b1; tx.wdata = 8'h00;
        put_tx(tx);
    end
endtask

task empty_test();
    FIFO_TRANSACTION tx;
    for(int i = 0; i < 32; i++) begin
        tx = new();
        tx.wr_en = 1'b0;
        tx.rd_en = 1'b1;
        tx.wdata = 8'h00;
        put_tx(tx);
    end
endtask

task full_test();
    FIFO_TRANSACTION tx;
    for(int i = 0; i < 32; i++) begin
        tx = new();
        tx.wr_en = 1'b1;
        tx.rd_en = 1'b0;
        tx.wdata = i[7:0];
        put_tx(tx);
    end
endtask

task overflow_test();
    FIFO_TRANSACTION tx;
    for(int i = 0; i < 32; i++) begin
        tx = new();
        tx.wr_en = 1'b1;
        tx.rd_en = 1'b0;
        tx.wdata = i[7:0];
        put_tx(tx);
    end
    for(int i = 0; i < 5; i++) begin
        tx = new();
        tx.wr_en = 1'b1;
        tx.rd_en = 1'b0;
        tx.wdata = 8'hFF;
        put_tx(tx);
    end
endtask

endclass