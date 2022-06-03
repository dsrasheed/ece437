`ifndef DP_TYPES_PKG_EXT_VH
`define DP_TYPES_PKG_EXT_VH

`include "cpu_types_pkg.vh"

package datapath_types_pkg;

  import cpu_types_pkg::*;

// Predicition Result
  typedef enum logic [1:0] {
    RIGHT_PRED,
    WRONG_PRED,
    NA
  } pred_t;

// PC Src
  typedef enum logic [2:0] {
    NEXT,
    BREQ,
    BRNE,
    JUMP,
    JUMPR,
    KEEP
  } pcsrc_t;

  typedef struct packed {
    word_t instr;
    word_t pc;
  } fetch_latch_t;

  typedef struct packed {
    // Control Output
    logic halt;
    logic [REG_W-1:0] wsel;
    logic RegWr;
    logic MemToReg;
    logic WrLinkReg;
    logic MemRd;
    logic MemWr;
    pcsrc_t PCSrc;
    aluop_t ALUOp;
    logic ALUSrc;
    logic Atomic; 
    // Extender Block Output
    word_t extOut;
    // Register File Output
    word_t rdat1;
    word_t rdat2;
    // Jump Addr Forwarding
    logic [ADDR_W-1:0] j_offset;
    // PC Forwarding
    word_t pc;
    // Forwarding Unit Info
    regbits_t rs, rt;
    // Hazard Unit Info
    logic pred_taken;
  } decode_latch_t;

  typedef struct packed {
    // Control Output
    logic halt;
    logic [REG_W-1:0] wsel;
    logic RegWr;
    logic MemToReg;
    logic WrLinkReg;
    logic MemRd;
    logic MemWr;
    pcsrc_t PCSrc;
    logic Atomic;
    // ALU Output
    word_t aluOut;
    logic zero;
    // Register File Output
    word_t rdat1;
    word_t rdat2;
    // Next PC Logic
    word_t b_addr;
    word_t j_addr;
    // PC Forwarding
    word_t pc;
    // Hazard Unit Info
    logic pred_taken;
  } exec_latch_t;

  typedef struct packed {
    // Control Output
    logic halt;
    logic [REG_W-1:0] wsel;
    logic RegWr;
    logic MemToReg;
    logic WrLinkReg;
    // ALU Output
    word_t aluOut;
    // DCache Output
    word_t dmemload;
    // PC Forwarding
    word_t pc;
  } mem_latch_t;
  
  typedef struct packed {
    logic RegWr;
    funct_t funct;
    opcode_t opcode;
    regbits_t rs;
    regbits_t rt;
    regbits_t wsel;
    word_t instr;
    word_t pc;
    word_t nxt_pc;
    logic [IMM_W-1:0] lui;
    logic [SHAM_W-1:0] shamt;
    word_t imm;
    logic WrLinkReg;
    word_t branch;
    word_t daddr;
    word_t dstore;
    word_t writeback;
  } cpu_tracker_t;

endpackage
`endif //CPU_TYPES_PKG_EXT_VH
