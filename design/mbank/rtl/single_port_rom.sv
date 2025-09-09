module single_port_rom(
	input logic clk, en,
	input logic [2:0] address,
	output logic [7:0] data_out
);

	logic [7:0] mem [0:7];
	
	initial begin
		mem[3'b000] = 8'b0000_0001;
		mem[3'b001] = 8'b0000_0010;
		mem[3'b010] = 8'b0000_0011;
		mem[3'b011] = 8'b0000_0100;
		mem[3'b100] = 8'b0000_0101;
		mem[3'b101] = 8'b0000_0110;
		mem[3'b110] = 8'b0000_0111;
		mem[3'b111] = 8'b0000_1000;
	end	

	always_ff @(posedge clk) begin
		if(en)
			data_out <= mem[address];
	end

endmodule
