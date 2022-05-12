`include "./definitions.v"

module regfile
#(
    parameter BIT = 8,
    parameter SZB = 4
 )
(
    input clock, reset, rd_we, en_mv,

    input [SZB - 1 : 0] addr_rs0, addr_rs1, addr_rd,

    input [`BIT_DATA - 1 : 0] rd,

    output [`BIT_DATA - 1 : 0] rs0, rs1
);

    localparam SZA = 2 ** SZB;

    reg [`BIT_DATA - 1 : 0] regf [0 : SZA - 1];

    integer ri;

    always @(posedge clock or posedge reset) begin

        if (reset) begin

            for (ri = 0; ri < SZA; ri = ri + 1) regf [ri] <= {`BIT_DATA{`OFF}};
            
        end

        else if (rd_we) regf [addr_rd] <= rd;

        else if (en_mv) regf [addr_rd] <= regf [addr_rs0];

        else regf [0] <= regf [0];
        
    end

    assign rs0 = regf [addr_rs0];
    assign rs1 = regf [addr_rs1];
    
endmodule
