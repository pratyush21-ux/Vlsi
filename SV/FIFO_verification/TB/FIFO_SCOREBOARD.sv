class FIFO_SCOREBOARD;
mailbox #(FIFO_TRANSACTION) mon2scb;
logic [7:0] ref_fifo[$];
int FIFO_DEPTH = 32;
int pass_count = 0;
int fail_count = 0;
int total_count = 0;

function new(mailbox #(FIFO_TRANSACTION) mon2scb);
    this.mon2scb = mon2scb;
endfunction

task run();
    FIFO_TRANSACTION tx;
    bit check = 0;
    logic [7:0] expected_data;

    forever begin
        mon2scb.get(tx);
        total_count++;
        if(check) begin
            if(tx.rdata === expected_data)
                pass_count++;
            else begin
                $error("[SCB] READ FAIL %0d: got 0x%02h, expected 0x%02h",
                       total_count, tx.rdata, expected_data);
                fail_count++;
            end
            check = 0;
        end
        if(tx.empty !== (ref_fifo.size() == 0)) begin
            $error("[SCB] FAIL %0d: Empty flag mismatch DUT empty=%0b, ref_fifo size=%0d",
                   total_count, tx.empty, ref_fifo.size());
            fail_count++;
        end

        if(tx.full !== (ref_fifo.size() == FIFO_DEPTH)) begin
            $error("[SCB] FAIL %0d: Full flag mismatch DUT full=%0b, ref_fifo size=%0d",
                   total_count, tx.full, ref_fifo.size());
            fail_count++;
        end

        if(tx.wr_en && !tx.full)
            ref_fifo.push_back(tx.wdata);

        if(tx.rd_en && !tx.empty && ref_fifo.size() > 0) begin
            expected_data = ref_fifo.pop_front();
            check = 1;
        end
    end
endtask

function void report();
    $display("Total transactions checked : %0d", total_count);
    $display("Read checks PASSED         : %0d", pass_count);
    $display("Checks FAILED              : %0d", fail_count);
    $display("Reference FIFO items left  : %0d", ref_fifo.size());
    if(fail_count == 0 && total_count > 0)
        $display("OVERALL RESULT: ===== PASS =====");
    else
        $display("OVERALL RESULT: ===== FAIL =====");
endfunction

endclass