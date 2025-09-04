module hamm_decoder(
	input logic [7:1] code_in,
	input logic parity_type,
	output logic [4:1] data_out,
	output logic error
);
	
	// calculate syndrome bits
	logic s1, s2, s3;
	assign s1 = code_in[1] ^ code_in[3] ^ code_in[5] ^ code_in[7] ^ parity_type;
	assign s2 = code_in[2] ^ code_in[3] ^ code_in[6] ^ code_in[7] ^ parity_type;
	assign s3 = code_in[4] ^ code_in[5] ^ code_in[6] ^ code_in[7] ^ parity_type;

	// Determine the error position
	logic [2:0] error_pos;
	assign error_pos = {s3, s2, s1};

	logic [7:1] corrected_code;
	always_comb begin
		corrected_code = code_in;
		if(error_pos != 3'b000) begin
			corrected_code[error_pos] = ~corrected_code[error_pos];
			error = 1;
		end
		else begin
			error = 0;
		end
	end

	assign data_out = {corrected_code[7], corrected_code[6], corrected_code[5], corrected_code[3]};

endmodule
