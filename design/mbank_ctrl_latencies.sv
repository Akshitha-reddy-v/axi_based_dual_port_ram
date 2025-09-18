module multi_bank_spram_32x8_sep_lat (
    input  logic        clk,
    input  logic        en,
    input  logic        we,
    input  logic [4:0]  addr,
    input  logic [7:0]  din,
    output logic [7:0]  dout
);
    parameter READ_LATENCY  = 2;
    parameter WRITE_LATENCY = 2;

    // Bank outputs
    logic [7:0] w1, w2, w3, w4;

    // FIFOs for write, read address
    logic       we_fifo     [0:WRITE_LATENCY-1];
    logic [4:0] addrw_fifo  [0:WRITE_LATENCY-1];
    logic [7:0] din_fifo    [0:WRITE_LATENCY-1];
    logic [$clog2(WRITE_LATENCY):0] wr_wrptr = 0, wr_rdptr = 0;

    logic [4:0] addrr_fifo  [0:READ_LATENCY-1];
    logic [$clog2(READ_LATENCY):0] rd_wrptr = 0, rd_rdptr = 0;

    // Bank modules
    single_port_ram s1 (.clk(clk),
                        .en(en && (addrw_fifo[wr_rdptr][4:3] == 2'b00)),
                        .we(we_fifo[wr_rdptr] && (addrw_fifo[wr_rdptr][4:3] == 2'b00)),
                        .addr(addrw_fifo[wr_rdptr][2:0]),
                        .din(din_fifo[wr_rdptr]),
                        .dout(w1));
    single_port_ram s2 (.clk(clk),
                        .en(en && (addrw_fifo[wr_rdptr][4:3] == 2'b01)),
                        .we(we_fifo[wr_rdptr] && (addrw_fifo[wr_rdptr][4:3] == 2'b01)),
                        .addr(addrw_fifo[wr_rdptr][2:0]),
                        .din(din_fifo[wr_rdptr]),
                        .dout(w2));
    single_port_ram s3 (.clk(clk),
                        .en(en && (addrw_fifo[wr_rdptr][4:3] == 2'b10)),
                        .we(we_fifo[wr_rdptr] && (addrw_fifo[wr_rdptr][4:3] == 2'b10)),
                        .addr(addrw_fifo[wr_rdptr][2:0]),
                        .din(din_fifo[wr_rdptr]),
                        .dout(w3));
    single_port_ram s4 (.clk(clk),
                        .en(en && (addrw_fifo[wr_rdptr][4:3] == 2'b11)),
                        .we(we_fifo[wr_rdptr] && (addrw_fifo[wr_rdptr][4:3] == 2'b11)),
                        .addr(addrw_fifo[wr_rdptr][2:0]),
                        .din(din_fifo[wr_rdptr]),
                        .dout(w4));

    // Write FIFO logic
    always_ff @(posedge clk) begin
        if (en && we) begin
            we_fifo[wr_wrptr]    <= we;
            addrw_fifo[wr_wrptr] <= addr;
            din_fifo[wr_wrptr]   <= din;
            wr_wrptr             <= (wr_wrptr + 1) % WRITE_LATENCY;
        end
        wr_rdptr <= (wr_rdptr + 1) % WRITE_LATENCY;
    end

    // Read address FIFO logic
    always_ff @(posedge clk) begin
        if (en && !we) begin
            addrr_fifo[rd_wrptr] <= addr;
            rd_wrptr             <= (rd_wrptr + 1) % READ_LATENCY;
        end
        rd_rdptr <= (rd_rdptr + 1) % READ_LATENCY;
    end

    // Output mux for delayed read
    always_comb begin
        unique case (addrr_fifo[rd_rdptr][4:3])
            2'b00: dout = w1;
            2'b01: dout = w2;
            2'b10: dout = w3;
            2'b11: dout = w4;
            default: dout = '0;
        endcase
    end
endmodule
