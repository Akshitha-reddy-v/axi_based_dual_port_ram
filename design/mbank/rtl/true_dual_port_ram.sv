module true_dual_port_ram #(
	// parameters declarations
	parameter ADDR_WIDTH = 3,
	parameter DATA_WIDTH = 8
)(

	// port A
	input  logic 		      clka,
	//input  logic 		      rsta,
	input  logic 		      ena,
	input  logic 		      wea,
	input  logic [ADDR_WIDTH-1:0] addra,
	input  logic [DATA_WIDTH-1:0] dina,
	output logic [DATA_WIDTH-1:0] douta,

	// port B
	input  logic 		      clkb,
	//input  logic 		      rstb,
	input  logic 		      enb,
	input  logic 		      web,
	input  logic [ADDR_WIDTH-1:0] addrb,
	input  logic [DATA_WIDTH-1:0] dinb,
	output logic [DATA_WIDTH-1:0] doutb

);

	logic [DATA_WIDTH-1:0] mem [0:(1<<ADDR_WIDTH)-1];
	//integer i;

	always_ff @(posedge clka) begin
		if(ena) begin
			if(wea) 
				mem[addra] <= dina;
			douta <= mem[addra];
		end
	end

	always_ff @(posedge clkb) begin
		if(enb) begin
			if(web) 
				mem[addrb] <= dinb;
			doutb <= mem[addrb];
		end
	end




endmodule

