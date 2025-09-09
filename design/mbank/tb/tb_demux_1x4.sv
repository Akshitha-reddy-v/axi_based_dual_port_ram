module tb_demux_1x4();
	logic in;
	logic [1:0] sel;
	logic out0,out1,out2,out3;

	// DUT instantiation
	demux_1x4 DUT (
		.in(in),
		.sel(sel),
		.out0(out0),
		.out1(out1),
		.out2(out2),
		.out3(out3)
	);

	// stimulus
	initial begin
		// initialize inputs
		in=0; sel=2'b00;

		#10;
		in=1;

		#10 sel=2'b00;
		#10 sel=2'b01;
		#10 sel=2'b10;
		#10 sel=2'b11;

		#20 $finish;

	end

	initial
		$monitor("%t: in=%b | sel=%b | {y3,y2,y1,y0}=%b%b%b%b",$time,in,sel,out3,out2,out1,out0);

endmodule
