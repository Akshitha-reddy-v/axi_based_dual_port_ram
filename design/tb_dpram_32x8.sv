`timescale 1ns/1ps

module tb_dpram_32x8;
	class ww_conflict;
		rand bit ena, enb, wea, web;
		rand bit [2:0] addra, addrb;
		constraint ww_error {if (ena && enb && wea && web)
					addra != addrb;
		}
	endclass

	// Port A
	logic clka;
	logic rsta;
	logic ena;
	logic wea;
	logic [4:0] addra;
	logic [7:0] dina;
	logic [7:0] douta;

	// Port B
	logic clkb;
	logic rstb;
	logic enb;
	logic web;
	logic [4:0] addrb;
	logic [7:0] dinb;
	logic [7:0] doutb;

	// clock generation
	initial clka = 0;
	always #5 clka = ~clka;

	initial clkb = 0;
	always #5 clkb = ~clkb;

	// DUT instance
	ram_top dut (
			.clka(clka),
			.rsta(rsta),
			.ena(ena),
			.wea(wea),
			.addra(addra),
			.dina(dina),
			.douta(douta),

			.clkb(clkb),
			.rstb(rstb),
			.enb(enb),
			.web(web),
			.addrb(addrb),
			.dinb(dinb),
			.doutb(doutb)
		);


        task write_a(input [4:0] addr, input [7:0] data);
		begin
			@(negedge clka);
			ena = 1;
			wea = 1;
			addra = addr;
			dina = data;
			@(posedge clka);
			$display("Port A write : Addr=%d | Data_in=%h", addra, dina);
			//@(posedge clka);
			//$display("Port A write : Addr=%d | Data_in=%h", addra, dina);*/

		end
	endtask

	task write_b(input [4:0] addr, input [7:0] data);
		begin
			@(negedge clkb);
			enb = 1;
			web = 1;
			addrb = addr;
			dinb = data;
			@(posedge clkb);
			$display("Port B write : Addr=%d | Data_in=%h", addrb, dinb);
			//@(posedge clkb);
			//$display("Port B write : Addr=%d | Data_in=%h", addrb, dinb);

		end
	endtask

	task read_a(input [4:0] addr);
		begin
			@(negedge clka);
			ena = 1;
			wea = 0;
			addra = addr;
			@(posedge clka);
			//$display("Port A read : Addr=%d | Data_out=%h", addra, douta);
			@(posedge clka);
			$display("Port A read : Addr=%d | Data_out=%h", addra, douta);

		end
	endtask

	task read_b(input [4:0] addr);
		begin
			@(negedge clkb);
			enb = 1;
			web = 0;
			addrb = addr;
			@(posedge clkb);
			//$display("Port B read : Addr=%d | Data_out=%h", addrb, doutb);
			@(posedge clkb);
			$display("Port B read : Addr=%d | Data_out=%h", addrb, doutb);

		end
	endtask


	ww_conflict w1;

	initial begin
		// Initialize
		ena = 0; enb = 0;
		wea = 0; web = 0;
		rsta = 1; rstb = 1;
		addra = 0; addrb = 0;
		dina = 0; dinb = 0;

		// Hold reset
		repeat(2) @(posedge clka);
		repeat(2) @(posedge clkb);
		rsta = 0; rstb = 0;

		$display("===== Test START =====");
		// write through port A
		#20; write_a(5'd3,8'hAA);

		// read back through port A
		#20; read_a(5'd3);

		// write through port B
		#20; write_b(5'd5,8'hAB);

		// read back through port B
		#20; read_b(5'd5);

		// cross access: Read from A what B wrote
		#20; read_a(5'd5);

		// cross access: Read from B what A wrote
		#20; read_b(5'd3);

		//w1 = new();
		//assert(w1.randomize());

		#150 $finish;

	end

	/*initial begin
		$monitor("%t: clka=%b | rsta=%b | ena=%b | wea=%b | addra=%d | dina=%h | douta=%h", $time,clka,rsta,ena,wea,addra,dina,douta);
	end
	initial begin
		$monitor("%t: clkb=%b | rstb=%b | enb=%b | web=%b | addrb=%d | dinb=%h | doutb=%h", $time,clkb,rstb,enb,web,addrb,dinb,doutb);
	end*/		

endmodule
