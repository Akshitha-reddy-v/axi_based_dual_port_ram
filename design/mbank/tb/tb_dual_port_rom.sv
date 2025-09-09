module tb_dual_port_rom;
	logic clk, ena, enb;
	logic [2:0] addra, addrb;
	logic [7:0] douta, doutb;

	// DUT instantiation
	dual_port_rom DUT (
		.clk(clk),
		.ena(ena),
		.enb(enb),
		.addra(addra),
		.addrb(addrb),
		.douta(douta),
		.doutb(doutb)
	);

	// clock generation
	always #5 clk = ~clk;

	// stimulus
	initial begin
		// initialize inputs
		clk = 1'b0;
		ena = 1'b0;
		enb = 1'b0;
		addra = 3'b000;
		addrb = 3'b000;

		#20;

		// read from all the locations
		for(int i=0;i<8;i++) begin
			#10;
			ena = 1'b1;
			addra = i;
			@(posedge clk);		// wait for ROM to latch and respond
			#1;			// small delay for data_out to settle
			$display("%t: ena=%b | addra=%b | douta=%b",$time,ena,addra,douta);
		end

		$display("\n");

		for(int i=0;i<8;i++) begin
			#10;
			enb = 1'b1;
			addrb = i;
			@(posedge clk);		// wait for ROM to latch and respond
			#1;			// small delay for data_out to settle
			$display("%t: en=b%b | addrb=%b | doutb=%b",$time,enb,addrb,doutb);

		end

		#20 $finish;

	end

	//initial
		//$monitor("ena=%b | addra=%b | enb=%b | addrb=%b | douta=%b | doutb=%b",ena,addra,enb,addrb,douta,doutb);

endmodule
