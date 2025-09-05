module tb_true_dual_port_ram;

    // Testbench signals (matching the RTL)
    logic         clka, clkb;
    logic         ena, enb;
    logic         wea, web;
    logic [2:0]   addra, addrb;
    logic [7:0]   dina, dinb;
    logic [7:0]   douta, doutb;

    // Instantiate DUT
    true_dual_port_ram dut (
        .clka(clka), .ena(ena), .wea(wea), .addra(addra), .dina(dina), .douta(douta),
        .clkb(clkb), .enb(enb), .web(web), .addrb(addrb), .dinb(dinb), .doutb(doutb)
    );

    // Generate clocks
    initial clka = 0;
    always #5  clka = ~clka;

    initial clkb = 0;
    always #7  clkb = ~clkb;

    // Test procedures
    initial begin
        // Initialize signals
        ena = 0; wea = 0; addra = 0; dina = 0;
        enb = 0; web = 0; addrb = 0; dinb = 0;

        // Wait for clock stabilization
        #20;

        // 1. Write to address 3 from port A
        ena = 1; wea = 1; addra = 3; dina = 8'hA5;
        @(posedge clka);
        wea = 0; // Stop writing
        @(posedge clka);

        // 2. Read from address 3 from port B
        enb = 1; web = 0; addrb = 3;
        @(posedge clkb);
        @(posedge clkb);
        if (doutb !== 8'hA5)
            $display("Test 1 Failed: doutb = %h (expected 0xA5)", doutb);
        else
            $display("Test 1 Passed");

        // 3. Simultaneous write (A: addr=2, B: addr=6)
        ena = 1; wea = 1; addra = 2; dina = 8'h55;
        enb = 1; web = 1; addrb = 6; dinb = 8'hCC;
        @(posedge clka);
        wea = 0; web = 0;
        @(posedge clka);

        // 4. Read back from both addresses
        addra = 6; ena = 1; wea = 0;
        addrb = 2; enb = 1; web = 0;
        @(posedge clka);
        if (douta !== 8'hCC)
            $display("Test 2A Failed: douta = %h (expected 0xCC)", douta);
        else
            $display("Test 2A Passed");
        if (doutb !== 8'h55)
            $display("Test 2B Failed: doutb = %h (expected 0x55)", doutb);
        else
            $display("Test 2B Passed");

        $finish;
    end
endmodule
