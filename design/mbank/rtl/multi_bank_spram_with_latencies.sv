
module mux_4x1(sel,i0,i1,i2,i3,out);
	input logic [7:0] i0,i1,i2,i3;
	input logic [1:0] sel;
	output logic [7:0] out;

	always_comb begin
		case(sel)
			2'b00: out = i0;
			2'b01: out = i1;
			2'b10: out = i2;
			2'b11: out = i3;
			default: out = 8'b0000_0000;
		endcase
	end

endmodule : mux_4x1

module multi_bank_spram_with_latencies #(
	parameter READ_LATENCY = 2,
	parameter WRITE_LATENCY = 2
) (clk,en,we,addr,din,dout);
	input logic clk, en, we;
	input logic [4:0] addr;
	input logic [7:0] din;
	output logic [7:0] dout;

	// Internal wires	
	logic [7:0] w1,w2,w3,w4;
	logic [1:0] bank_sel;
        logic [7:0] mux_out;
	logic [2:0] local_addr;
	logic en1,en2,en3,en4;

	// write pipeline
	typedef struct packed {
		logic en;
		logic we;
		logic [1:0] bank_sel;
		logic [2:0] local_addr;
		logic [7:0] din;
	} write_req_t;

	write_req_t write_pipe [WRITE_LATENCY-1:0];

	// Read pipeline
	typedef struct packed {
		logic [1:0] bank_sel;
		logic [2:0] local_addr;
	} read_req_t;

	read_req_t read_pipe_req [READ_LATENCY-1:0];
	
	logic [7:0] read_data_pipe [READ_LATENCY-1:0];

	// Bank modules
	single_port_ram s1 (
		.clk(clk),
		.en(en1),
		.we(1'b0),
		.addr(read_pipe_req[0].local_addr),
		.din(8'd0),
		.dout(w1)
	);

	single_port_ram s2 (
		.clk(clk),
		.en(en2),
		.we(1'b0),
		.addr(read_pipe_req[0].local_addr),
		.din(8'd0),
		.dout(w2)
	);

	single_port_ram s3 (
		.clk(clk),
		.en(en3),
		.we(1'b0),
		.addr(read_pipe_req[0].local_addr),
		.din(8'd0),
		.dout(w3)
	);

	single_port_ram s4 (
		.clk(clk),
		.en(en4),
		.we(1'b0),
		.addr(read_pipe_req[0].local_addr),
		.din(8'd0),
		.dout(w4)
	);

	// mux for read output
	mux_4x1 mux1 (
		.sel(read_pipe_req[READ_LATENCY-1].bank_sel),
		.i0(w1),
		.i1(w2),
		.i2(w3),
		.i3(w4),
		.out(mux_out)
	);

	// write request pipeline
	always_ff @(posedge clk) begin
		write_pipe[0] <= '{en,we,bank_sel,local_addr,din};
		for(int i=1;i<WRITE_LATENCY;i++)
			write_pipe[i] <= write_pipe[i-1];
	end

	// write execution (only on last stage of pipeline)
	always_ff @(posedge clk) begin
		if(write_pipe[WRITE_LATENCY-1].en && write_pipe[WRITE_LATENCY-1].we) begin
			case(write_pipe[WRITE_LATENCY-1].bank_sel)
				2'd0: s1.mem[write_pipe[WRITE_LATENCY-1].local_addr] <= write_pipe[WRITE_LATENCY-1].din;
				2'd1: s2.mem[write_pipe[WRITE_LATENCY-1].local_addr] <= write_pipe[WRITE_LATENCY-1].din;
				2'd2: s3.mem[write_pipe[WRITE_LATENCY-1].local_addr] <= write_pipe[WRITE_LATENCY-1].din;
				2'd3: s4.mem[write_pipe[WRITE_LATENCY-1].local_addr] <= write_pipe[WRITE_LATENCY-1].din;
			endcase
		end
	end

	// read pipeline (stores mux_out each cycle)
	always_ff @(posedge clk) begin
		read_pipe_req[0] <= '{bank_sel, local_addr};
		for(int i=1;i<READ_LATENCY;i++) begin
			read_pipe_req[i] <= read_pipe_req[i-1];
		end
	end

	// Data pipeline
	always_ff @(posedge clk) begin
		read_data_pipe[0] <= mux_out;
		for(int i=1; i<READ_LATENCY;i++) begin
			read_data_pipe[i] <= read_data_pipe[i-1];
		end
		dout <= read_data_pipe[READ_LATENCY-1];
	end

	//assign dout = read_pipe[READ_LATENCY-1];
	assign bank_sel = addr[4:3];
	assign local_addr = addr[2:0];

	assign en1 = en && !we && (read_pipe_req[0].bank_sel == 2'd0);
	assign en2 = en && !we && (read_pipe_req[0].bank_sel == 2'd1);
	assign en3 = en && !we && (read_pipe_req[0].bank_sel == 2'd2);
	assign en4 = en && !we && (read_pipe_req[0].bank_sel == 2'd3);


endmodule : multi_bank_spram_with_latencies

