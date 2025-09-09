
module mux_4x1(sel,i0,i1,i2,i3,out);
	input logic [7:0] i0,i1,i2,i3;
	input logic [1:0] sel;
	output logic [7:0] out;

	always_comb begin
		case(sel)
			2'b00: out = i0;
			2'b01: out = i1;
			2'b10: out = i2;
			2'b11: out = i3;
			default: out = 8'b0000_0000;
		endcase
	end

endmodule : mux_4x1

module multi_bank_spram_32x8 (clk,en,we,addr,din,dout);
	input logic clk, en, we;
	input logic [4:0] addr;
	input logic [7:0] din;
	output logic [7:0] dout;

	logic [7:0] w1,w2,w3,w4;

	// Bank modules
	single_port_ram s1 (
		.clk(clk),
		.en(en),
		.we(we),
		.addr(addr[2:0]),
		.din(din),
		.dout(w1)
	);

	single_port_ram s2 (
		.clk(clk),
		.en(en),
		.we(we),
		.addr(addr[2:0]),
		.din(din),
		.dout(w2)
	);

	single_port_ram s3 (
		.clk(clk),
		.en(en),
		.we(we),
		.addr(addr[2:0]),
		.din(din),
		.dout(w3)
	);

	single_port_ram s4 (
		.clk(clk),
		.en(en),
		.we(we),
		.addr(addr[2:0]),
		.din(din),
		.dout(w4)
	);

	// mux for read output
	mux_4x1 mux1 (
		.sel(addr[4:3]),
		.i0(w1),
		.i1(w2),
		.i2(w3),
		.i3(w4),
		.out(dout)
	);

endmodule : multi_bank_spram_32x8
