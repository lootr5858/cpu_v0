`include "./definitions.v"
`include "./RAM.v"

// `timescale <unit> / <precision>
`timescale 1ns/100ps

module tb_RAM ();

    // output waveform
    initial begin

        $dumpfile("testbench/RAM.vcd");
        $dumpvars;
        
    end

    // teset parameters
    integer i, j;

    localparam UPPER = 2 ** `BIT_DATA;
    localparam SZA   = 2 ** `SZB_RAM;

    // test io
    reg                     clock, reset, we;
    reg [`SZB_RAM  - 1 : 0] addr;
    reg [`BIT_DATA - 1 : 0] d;

    wire [`BIT_DATA       - 1 : 0] q;
    wire [SZA * `BIT_DATA - 1 : 0] test_q;

    // test verification


    // test module
    RAM #(.BIT  (`BIT_DATA),
          .SZB  (`SZB_RAM))   RAM 
    (
        // .test_q (test_q),
        
        .clock (clock),
        .reset (reset),
        .we    (we),

        .addr (addr),
        
        .d (d),
        .q (q)
    );

    // clock generator
    initial           clock <= `OFF;
    always #(`SWITCH) clock <= ~clock;

    // test sequences
    initial begin

        // initialise
        reset <= `ON;
        we    <= `OFF;

        addr <= {`SZB_RAM{`OFF}};
        d      <= {`BIT_DATA{`OFF}};

        #(`DELAY)

        reset <= `OFF;

        #1

        we <= `ON;

        for (i = 0; i < SZA; i = i + 1) begin

            #(`DELAY)

            d <= $random % UPPER;

            addr <= i;
            
        end

        #(`DELAY)

        we <= `OFF;

        #(`DELAY)

        $finish();
        
    end

endmodule
