module true_dual_port_ram (
    input  logic         clka,
    input  logic         ena,
    input  logic         wea,
    input  logic [2:0]   addra,
    input  logic [7:0]   dina,
    output logic [7:0]   douta,

    input  logic         clkb,
    input  logic         enb,
    input  logic         web,
    input  logic [2:0]   addrb,
    input  logic [7:0]   dinb,
    output logic [7:0]   doutb
);

    logic [7:0] ram [7:0];

    // Port A operations
    always_ff @(posedge clka) begin
        if (ena) begin
            if (wea)
                ram[addra] <= dina;
            douta <= ram[addra];
        end
    end

    // Port B operations
    always_ff @(posedge clkb) begin
        if (enb) begin
            if (web)
                ram[addrb] <= dinb;
            doutb <= ram[addrb];
        end
    end

endmodule
