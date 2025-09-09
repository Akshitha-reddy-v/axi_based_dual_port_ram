module single_port_ram(clk,en,we,addr,din,dout);
	input logic clk,en,we;
	input logic [2:0] addr;
	input logic [7:0] din;
	output logic [7:0] dout;

	logic [7:0] mem [0:7];

	always_ff @(posedge clk) begin
		if(en) begin
			if(we)
				mem[addr] <= din;
			else
				dout <= mem[addr];
		end
	end

endmodule : single_port_ram
