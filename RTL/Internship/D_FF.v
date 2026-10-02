// module D_FF with synchronous reset
module D_FF(q, d, clk, reset);
	output q;
	input d, clk, reset;
	reg q;
	//Lots of new constructs. Ignore the functionality 
	// of the constructs for now. Concentrate on how the 
	// design block is built in a top-down fashion.

	always @(posedge reset or negedge clk)
		if (reset)
			q <= 1'b0;
		else
			q <= d;
endmodule
