module T_FF(q, clk, reset);
	output q;
	input clk, reset;
	wire d;
	
	// Instantiate D_FF. Call it dff0.
	D_FF dff0(q, d, clk, reset); 
	
	// not gate is a Verilog primitive. 
	not n1(d, q); 

endmodule
