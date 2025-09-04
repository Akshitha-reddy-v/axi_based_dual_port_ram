module mux_4x1(
	input logic [7:0] i0,i1,i2,i3,
	input logic [1:0] sel,
	output logic [7:0] out
);

	/*assign out = (~sel[1] && ~sel[0] && i0) ||
		(~sel[1] && sel[0] && i1) ||
		(sel[1] && ~sel[0] && i2) ||
		(sel[1] && sel[0] && i3);*/

	always_comb begin
		case(sel)
			2'b00: out = i0;
			2'b01: out = i1;
			2'b10: out = i2;
			2'b11: out = i3;
			default: out = '0;
		endcase
	end

endmodule
