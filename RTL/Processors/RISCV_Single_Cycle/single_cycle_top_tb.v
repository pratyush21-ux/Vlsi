`timescale 1ns / 1ps

module single_cycle_top_tb;

    reg clk;
    reg reset;

    // Instantiate your top module
    single_cycle_top uut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10ns period
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #20;
        reset = 0;
        #1000; // Simulation run time
        $finish;
    end

    initial begin
        // For waveform dumping
        $dumpfile("Risc.vcd");
        $dumpvars();
    end

    initial begin
        // Monitor block without DataAdr
        $monitor("Time: %0t | PC: %h | Instr: %h | ALU_Out: %h | MemWrite: %b | WriteData: %h",
                 $time, uut.PC, uut.Instr, uut.ALU_OUTPUT, uut.MemWrite, uut.WriteData);
    end

endmodule
