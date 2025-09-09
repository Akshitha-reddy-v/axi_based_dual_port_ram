module demux_1x4(in,sel,out0,out1,out2,out3);
	input logic in;
	input logic [1:0] sel;
	output logic out0, out1, out2, out3;

	always_comb begin
		case(sel)
			2'b00: {out3,out2,out1,out0} = {3'b000,in};
			2'b01: {out3,out2,out1,out0} = {2'b00,in,1'b0};
			2'b10: {out3,out2,out1,out0} = {1'b0,in,2'b0};
			2'b11: {out3,out2,out1,out0} = {in,3'b000};
			default: {out3,out2,out1,out0} = {4'b0000};
		endcase
	end

	//assign {out3,out2,out1,out0} = (in << sel);

endmodule
