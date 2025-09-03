module ram_top(
 
	// port A
	input  logic 	   clka,
	input  logic 	   rsta,
	input  logic 	   ena,
	input  logic       wea,
	input  logic [4:0] addra,
	input  logic [7:0] dina,
	output logic [7:0] douta,

	// port B
	input  logic 	   clkb,
	input  logic 	   rstb,
	input  logic 	   enb,
	input  logic 	   web,
	input  logic [4:0] addrb,
	input  logic [7:0] dinb,
	output logic [7:0] doutb
);

	// split addresses
	logic [1:0] bank_a = addra[4:3];	// upper 2 bits = bank select
	logic [2:0] row_a = addra[2:0];		// lower 3 bits = inside bank

	logic [1:0] bank_b = addrb[4:3];	
	logic [2:0] row_b = addrb[2:0];	

	// outputs from banks
	logic [7:0] douta_bank[3:0];
	logic [7:0] doutb_bank[3:0];

	// Generate 4 banks
	genvar i;
	generate
	for( i = 0; i < 4; i++) begin : banks
		dual_port_ram #(
			.ADDR_WIDTH(3),		// 8 rows per bank
			.DATA_WIDTH(8)		// 8-bit wide
		)u_bank (
			.clka(clka),
			.rsta(rsta),
			.ena(ena && (bank_a == i)),
			.wea(wea),
			.addra(row_a),
			.dina(dina),
			.douta(douta_bank[i]),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb && bank_b == i),
			.web(web),
			.addrb(row_b),
			.dinb(dinb),
			.doutb(doutb_bank[i])
		);
	end
	endgenerate

	/*dual_port_ram #(
			.ADDR_WIDTH(3),		// 8 rows per bank
			.DATA_WIDTH(8)		// 8-bit wide
		) bank0 (
			.clka(clka),
			.rsta(rsta),
			.ena(ena),
			.wea(wea),
			.addra(row_a),
			.dina(dina),
			.douta(douta_bank[0]),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb),
			.web(web),
			.addrb(row_b),
			.dinb(dinb),
			.doutb(doutb_bank[0])
		);

	dual_port_ram #(
			.ADDR_WIDTH(3),		// 8 rows per bank
			.DATA_WIDTH(8)		// 8-bit wide
		) bank1 (
			.clka(clka),
			.rsta(rsta),
			.ena(ena),
			.wea(wea),
			.addra(row_a),
			.dina(dina),
			.douta(douta_bank[1]),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb),
			.web(web),
			.addrb(row_b),
			.dinb(dinb),
			.doutb(doutb_bank[1])
		);

	dual_port_ram #(
			.ADDR_WIDTH(3),		// 8 rows per bank
			.DATA_WIDTH(8)		// 8-bit wide
		) bank2 (
			.clka(clka),
			.rsta(rsta),
			.ena(ena),
			.wea(wea),
			.addra(row_a),
			.dina(dina),
			.douta(douta_bank[2]),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb),
			.web(web),
			.addrb(row_b),
			.dinb(dinb),
			.doutb(doutb_bank[2])
		);

	dual_port_ram #(
			.ADDR_WIDTH(3),		// 8 rows per bank
			.DATA_WIDTH(8)		// 8-bit wide
		) bank3 (
			.clka(clka),
			.rsta(rsta),
			.ena(ena),
			.wea(wea),
			.addra(row_a),
			.dina(dina),
			.douta(douta_bank[3]),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb),
			.web(web),
			.addrb(row_b),
			.dinb(dinb),
			.doutb(doutb_bank[3])
		);*/


	
	// output muxes
	assign douta = douta_bank[bank_a];
	assign doutb = doutb_bank[bank_b];

endmodule

		

