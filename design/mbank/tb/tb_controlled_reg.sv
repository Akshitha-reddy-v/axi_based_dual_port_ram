module tb_controlled_reg();
	logic clk;
	logic CE;
	logic d;
	logic q;

	controlled_reg DUT (
		.clk(clk),
		.CE(CE),
		.d(d),
		.q(q)
	);

	initial clk = 1'b0;
	always #5 clk = ~clk;

	initial begin
		// initialize inputs
		CE=0; d=0;

		#20;

		@(negedge clk);
		CE=1;

		#10;
		@(posedge clk);
		$display("%t : CE=%b | d=%b | q=%b",$time,CE,d,q);

		@(negedge clk);
		d=1;

		#10;
		@(posedge clk);
		$display("%t : CE=%b | d=%b | q=%b",$time,CE,d,q);

		#20 $finish;

	end
endmodule
