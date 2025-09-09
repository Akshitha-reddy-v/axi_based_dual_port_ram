module dual_port_rom(clk,ena,enb,addra,addrb,douta,doutb);
	input logic clk;
	input logic ena, enb;
	input logic [2:0] addra, addrb;
	output logic [7:0] douta, doutb;

	logic [7:0] mem [0:7];

	initial begin
		mem[3'b000] = 8'b0000_0000;
		mem[3'b001] = 8'b0000_0001;
		mem[3'b010] = 8'b0000_0010;
		mem[3'b011] = 8'b0000_0011;
		mem[3'b100] = 8'b0000_0100;
		mem[3'b101] = 8'b0000_0101;
		mem[3'b110] = 8'b0000_0110;
		mem[3'b111] = 8'b0000_0111;
	end

	always_ff @(posedge clk) begin
		if(ena)
			douta <= mem[addra];
	end
	always_ff @(posedge clk) begin
		if(enb)
			doutb <= mem[addrb];
	end

endmodule
