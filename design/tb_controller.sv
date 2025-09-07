module tb_mbank_controller;

    parameter READ_LATENCY = 2;
    parameter WRITE_LATENCY = 2;

    // DUT signals
    logic clk, rst, req, we;
    logic [4:0] addr;
    logic [7:0] din, dout;
    logic busy, ready;

    // Instantiate controller
    mbank_controller #(.READ_LATENCY(READ_LATENCY), .WRITE_LATENCY(WRITE_LATENCY)) dut (
        .clk(clk), .rst(rst), .req(req), .we(we),
        .addr(addr), .din(din), .dout(dout),
        .ready(ready), .busy(busy)
    );

    // Clock generation
    initial clk = 1'b0;
    always #5 clk = ~clk;

    // Wrapper tasks to request write/read cycles
    task write(input [4:0] waddr, input [7:0] wdata);
        begin
            @(negedge clk);
            req  = 1;
            we   = 1;
            addr = waddr;
            din  = wdata;
            @(negedge clk);
            req  = 0;
            while (busy) @(negedge clk);
        end
    endtask

    task read(input [4:0] raddr, output [7:0] rdata);
        begin
            @(negedge clk);
            req  = 1;
            we   = 0;
            addr = raddr;
            @(negedge clk);
            req  = 0;
            while (busy) @(negedge clk);
            rdata = dout;
        end
    endtask

    // Test stimulus
    initial begin
        integer i;
        logic [7:0] rdata;
        // Initialize
        req = 0; we = 0; addr = 0; din = 0; rst = 1;
        #15; rst = 0;

        // Write values: RAM[addr]=addr
        for (i = 0; i < 32; i++) begin
            write(i, i[7:0]);
        end

        // Read + check values
        for (i = 0; i < 32; i++) begin
            read(i, rdata);
            $display("Read: Addr=%0d, Data=%0d", i, rdata);
            if (rdata !== i[7:0]) begin
                $display("*** ERROR: Addr=%0d, expected %0d, got %0d", i, i[7:0], rdata);
            end
        end

        $display("TB completed.");
        $finish;
    end

endmodule
