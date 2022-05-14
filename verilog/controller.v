`include "./definitions.v"

module controller
(
    input clock, reset, interrupt,

    input      [`BIT_INST - 1 : 0] instructions,
    output reg [`BIT_OP   - 1 : 0] alu_op,

    output reg [`SZB_INS - 1 : 0] pc_offset, addr_ins,
    output reg [`SZB_RAM - 1 : 0] addr_RAM,
    output reg [`SZB_REG - 1 : 0] addr_rs0, addr_rs1, addr_rd,

    output reg en_offset, en_cnt,
               ram_we, rd_we, en_mv, ins_we,
    
    output reg         mux_ram_rs0_io, mux_io_rs0_ram,
    output reg [1 : 0] mux_rd_ram_alu_io
);

    wire   [`BIT_OP - 1 : 0] op_code;

    assign op_code = instructions [`BIT_INST - 1 : `BIT_INST - 4];

    always @(posedge clock or posedge reset) begin

        if (reset) begin

            pc_offset <= {`SZB_INS {`OFF}};
            addr_RAM  <= {`SZB_RAM{`OFF}};
            addr_rs0  <= {`SZB_REG{`OFF}};
            addr_rs1  <= {`SZB_REG{`OFF}};
            addr_rd   <= {`SZB_REG{`OFF}};
            addr_ins  <= {`SZB_INS{`OFF}};

            en_offset <= `OFF;
            en_cnt    <= `OFF;
            ram_we    <= `OFF;
            rd_we     <= `OFF;
            en_mv     <= `OFF;
            ins_we    <= `OFF;
            
            mux_ram_rs0_io    <= `OFF;
            mux_io_rs0_ram    <= `OFF;
            mux_rd_ram_alu_io <= 2'b00;

            alu_op <= {`BIT_OP{`OFF}};
            
        end

        else if (interrupt) begin

            pc_offset <= {`SZB_INS {`OFF}};
            addr_rs1  <= {`SZB_REG{`OFF}};

            en_offset     <= `OFF;
            en_cnt        <= `OFF;

            en_mv         <= `OFF;
            
            mux_ram_rs0_io    <= `ON;
            mux_rd_ram_alu_io <= 2'd2;

            alu_op <= {`BIT_OP{`OFF}};

            casex (op_code)

                `LD_REG : begin

                    
                    addr_RAM <= {`SZB_RAM{`OFF}};
                    addr_rs0 <= {`SZB_REG{`OFF}};
                    addr_rd  <= instructions [11 : 8];
                    addr_ins <= {`SZB_INS{`OFF}};

                    ram_we <= `OFF;
                    rd_we  <= `ON; 
                    ins_we <= `OFF;

                    mux_io_rs0_ram <= `OFF;                              
                    
                end 

                `LD_RAM : begin

                    
                    addr_RAM <= instructions [11 : 4];
                    addr_rs0 <= {`SZB_REG{`OFF}};
                    addr_rd  <= {`SZB_REG{`OFF}};
                    addr_ins <= {`SZB_INS{`OFF}};

                    ram_we <= `ON;
                    rd_we  <= `OFF; 
                    ins_we <= `OFF;

                    mux_io_rs0_ram <= `OFF;                                 
                    
                end 

                `LD_INS : begin

                    
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};
                    addr_ins  <= instructions [11 : 8];

                    ram_we <= `OFF;
                    rd_we  <= `OFF; 
                    ins_we <= `ON;

                    mux_io_rs0_ram <= `OFF;                                
                    
                end

                `OUT_REG : begin

                    
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [11 : 8];
                    addr_rd   <= {`SZB_REG{`OFF}};
                    addr_ins  <= {`SZB_INS{`OFF}};

                    ram_we <= `OFF;
                    rd_we  <= `OFF; 
                    ins_we <= `OFF;

                    mux_io_rs0_ram <= `OFF;                               
                    
                end

                `OUT_RAM : begin

                    
                    addr_RAM  <= instructions [11 : 4];
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};
                    addr_ins  <= {`SZB_INS{`OFF}};

                    ram_we <= `OFF;
                    rd_we  <= `OFF; 
                    ins_we <= `OFF;

                    mux_io_rs0_ram <= `ON;                               
                    
                end

                default : begin

                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};
                    addr_ins  <= {`SZB_INS{`OFF}};

                    ram_we <= `OFF;
                    rd_we  <= `OFF; 
                    ins_we <= `OFF;

                    mux_io_rs0_ram <= `OFF;   
                    
                end

            endcase
            
        end

        else begin

            addr_ins       <= {`SZB_INS{`OFF}};
            mux_ram_rs0_io <= `OFF;
            mux_io_rs0_ram <= `OFF;
            ins_we         <= `OFF;

            alu_op <= op_code;

            casex (op_code)

                `PASS : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rs1  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};                    

                    en_offset <= `OFF;
                    en_cnt    <= `OFF;
                    ram_we    <= `OFF;
                    rd_we     <= `OFF;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b00;
                    
                end

                `LOAD : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= instructions [7 : 0];
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rs1  <= {`SZB_REG{`OFF}};
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;
                    
                    mux_rd_ram_alu_io <= 2'b00;
                    
                end 

                `STORE : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= instructions [11 : 4];
                    addr_rs0  <= instructions [3  : 0];
                    addr_rs1  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `ON;
                    rd_we     <= `OFF;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b00;
                    
                end

                `JUMP : begin

                    pc_offset <= instructions [11 : 8];
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= {`SZB_REG{`OFF}};
                    addr_rs1  <= {`SZB_REG{`OFF}};
                    addr_rd   <= {`SZB_REG{`OFF}};                    

                    en_offset <= `ON;
                    en_cnt    <= `OFF;
                    ram_we    <= `OFF;
                    rd_we     <= `OFF;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b00;
                    
                end

                `INV : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `AND : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `OR : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `XOR : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `XNOR : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `COM : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `SHR : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `SHL : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `ADD : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `SUB : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `MUL : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                `DIV : begin

                    pc_offset <= {`SZB_INS {`OFF}};
                    addr_RAM  <= {`SZB_RAM{`OFF}};
                    addr_rs0  <= instructions [7 : 4];
                    addr_rs1  <= instructions [3 : 0];
                    addr_rd   <= instructions [11 : 8];                    

                    en_offset <= `OFF;
                    en_cnt    <= `ON;
                    ram_we    <= `OFF;
                    rd_we     <= `ON;
                    en_mv     <= `OFF;                   
                    
                    mux_rd_ram_alu_io <= 2'b01;
                    
                end

                default : en_offset <= en_offset;

            endcase
            
        end
        
    end
    
endmodule