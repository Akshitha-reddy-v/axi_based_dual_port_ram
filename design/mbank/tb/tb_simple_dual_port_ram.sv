module tb_simple_dual_port_ram();
	logic clk;
	logic wea;
	logic [1:0] addra, addrb;
	logic dina;
	logic douta, doutb;

	// DUT instantiation
	simple_dual_port_ram DUT (
		.clk(clk),
		.wea(wea),
		.addra(addra),
		.addrb(addrb),
		.dina(dina),
		.douta(douta),
		.doutb(doutb)
	);

	task write(input logic [1:0] addr, input logic data);
		@(negedge clk);
		wea = 1;
		addra = addr;
		dina = data;
	endtask

	task read_a(input logic [1:0] addr);
		wea = 0;
		addra = addr;
		@(posedge clk);
		#1;
		$display("Time=%t | wea=%b | addra=%b | douta=%b",$time,wea,addra,douta);
	endtask

	task read_b(input logic [1:0] addr);
		wea = 0;
		addrb = addr;
		@(posedge clk);
		#1;
		$display("Time=%t | wea=%b | addra=%b | addrb=%b | doutb=%b",$time,wea,addra,addrb,doutb);
	endtask


	// clock generation
	initial clk = 1'b0;
	always #5 clk = ~clk;

	// stimulus
	initial begin
		// initialize inputs
		wea=0; addra=2'b00; addrb=2'b00; dina=0;

		// wait a couple cycles for initialization
		#20;

		for(int i=0;i<8;i++) 
			write(i,i);

		#10;

		for(int i=0;i<8;i++)
			read_a(i);

		#10;

		for(int i=0;i<8;i++)
			read_b(i);


		#50 $finish;

	end

	//initial
		//$monitor("%t : wea=%b | dina=%b | addra=%b | addrb=%b | douta=%b | doutb=%b",$time,wea,dina,addra,addrb,douta,doutb);

endmodule
