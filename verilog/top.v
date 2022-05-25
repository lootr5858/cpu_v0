`include "./definitions.v"
`include "./cpu.v"
`include "./RAM.v"

module top
(
    input clock, reset,

    // io
    input                      interrupt,
    input  [`BIT_INST - 1 : 0] io_inst,
    input  [`BIT_DATA - 1 : 0] io_din,
    output [`BIT_DATA - 1 : 0] io_dout
);

    wire                     ram_we;
    wire [`SZB_RAM  - 1 : 0] addr_ram;
    wire [`BIT_DATA - 1 : 0] ram_d, ram_q;

    cpu cpu 
    (
        .clock (clock),
        .reset (reset),

        // io
        .interrupt (interrupt),
        .io_inst   (io_inst),
        .io_din    (io_din),
        .io_dout   (io_dout),

        // ram
        .ram_we   (ram_we),
        .addr_ram (addr_ram),
        .ram_d    (ram_d),
        .ram_q    (ram_q)
    );

    RAM #(.BIT (`BIT_DATA),
          .SZB (`SZB_RAM))  RAM 
    (
        .clock (clock),
        .reset (reset),
        .we    (ram_we),
        .addr  (addr_ram),
        .d     (ram_d),
        .q     (ram_q)
    );
    
endmodule
