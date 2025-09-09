module tb_multi_bank_spram_32x8;
	
	logic clk, en, we;
	logic [4:0] addr;
	logic [7:0] din, dout;

	
	// DUT instantiation
	multi_bank_spram_32x8 DUT (
		.clk(clk),
		.en(en),
		.we(we),
		.addr(addr),
		.din(din),
		.dout(dout)
	);

	// clock generation
	initial clk = 1'b0;
	always #5 clk = ~clk;

	task write_data(input [4:0] address, input [7:0] data);
		@(negedge clk);
		en = 1;
		we = 1;
		addr = address;
		din = data;
	endtask

	task read_data(input [4:0] address);
		en = 1;
		we = 0;
		addr = address;
		@(posedge clk);
		#1;
		$display("%t : addr=%b | data_out=%b", $time, addr, dout);
	endtask


	// stimulus
	initial begin
		// initialize inputs
		en=0; we=0; addr=5'd0; din=8'b0000_0000; 

		#20;

		// write phase
		for(int i=0;i<32;i++) begin
			write_data(i,i);
			@(posedge clk);
			read_data(i);
		end
		 
		#50 $finish;


	end



endmodule
