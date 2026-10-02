module stimulus;
	reg clk;
	reg reset;
	wire[3:0] q;
	
	// instantiate the design block
	ripple_carry_counter r1(q, clk, reset);
	// Control the clk signal that drives the design block. 
	//Cycle time = 10

	initial
		clk = 1'b0; //set clk to 0
	always
		#5 clk = ~clk;//toggle clk every5 time units

	// Control the reset signal that drives the design block
	// reset is asserted from 0 to 20 and from 200 to 220.
	initial
	begin
		reset = 1'b1;
		#15 reset = 1'b0;
		#180 reset = 1'b1;
		#10 reset = 1'b0;
		#20 $finish; //terminate the simulation
	end
	// Monitor the outputs
	initial
	$monitor($time, " Output q = %d", q);
	
	initial
	begin
		$dumpfile("ripple_carry_counter.vcd");
		$dumpvars();
	end
endmodule
