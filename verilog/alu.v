`include "./definitions.v"

module alu
(
    input clock, reset,

    input  [`BIT_OP   - 1 : 0] alu_op,
    input  [`BIT_DATA - 1 : 0] din0, din1,
    output [`BIT_DATA - 1 : 0] dout
);

    reg [`BIT_DATA - 1 : 0] temp;

    assign dout = temp;

    always @(posedge clock or posedge reset) begin

        if (reset) temp <= {`BIT_DATA{`OFF}};

        else begin

            casex (alu_op)

                `INV  : temp <= ~din0;
                `AND  : temp <=  din0  & din1;
                `OR   : temp <=  din0  | din1;
                `XOR  : temp <=  din0  ^ din1;
                `XNOR : temp <=  din0 ~^ din1;
                `COM  : begin

                    temp [0] <= (din0  < din1);
                    temp [1] <= (din0 == din1);
                    temp [2] <= (din0  > din1);
                    
                end

                `SHR : temp <= din0 >>> din1;
                `SHL : temp <= din0 <<< din1;
                `ADD : temp <= din0  +  din1;
                `SUB : temp <= din0  -  din1;
                `MUL : temp <= din0  *  din1;
                `DIV : temp <= din0  /  din1;

                default : temp <= temp;

            endcase
            
        end
        
    end

endmodule