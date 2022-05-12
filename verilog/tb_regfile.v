`include "./definitions.v"
`include "./regfile.v"

// `timescale <unit> / <precision>
`timescale 1ns/100ps

module tb_regfile ();
    
    // output waveform
    initial begin

        $dumpfile("testbench/regfile.vcd");
        $dumpvars;
        
    end

    // test parameters
    integer i, ia, ib;

    localparam SZA = 2 ** `SZB_REG;
    localparam UPP = 2 ** `BIT_DATA;

    // test io
    reg clock, reset, rd_we, en_mv, write_inst;

    reg [`SZB_REG  - 1 : 0] addr_rs0, addr_rs1, addr_rd;
    reg [`SZB_INS  - 1 : 0] addr_inst;
    reg [`BIT_DATA - 1 : 0] rd, d;

    wire [`BIT_DATA - 1 : 0] rs0, rs1, q;

    // test verification


    // test module
    regfile #(.BIT (`BIT_DATA),
              .SZB (`SZB_REG))  dreg
    (
        .clock (clock),
        .reset (reset),
        .rd_we (rd_we),
        .en_mv (en_mv),

        .addr_rs0 (addr_rs0),
        .addr_rs1 (addr_rs1),
        .addr_rd  (addr_rd),

        .rd  (rd),
        .rs0 (rs0),
        .rs1 (rs1)
    );

    regfile #(.BIT (`BIT_DATA),
              .SZB (`SZB_REG))  ireg
    (
        .clock (clock),
        .reset (reset),
        .rd_we (write_inst),
        .en_mv (`OFF),

        .addr_rs0 (addr_inst),
        .addr_rs1 ({`SZB_REG{`OFF}}),
        .addr_rd  (addr_inst),

        .rd  (d),
        .rs0 (q)
    );

    // clock generator
    initial           clock <= `OFF;
    always #(`SWITCH) clock <= ~clock;

    // test sequences
    initial begin

        // initialise
        reset <= `ON;

        rd_we      <= `OFF;
        en_mv      <= `OFF;

        addr_rs0   <= {`SZB_REG{`OFF}};
        addr_rs1   <= {`SZB_REG{`OFF}};
        addr_rd    <= {`SZB_REG{`OFF}};
        addr_inst  <= {`SZB_INS{`OFF}};
        
        rd <= {`BIT_DATA{`OFF}};

        #(`DELAY)

        reset <= `OFF;

        rd_we <= `ON;

        #1

        // test: store data
        for (i = 0; i < SZA; i = i + 1) begin

            #(`DELAY)

            addr_rs0  <= i;
            addr_rs1  <= i + 1;
            addr_rd   <= i;
            addr_inst <= i;

            rd <= $random % UPP;
            
        end

        ia <= $random % SZA;
        ib <= $random % SZA;

        #(`DELAY)

        // test: move data
        rd_we <= `OFF;
        en_mv <= `ON;

        addr_rs0 <= ia;
        addr_rs1 <= ib;
        addr_rd  <= ib;

        #(`DELAY)

        en_mv <= `OFF;

        #(`DELAY)

        $finish();
        
    end

    initial begin

        // initialise
        write_inst <= `OFF;        
        d          <= {`BIT_DATA{`OFF}};
        write_inst <= `OFF;

        #(`DELAY)

        // test: store instructions
        write_inst <= `ON;

        #1

        // 0
        d <= {`LOAD, 4'd0, 8'd0};

        #(`DELAY)

        // 1
        d <= {`STORE, 8'd1, 4'd1};

        #(`DELAY)

        // 2
        d <= {`MOVE, 4'd0, 4'd2, 4'b0};

        #(`DELAY)

        // 3
        d <= {`JUMP, 4'd2, 8'b0};

        #(`DELAY)

        // 4
        d <= {`INV, 4'd3, 4'd1, 4'b0};

        #(`DELAY)

        // 5
        d <= {`AND, 4'd4, 4'd3, 4'd2};

        #(`DELAY)

        // 6
        d <= {`OR, 4'd5, 4'd3, 4'd2};

        #(`DELAY)

        // 7
        d <= {`XOR, 4'd6, 4'd3, 4'd2};

        #(`DELAY)

        // 8
        d <= {`XNOR, 4'd7, 4'd3, 4'd2};

        #(`DELAY)

        // 9
        d <= {`COM, 4'd8, 4'd3, 4'd2};

        #(`DELAY)

        // 10
        d <= {`SHR, 4'd9, 4'd3, 4'd2};

        #(`DELAY)

        // 11
        d <= {`SHL, 4'd10, 4'd3, 4'd2};

        #(`DELAY)

        // 12
        d <= {`ADD, 4'd11, 4'd3, 4'd2};

        #(`DELAY)

        // 13
        d <= {`SUB, 4'd12, 4'd3, 4'd2};

        #(`DELAY)

        // 14
        d <= {`MUL, 4'd13, 4'd3, 4'd2};

        #(`DELAY)

        // 15
        d <= {`DIV, 4'd14, 4'd3, 4'd2};

        #(`DELAY)

        write_inst <= `OFF;
        
    end
    
endmodule