module mbank_controller # (
	parameter WRITE_LATENCY = 2,
	parameter READ_LATENCY = 2
) (

	// inputs
	input logic clk,
	input logic rst,
	input logic req,	// new request
	input logic we,
	input logic [4:0] addr,
	input logic [7:0] din,

	// outputs
	output logic [7:0] dout,
	output logic ready,
	output logic busy
);

	// Internal control
	logic mb_en, mb_we;
	logic [4:0]  mb_addr;
	logic [7:0]  mb_din, mb_dout;
    	logic [3:0]  count;

    	typedef enum logic [1:0] {IDLE, RUN, DONE} state_t;
    	state_t state, next_state;

    	assign mb_addr = addr;
    	assign mb_din  = din;
    	assign mb_en   = (state == RUN);
    	assign mb_we   = we;

    	// Memory instance with latency
    	multi_bank_spram_with_latencies #(.READ_LATENCY(READ_LATENCY),
					  .WRITE_LATENCY(WRITE_LATENCY)
	) dpath (
		.clk(clk), 
		.en(mb_en), 
		.we(mb_we), 
		.addr(mb_addr), 
		.din(mb_din), 
		.dout(mb_dout)
	);

    	// Controller state machine
    	always_ff @(posedge clk or posedge rst) begin
        	if (rst) begin
            		state <= IDLE;
            		dout  <= 0;
           	 	busy  <= 0;
            		ready <= 1;
            		count <= 0;
        	end else begin
            		state <= next_state;
            		case(state)
              			IDLE: begin
                  			dout  <= 0;
                  			busy  <= 0;
                  			ready <= 1;
                  			count <= 0;
              			end
              			RUN: begin
                  			ready <= 0;
                  			busy <= 1;
                  			count <= count + 1;
                  			// Capture output after latency
                  			if ((!we) && (count == READ_LATENCY-1))
                      				dout <= mb_dout;
              			end
              			DONE: begin
                  			ready <= 1;
                  			busy <= 0;
                  			count <= 0;
              			end
            		endcase
        	end
    	end

    	// Next state logic
    	always_comb begin
        	next_state = state;
        	case(state)
            		IDLE: if (req) next_state = RUN;
            		RUN:  if ((we && count == WRITE_LATENCY-1) || (!we && count == READ_LATENCY-1))
                      		next_state = DONE;
            		DONE: next_state = IDLE;
        	endcase
    	end
	
	
endmodule
