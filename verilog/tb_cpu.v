`include "./definitions.v"
`include "./cpu.v"

// `timescale <unit> / <precision>
`timescale 1ns/10ps

module tb_cpu ();

    // output waveform
    initial begin

        $dumpfile("testbench/cpu.vcd");
        $dumpvars;
        
    end

    // test parameters
    localparam UPPER = 2 ** `BIT_DATA;
    
    integer i;

    // test io
    reg                     clock, reset, interrupt;
    reg [`BIT_INST - 1 : 0] io_inst;
    reg [`BIT_DATA - 1 : 0] io_din, ram_q;

    wire                     ram_we;
    wire [`SZB_RAM  - 1 : 0] addr_ram;
    wire [`BIT_DATA - 1 : 0] ram_d, io_dout;

    // test verification


    // test module
    cpu cpu
    (
        .clock (clock),
        .reset (reset),

        .interrupt (interrupt),
        .io_inst   (io_inst),
        .io_din    (io_din),
        .io_dout   (io_dout),

        .ram_we   (ram_we),
        .addr_ram (addr_ram),
        .ram_q    (ram_q),
        .ram_d    (ram_d)
    );

    // clock generator
    initial           clock <= `OFF;
    always #(`SWITCH) clock <= ~clock;

    // test sequences
    initial begin

        // initialise
        reset <= `ON;

        interrupt <= `OFF;        
        io_inst   <= {`BIT_INST{`OFF}};
        io_din    <= {`BIT_DATA{`OFF}};
        ram_q     <= {`BIT_DATA{`OFF}};

        #(`DELAY)

        reset <= `OFF;
        
        #1

        // load instructions
        interrupt <= `ON;

        io_inst <= {`LD_INS, 4'd0, 8'b0};

        #(`DELAY)

        io_din  <= {`LOAD, 4'd0, 8'd10};
        io_inst <= {`LD_INS, 4'd1, 8'b0};

        #(`DELAY)

        io_din  <= {`LOAD, 4'd1, 8'd11};
        io_inst <= {`LD_INS, 4'd2, 8'b0};

        #(`DELAY)

        io_din  <= {`INV, 4'd2, 4'd0, 4'b0};
        io_inst <= {`LD_INS, 4'd3, 8'b0};

        #(`DELAY)

        io_din  <= {`COM, 4'd3, 4'd2, 4'd1};
        io_inst <= {`LD_INS, 4'd4, 8'b0};

        #(`DELAY)

        io_din  <= {`SHR, 4'd4, 4'd2, 4'd3};
        io_inst <= {`LD_INS, 4'd5, 8'b0};

        #(`DELAY)

        io_din  <= {`SUB, 4'd5, 4'd4, 4'd2};
        io_inst <= {`LD_INS, 4'd6, 8'b0};

        #(`DELAY)
        
        io_din  <= {`MOVE, 4'd6, 4'd4, 4'b0};
        io_inst <= {`LD_INS, 4'd7, 8'b0};

        #(`DELAY)

        io_din  <= {`JUMP, 4'd11, 8'b0};
        io_inst <= {`BIT_INST{`ON}};

        #(`DELAY)

        interrupt <= `OFF;
        io_inst   <= {`BIT_INST{`OFF}};
        io_din    <= {`BIT_DATA{`OFF}};

        #(`DELAY)

        ram_q <= 2;

        #(`DELAY)

        ram_q <= 5;

        #(`DELAY)

        ram_q <= {`BIT_DATA{`OFF}};

        #(`DELAY * 7)

        $finish();
        
    end

endmodule
