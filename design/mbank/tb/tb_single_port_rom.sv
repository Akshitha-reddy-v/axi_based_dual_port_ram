module tb_single_port_rom();
	logic clk, en;
	logic [2:0] address;
	logic [7:0] data_out;

	// DUT Instantiation
	single_port_rom DUT (
		.clk(clk),
		.en(en),
		.address(address),
		.data_out(data_out)
	);

	task read_data(input [2:0] addr);
   		en = 1;
    		address = addr;
    		@(posedge clk);  // Wait for ROM to latch and respond
    		#1;              // Small delay for data_out to settle
    	endtask
	

	initial clk = 1'b0;
	always #5 clk = ~clk;

	initial begin
		// initialize
		en = 1'b0;
		address = 3'b000;
		$display("data_out = %b",data_out);
		#20;

		for(int i=0;i<8;i++) begin
			read_data(i);
			$display("%t: addr=%d | data_out=%b",$time,address,data_out);
		end

		#50 $finish;

	end

endmodule
