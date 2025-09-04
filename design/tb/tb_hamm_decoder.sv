`timescale 1ns/1ps
module tb_hamm_decoder();
	logic [7:1] code;
	logic parity_type;
	logic [4:1] decoded_data;
	logic error;

	hamm_decoder DUT (
		.code_in(code),
		.parity_type(parity_type),
		.data_out(decoded_data),
		.error(error)
	);

	initial begin
		// Test case 1: Even parity
		code = 7'b1011011;
		parity_type = 0;
		#10;
		$display("Code: %b, Decoded: %b, Error:%b, Parity: Even",code,decoded_data,error);

		// Test case 2: Odd parity
		code = 7'b1010110;
		parity_type = 1;
		#10;
		$display("Code: %b, Decoded: %b, Error:%b, Parity: Odd",code,decoded_data,error);

		$finish;

	end

endmodule
