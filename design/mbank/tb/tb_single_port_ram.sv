
`include "single_port_ram.sv"

module tb_single_port_ram();
	logic clk, en, we;
	logic [2:0] addr;
	logic [7:0] din, dout;

	// DUT instantiation
	single_port_ram DUT (
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

	task write(input [2:0] address, input [7:0] data);
		@(negedge clk);
		en=1; we=1; addr=address; din=data;
	endtask

	task read(input [2:0] address);
		@(posedge clk);
		we=0; addr=address;
		@(posedge clk);
		@(posedge clk);
		$display("Read data: Addr=%b | data_out=%b",addr,dout);
	endtask

	// stimulus
	initial begin
		// initialize inputs
		en=0; we=0; addr=3'b000; din=8'b0000_0000;

		#20;

		for(int i=0;i<8;i++) begin
			write(i,i);
			read(i);
		end
		 
		// write data(8'b0000_0001) to the addr location(3)
		/*@(negedge clk);
		en=1; we=1; addr=3'b011; din=8'b0000_0001;

		// read data from addr(3)
		//@(posedge clk);
		@(posedge clk);
		we=0; addr=3'b011;
		@(posedge clk);
		@(posedge clk);
		$display("Read data: Addr=%b | data_out=%b",addr,dout);
		#30;


		// write data(8'b0000_0100) to the addr location(7)
		@(negedge clk);
		we=1; addr=3'b111; din=8'b0000_0100;

		// read data from addr(7)
		@(posedge clk);
		we=0; addr=3'b111;
		@(posedge clk);
		@(posedge clk);

		$display("Read data: Addr=%b | data_out=%b",addr,dout);*/

		#20;
		$finish;


	end

endmodule
