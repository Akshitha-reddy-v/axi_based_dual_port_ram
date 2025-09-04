`timescale 1ns/1ps

module tb_ram_with_encoder;

    // Parameters
    localparam int DATA_WIDTH = 8;
    localparam int ADDR_WIDTH = 3;
    localparam int DEPTH      = 1 << ADDR_WIDTH;

    // Clock and signals
    logic clkA, clkB;
    logic enA, rstA, weA;
    logic enB, rstB, weB;
    logic [ADDR_WIDTH-1:0] addrA, addrB;
    logic [DATA_WIDTH-1:0] dinA, dinB;
    logic [DATA_WIDTH-1:0] doutA, doutB;
    logic errA, errB;

    // DUT
    tdpram_with_ecc #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) dut (
        .clkA (clkA), .enA (enA), .rstA(rstA),
        .addrA(addrA), .dinA(dinA), .weA(weA),
        .doutA(doutA), .errA(errA),

        .clkB (clkB), .enB (enB), .rstB(rstB),
        .addrB(addrB), .dinB(dinB), .weB(weB),
        .doutB(doutB), .errB(errB)
    );

    // Clock generation (independent clocks for A and B)
    initial clkA = 0;
    always #5 clkA = ~clkA;  // 100 MHz

    initial clkB = 0;
    always #7 clkB = ~clkB;  // ~71 MHz

    // Test sequence
    initial begin
        // Init
        enA = 0; rstA = 1; weA = 0; addrA = 0; dinA = 0;
        enB = 0; rstB = 1; weB = 0; addrB = 0; dinB = 0;

        // Release reset
        repeat (2) @(posedge clkA);
        rstA = 0; rstB = 0;
        enA = 1; enB = 1;

        // ---- Port A writes ----
        @(posedge clkA);
        weA   = 1;
        addrA = 3'd0;
        dinA  = 8'hA5;   // write pattern A5h

        @(posedge clkA);
        weA   = 1;
        addrA = 3'd1;
        dinA  = 8'h3C;   // write pattern 3Ch

        @(posedge clkA);
        weA   = 0; // stop writing

        // ---- Port B reads (raw ECC codewords are decoded in DUT to doutB) ----
        @(posedge clkB);
        addrB = 3'd0;

        @(posedge clkB);
        addrB = 3'd1;

        // ---- Observe outputs ----
        repeat (5) @(posedge clkA);

        $finish;
    end

endmodule
