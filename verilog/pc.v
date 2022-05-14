`include "./definitions.v"

module pc
(
    input clock, reset, en_offset, en_cnt,

    input      [`SZB_INS - 1 : 0] pc_offset,
    output reg [`BIT_CNT - 1 : 0] pc_cnt
);

    always @(posedge clock or posedge reset) begin

        if (reset) pc_cnt <= {`SZB_INS{`OFF}};

        else if (en_offset) pc_cnt <= pc_cnt + (pc_offset * 4);

        else if (en_cnt) pc_cnt <= pc_cnt + 1;

        else pc_cnt <= pc_cnt;
        
    end
    
endmodule
