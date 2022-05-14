// constants
`define OFF 1'b0
`define ON  1'b1

// clock specs (tb)
`define SWITCH 5
`define DELAY  `SWITCH * 2

// bit-width / word length
`define BIT_DATA 16
`define BIT_INST 16
`define BIT_OP   4 
`define BIT_CNT  $clog2(`SZA_INS * 4)   

// array sizes
`define SZB_INS  4
`define SZB_REG  4
`define SZB_RAM  8

`define SZA_INS 2 ** `SZB_INS
`define SZA_REG 2 ** `SZB_REG
`define SZA_RAM 2 ** `SZB_RAM

// opcodes
`define PASS   4'b0000
`define LOAD   4'b0001
`define STORE  4'b0010
`define JUMP   4'b0011
`define INV    4'b0100
`define AND    4'b0101
`define OR     4'b0110
`define XOR    4'b0111
`define XNOR   4'b1000
`define COM    4'b1001
`define SHR    4'b1010
`define SHL    4'b1011
`define ADD    4'b1100
`define SUB    4'b1101
`define MUL    4'b1110
`define DIV    4'b1111

// interrupts
`define LD_REG  4'b0000
`define LD_RAM  4'b0001
`define LD_INS  4'b0010
`define OUT_REG 4'b0011
`define OUT_RAM 4'b0100
