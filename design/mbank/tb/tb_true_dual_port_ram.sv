`timescale 1ns/1ps

module tb_true_dual_port_ram;
	class ww_conflict;
		rand bit ena,enb,wea,web;
		rand bit [2:0] addra,addrb;
		constraint ww {if (ena && enb && wea && web)
			 		addra != addrb;	
		}
	endclass


	// parameters
	localparam ADDR_WIDTH = 3;
	localparam DATA_WIDTH = 8;

	// signals for port A
	logic clka;
	//logic rsta;
	logic ena;
	logic wea;
	logic [ADDR_WIDTH-1:0] addra;
	logic [DATA_WIDTH-1:0] dina;
	logic [DATA_WIDTH-1:0] douta;

	// signals for port B
	logic clkb;
	//logic rstb;
	logic enb;
	logic web;
	logic [ADDR_WIDTH-1:0] addrb;
	logic [DATA_WIDTH-1:0] dinb;
	logic [DATA_WIDTH-1:0] doutb;

 
	true_dual_port_ram #(
		.ADDR_WIDTH(ADDR_WIDTH),
		.DATA_WIDTH(DATA_WIDTH)
	) DUT ( 		.clka(clka),
				//.rsta(rsta),
				.ena(ena),
				.wea(wea),
				.addra(addra),
				.dina(dina),
				.douta(douta),

				.clkb(clkb),
				//.rstb(rstb),
				.enb(enb),
				.web(web),
				.addrb(addrb),
				.dinb(dinb),
				.doutb(doutb)

			  );

	// clock generation
	initial clka = 0;
	always #5 clka = ~clka;		// 100 MHz

	initial clkb = 0;			
	always #5 clkb = ~clkb;		// 100 MHz

	// Initialize task
	task initialize();
		//rsta = 1;
		ena = 0;
		wea = 0;
		addra = 3'd0;
		dina = 8'h00;

		//rstb = 1;
		enb = 0;
		web = 0;
		addrb = 3'd0;
		dinb = 8'h00;
	endtask

	// portA write task
	task write_a(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
		@(negedge clka);
		ena = 1;
		wea = 1;
		addra = addr;
		dina = data;
		$display("DATA WRITE THROUGH PORT-A, Addr=%d, Data_in_A=%h",addra,dina);
	endtask

	// portA read task
	task read_a(input [ADDR_WIDTH-1:0] addr);
	
		@(negedge clka);
		ena = 1;
		wea = 0;
		addra = addr;
		@(posedge clka);
		@(posedge clka);
		$display("DATA READ THROUGH PORT-A, Addr=%d, Data_out_A=%h",addra,douta);
	endtask

	// portB write task
	task write_b(input [ADDR_WIDTH-1:0] addr, input [DATA_WIDTH-1:0] data);
		@(negedge clkb);
		enb = 1;
		web = 1;
		addrb = addr;
		dinb = data;
		$display("DATA WRITE THROUGH PORT-B, Addr=%d, Data_in_B=%h",addrb,dinb);
	endtask

	// portB read task
	task read_b(input [ADDR_WIDTH-1:0] addr);
		@(negedge clkb);
		enb = 1;
		web = 0;
		addrb = addr;
		@(posedge clkb);
		@(posedge clkb);
		$display("DATA READ THROUGH PORT-B, Addr=%d, Data_out_B=%h",addrb,doutb);
	endtask

	ww_conflict w1;

	// stimulus
	initial begin
		// Initialize
		initialize;

		// release reset
		#20;
		//rsta = 0;
		//rstb = 0;

		// write through port A
		#20; write_a(3'd3,8'hAA);

		// read back through port A
		#20; read_a(3'd3);

		// write through port B
		#20; write_b(3'd5,8'hAB);

		// read back through port B
		#20; read_b(3'd5);

		// cross access: Read from A what B wrote
		#20; read_a(3'd5);

		// cross access: Read from B what A wrote
		#20; read_b(3'd3);

		w1 = new();
		assert(w1.randomize());
		//$display("%0p",w1);


		// End simulation
		#150 $finish;
	end

endmodule
