`include "./definitions.v"

module reg_data
#(
    parameter BIT = 8,
    parameter SZB = 4
 )
(
    // // dut
    // output [SZA * BIT - 1 : 0] testreg,
    
    input                    clock, reset, we,
    input      [SZB - 1 : 0] addr_rs0, addr_rs1, addr_rd,
    input      [BIT - 1 : 0] rd,
    output reg [BIT - 1 : 0] rs0, rs1
);

    localparam SZA = 2 ** SZB;

    reg [`BIT_DATA - 1 : 0] regf [0 : SZA - 1];

    integer ri;

    always @(posedge clock or posedge reset) begin

        if (reset) begin

            for (ri = 0; ri < SZA; ri = ri + 1) regf [ri] <= {`BIT_DATA{`OFF}};
            
        end

        else if (we) regf [addr_rd] <= rd;

        else regf [0] <= regf [0];
        
    end

    always @(posedge clock or posedge reset) begin

        if (reset) begin

            rs0 <= {`BIT_DATA{`OFF}};
            rs1 <= {`BIT_DATA{`OFF}};
            
        end

        else begin

            rs0 <= regf [addr_rs0];
            rs1 <= regf [addr_rs0];
            
        end
        
    end

    // // dut
    // genvar ti;
    // generate

    //     for (ti = 0; ti < SZA; ti = ti + 1) assign testreg [BIT * (ti + 1) - 1 : BIT * ti] = regf [ti];
        
    // endgenerate
    
endmodule
