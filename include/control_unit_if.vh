`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;

  opcode_t            opcode;
  funct_t             funct;
  pcsrc_t             PCSrc;
  aluop_t             ALUOp;
  logic               equal, stall, WrLinkReg, ShiftUp, MemRd,
                      ExtOp, ALUSrc, MemToReg, MemWr, RegWr,
                      RegDst, halt;

  // control unit device
  modport cu (
    input   opcode, funct, equal, stall,
    output  WrLinkReg, ShiftUp, MemRd, ExtOp, PCSrc,
            ALUSrc, MemToReg, MemWr, RegWr, RegDst,
            halt, ALUOp
  );

  // testbench
  modport tb (
    input  WrLinkReg, ShiftUp, MemRd, ExtOp, PCSrc,
           ALUSrc, MemToReg, MemWr, RegWr, RegDst,
           halt, ALUOp,
    output opcode, funct, equal, stall
  );

endinterface

`endif //CONTROL_UNIT_IF_VH
