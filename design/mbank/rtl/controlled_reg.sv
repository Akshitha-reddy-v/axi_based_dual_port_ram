module controlled_reg(clk,CE,d,q);
	input logic clk, CE, d;
	output logic q;

	always_ff @(posedge clk) begin
		if(CE)
			q <= d;
	end

endmodule
