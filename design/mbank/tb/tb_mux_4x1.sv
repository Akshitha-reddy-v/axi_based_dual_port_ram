`timescale 1ns/1ps

module tb_mux_4x1;
	logic i0,i1,i2,i3;
	logic [1:0] sel;
	logic out;

	mux_4x1 DUT (.i0(i0),
		.i1(i1),
		.i2(i2),
		.i3(i3),
		.sel(sel),
		.out(out)
	);

	initial begin
		{i0,i1,i2,i3} = 32'h0000_0000;
		sel = 2'b00;

		#10;
		i0 = 8'h10;
		i1 = 8'h11;
		i2 = 8'h12;
		i3 = 8'h13;
		sel = 2'b00;

		#10;
		sel = 2'b01;

		#10;
		sel = 2'b10;

		#10;
		sel = 2'b11;

		#10;
		$finish;

	end

	initial 
		$monitor("%t: in1=%b | in2=%b | in3=%b | in4=%b | sel=%b | out=%b",$time,i0,i1,i2,i3,sel,out);
endmodule
