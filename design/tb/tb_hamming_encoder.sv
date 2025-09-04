`timescale 1ns/1ps

module tb_hamming_encoder();
	// parameters
	localparam int DATA_WIDTH = 8;
	localparam int P = calc_p(DATA_WIDTH);
	localparam int CODE_WIDTH = DATA_WIDTH + P;

	logic [DATA_WIDTH-1:0] data_in;
	logic [CODE_WIDTH-1:0] code_out;

	// Instantiating DUT
	hamming_encoder #(.DATA_WIDTH(DATA_WIDTH))
			dut (.data_in(data_in),
				.code_out(code_out)
			);
	

	// parity bits calculation function
	function automatic int calc_p(input int d);
		int p = 0;
		while((1<<p) < (d + p + 1))
			p++;
		return p;
	endfunction

	// stimulus 
	initial begin
		$display("------- Hamming Encoder Test -------");
		$display("DATA_WIDTH = %0d, PARITY_BITS = %0d, CODE_WIDTH = %0d", DATA_WIDTH, P, CODE_WIDTH);

		data_in = 8'hA5;
		#5;
		$display("Data=%b -> Code=%b", data_in, code_out);

		data_in = 8'h3C;
		#5;
		$display("Data=%b -> Code=%b", data_in, code_out);

		data_in = 8'hFF;
		#5;
		$display("Data=%b -> Code=%b", data_in, code_out);

		data_in = 8'h00;
		#5;
		$display("Data=%b -> Code=%b", data_in, code_out);

		$display("-------- Test Done ---------");
		$finish;

	end

	
endmodule
