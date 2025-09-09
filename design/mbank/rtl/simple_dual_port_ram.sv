
module mux_4x1(sel,i0,i1,i2,i3,out);
	input logic [1:0] sel;
	input logic i0,i1,i2,i3;
	output logic out;

	always_comb begin
		case(sel)
			2'b00: out = i0;
			2'b01: out = i1;
			2'b10: out = i2;
			2'b11: out = i3;
			default: out = 0;
		endcase
	end
endmodule : mux_4x1

module simple_dual_port_ram(clk,wea,addra,addrb,dina,douta,doutb);
	// inputs
	input logic clk;
	input logic wea;
	input logic [1:0] addra, addrb;
	input logic dina;

	// outputs
	output logic douta, doutb;

	// internal registers
	logic w1, w2, w3, w4, w5, w6, w7, w8;

	// Demux instantiation
	demux_1x4 DEMUX (
		.in(wea),
		.sel(addra),
		.out0(w1),
		.out1(w2),
		.out2(w3),
		.out3(w4)
	);

	// Controlled register instantiation
	controlled_reg CTRL_REG0 (
		.d(dina),
		.CE(w1),
		.clk(clk),
		.q(w5)
	);
	controlled_reg CTRL_REG1 (
		.d(dina),
		.CE(w2),
		.clk(clk),
		.q(w6)
	);
	controlled_reg CTRL_REG2 (
		.d(dina),
		.CE(w3),
		.clk(clk),
		.q(w7)
	);
	controlled_reg CTRL_REG3 (
		.d(dina),
		.CE(w4),
		.clk(clk),
		.q(w8)
	);

	// Mux instantiation
	mux_4x1 MUX0 (
		.sel(addra),
		.i0(w5),
		.i1(w6),
		.i2(w7),
		.i3(w8),
		.out(douta)
	);
	mux_4x1 MUX1 (
		.sel(addrb),
		.i0(w5),
		.i1(w6),
		.i2(w7),
		.i3(w8),
		.out(doutb)
	);

	

endmodule : simple_dual_port_ram
