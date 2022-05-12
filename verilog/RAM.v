`include "./definitions.v"

module RAM
#(
    parameter BIT = 8,
    parameter SZB = 4
 )
(
    // // dut
    // output [SZA * `BIT_DATA - 1 : 0] test_q,
    
    // control
    input               clock, reset, we,
    input [SZB - 1 : 0] addr,

    // data
    input  [BIT - 1 : 0] d,
    output [BIT - 1 : 0] q
);

    localparam SZA = 2 ** SZB;

    reg [BIT - 1 : 0] mem [0 : SZA - 1];

    integer ri;

    assign q = mem [addr];

    always @(posedge clock or posedge reset) begin

        if (reset) begin

            for (ri = 0; ri < SZA; ri = ri + 1) mem [ri] <= {BIT{`OFF}};
            
        end

        else if (we) begin

            mem [addr] <= d;
            
        end

        else mem [0] <= mem [0];
        
    end

    // // dut
    // genvar i;
    // generate

    //     for (i = 0; i < SZA; i = i + 1) assign test_q [`BIT_DATA * (i + 1) - 1 : `BIT_DATA * i] = mem [i];

    // endgenerate

endmodule
