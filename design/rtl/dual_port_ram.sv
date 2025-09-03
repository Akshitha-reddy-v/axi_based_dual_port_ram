module dual_port_ram #(
	// parameters declarations
	parameter ADDR_WIDTH = 3,
	parameter DATA_WIDTH = 8
)(

	// port A
	input  logic 		      clka,
	input  logic 		      rsta,
	input  logic 		      ena,
	input  logic 		      wea,
	input  logic [ADDR_WIDTH-1:0] addra,
	input  logic [DATA_WIDTH-1:0] dina,
	output logic [DATA_WIDTH-1:0] douta,

	// port B
	input  logic 		      clkb,
	input  logic 		      rstb,
	input  logic 		      enb,
	input  logic 		      web,
	input  logic [ADDR_WIDTH-1:0] addrb,
	input  logic [DATA_WIDTH-1:0] dinb,
	output logic [DATA_WIDTH-1:0] doutb

);

	logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];
	integer i;

	always_ff @(posedge clka) begin
		if(rsta) begin
			for(i = 0; i < (2**ADDR_WIDTH); i++) begin
				mem[i] <= 8'h00;
			end
			douta <= 8'h00;
		end
		else begin
			if(ena) begin
				if(wea) begin
					mem[addra] <= dina;
				end
				else begin
					douta <= mem[addra];
				end
			end
			else
				douta <= douta;
		end
	end

	always_ff @(posedge clkb) begin
		if(rstb) begin
			for(i = 0; i < (2**ADDR_WIDTH); i++) begin
				mem[i] <= 8'h00;
			end
			doutb <= 8'h00;
		end
		else begin
			if(enb) begin
				if(web) begin
					mem[addrb] <= dinb;
				end
				else begin
					doutb <= mem[addrb];
				end
			end
			else
				doutb <= doutb;
		end
	end
endmodule

