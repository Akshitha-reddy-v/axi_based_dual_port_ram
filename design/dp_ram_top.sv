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

	logic [7:0] mem [0:31];

	logic [7:0] w1,w2,w3,w4,w5,w6,w7,w8;

	// Generate 4 banks
	/*genvar i;
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
	endgenerate*/

	dual_port_ram #(.ADDR_WIDTH(3),
			.DATA_WIDTH(8)
		) bank1 (
		.clka(clka),
		.rsta(rsta),
		.ena(ena),
		.wea(wea),
		.addra(addra[2:0]),
		.dina(dina),
		.douta(w1),

		.clkb(clkb),
		.rstb(rstb),
		.enb(enb),
		.web(web),
		.addrb(addra[2:0]),
		.dinb(dinb),
		.doutb(w5)
	);

	dual_port_ram #(.ADDR_WIDTH(3),
			.DATA_WIDTH(8)
		) bank2 (
		.clka(clka),
		.rsta(rsta),
		.ena(ena),
		.wea(wea),
		.addra(addra[2:0]),
		.dina(dina),
		.douta(w2),

		.clkb(clkb),
		.rstb(rstb),
		.enb(enb),
		.web(web),
		.addrb(addra[2:0]),
		.dinb(dinb),
		.doutb(w6)
	);

	dual_port_ram #(.ADDR_WIDTH(3),
			.DATA_WIDTH(8)
		) bank3 (
		.clka(clka),
		.rsta(rsta),
		.ena(ena),
		.wea(wea),
		.addra(addra[2:0]),
		.dina(dina),
		.douta(w3),

		.clkb(clkb),
		.rstb(rstb),
		.enb(enb),
		.web(web),
		.addrb(addra[2:0]),
		.dinb(dinb),
		.doutb(w7)
	);

	dual_port_ram #(.ADDR_WIDTH(3),
			.DATA_WIDTH(8)
		) bank4 (
		.clka(clka),
		.rsta(rsta),
		.ena(ena),
		.wea(wea),
		.addra(addra[2:0]),
		.dina(dina),
		.douta(w4),

		.clkb(clkb),
		.rstb(rstb),
		.enb(enb),
		.web(web),
		.addrb(addra[2:0]),
		.dinb(dinb),
		.doutb(w8)
	);


	mux_4x1 muxa (
		.i0(w1),
		.i1(w2),
		.i2(w3),
		.i3(w4),
		.sel(addra[4:3]),
		.out(douta)
	);

	mux_4x1 muxb (
		.i0(w5),
		.i1(w6),
		.i2(w7),
		.i3(w8),
		.sel(addrb[4:3]),
		.out(doutb)
	);



	
	// output muxes
	/*always_ff @(posedge clka)
		if(rsta)
			douta <= 8'h00;
		else if(ena && !wea)
			douta <= mem[addra];
	always_ff @(posedge clkb)
		if(rstb)
			doutb <= 8'h00;
		else if(enb && !web)
			doutb <= mem[addrb];*/


endmodule

		

