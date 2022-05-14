`include "./definitions.v"
`include "./reg_data.v"
`include "./reg_inst.v"
`include "./pc.v"
`include "./alu.v"
`include "./controller.v"

module cpu
(
    // dut
    output [`SZA_INS * `BIT_INST - 1 : 0] testreg_inst,
    output [`SZA_REG * `BIT_DATA - 1 : 0] testreg_data,
   
    input clock, reset, 
    
    input                          interrupt,
    input      [`BIT_INST - 1 : 0] io_inst,
    input      [`BIT_DATA - 1 : 0] io_din,
    output reg [`BIT_DATA - 1 : 0] io_dout,

    output                     ram_we,
    output [`SZB_RAM  - 1 : 0] addr_ram,
    input  [`BIT_DATA - 1 : 0] ram_q,
    output [`BIT_DATA - 1 : 0] ram_d    
);

    wire en_offset, en_cnt,
         ins_we, rd_we, mv_we, ram_we;

    wire [`SZB_INS - 1 : 0] pc_offset, addr_iwe, sel_inst, addr_ins;  // addr/array of instruction regfile
    wire [`BIT_CNT - 1 : 0] pc_cnt;
    wire [`SZB_REG - 1 : 0] addr_rs0, addr_rs1, addr_rd;            // addr/array of data regfile
    wire [`BIT_OP  - 1 : 0] alu_op;

    wire         mux_io_rs0_ram, mux_ram_rs0g_io;
    wire [1 : 0] mux_rd_ram_alu_io;

    wire [`BIT_INST - 1 : 0] instructions, dinst;
    wire [`BIT_DATA - 1 : 0] rs0, rs1, rd, alu_dout;

    assign ram_d = mux_ram_rs0_io ? io_din : rs0;
    assign rd    = (mux_rd_ram_alu_io == 2'b00) ? ram_q :
                   ((mux_rd_ram_alu_io == 2'b01) ? alu_dout : io_din);

    assign instructions = interrupt ? io_inst  : dinst;
    assign sel_inst     = pc_cnt >> 2;
    assign addr_ins     = ins_we    ? addr_iwe : sel_inst;

    always @(posedge clock or posedge reset) begin

        if (reset) io_dout <= {`BIT_DATA{`OFF}};

        else if (mux_io_rs0_ram) io_dout <= ram_q;

        else io_dout <= rs0;
        
    end

    reg_inst #(.BIT (`BIT_INST),
              .SZB (`BIT_OP))   regfile_instructions
    (
        .testreg (testreg_inst),
        
        .clock (clock),
        .reset (reset),
        .we    (ins_we),
        .addr  (addr_ins),
        .din   (io_din),
        .dout  (dinst)
    );

    reg_data #(.BIT (`BIT_DATA),
              .SZB (`SZB_REG))   regfile_data
    (
        .testreg (testreg_data),
        
        .clock (clock),
        .reset (reset),
        .we (rd_we),

        .addr_rs0 (addr_rs0),
        .addr_rs1 (addr_rs1),
        .addr_rd  (addr_rd),

        .rd  (rd),
        .rs0 (rs0),
        .rs1 (rs1)
    );

    pc pc
    (
        .clock (clock),
        .reset (reset),

        .en_offset (en_offset),
        .en_cnt    (en_cnt),

        .pc_offset (pc_offset),
        .pc_cnt    (pc_cnt)
    );

    controller controller
    (
        .clock     (clock),
        .reset     (reset),
        .interrupt (interrupt),

        .instructions (instructions),
        .alu_op       (alu_op),
        .pc_offset    (pc_offset),
        .addr_RAM     (addr_ram),
        .addr_rs0     (addr_rs0),
        .addr_rs1     (addr_rs1),
        .addr_rd      (addr_rd),
        .addr_ins     (addr_iwe),
        
        .en_offset (en_offset),
        .en_cnt    (en_cnt),
        .ram_we    (ram_we),
        .rd_we     (rd_we),
        .en_mv     (en_mv),
        .ins_we    (ins_we),

        .mux_ram_rs0_io    (mux_ram_rs0_io),
        .mux_rd_ram_alu_io (mux_rd_ram_alu_io)
    );

    alu alu
    (
        .clock  (clock),
        .reset  (reset),
        .alu_op (alu_op),

        .din0 (rs0),
        .din1 (rs1),
        .dout (alu_dout)
    );

endmodule
