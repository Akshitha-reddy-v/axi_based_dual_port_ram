// hamming encoder
module hamming_encoder #(
	parameter int unsigned DATA_WIDTH = 8
) (
	input logic [DATA_WIDTH-1:0] data_in,
	output logic [DATA_WIDTH + calc_p(DATA_WIDTH)-1:0] code_out
);

	// parameters declaration
	localparam int P = calc_p(DATA_WIDTH);
	localparam int CODE_WIDTH = DATA_WIDTH + P;  

	// parity calculation
	function automatic int calc_p (input int d);
		int p = 0;
		while((1<<p) < (d + p + 1)) 
			p++;
		return p;
	endfunction

	// Encoding logic
	always_comb begin
		automatic int di = 0;
		for(int ci=1; ci<=CODE_WIDTH; ci++) begin
			if((ci & (ci-1))==0) begin
				code_out[ci-1] = 0;
			end
			else begin
				code_out[ci-1] = data_in[di];
				di++;
			end
		end

		// computing parity bits
		for(int pi=0; pi<P; pi++) begin
			automatic int parity_pos = (1 << pi);	// 1-based index
			automatic logic parity = 0;
			for(int ci=1; ci<=CODE_WIDTH; ci++) begin
				if(ci & parity_pos) begin
					parity ^= code_out[ci-1];
				end
			end
			code_out[parity_pos-1] = parity;
		end
	end
	
endmodule
