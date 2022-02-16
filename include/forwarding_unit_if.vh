`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
  // import types
  import cpu_types_pkg::*;
 
  word_t new_rdat1, new_rdat2, aluOut, writeback;
  regbits_t rs, rt, mem_wsel, wr_wsel;
  logic override_rdat1, override_rdat2, mem_RegWr, wr_RegWr;

  // forwarding unit device
  modport fu (
    input   aluOut, writeback, mem_wsel, mem_RegWr, wr_wsel, wr_RegWr, rs, rt, 
    output  new_rdat1, override_rdat1, new_rdat2, override_rdat2
  );

  // testbench
  modport tb (
    input    new_rdat1, override_rdat1, new_rdat2, override_rdat2,
    output   aluOut, writeback, mem_wsel, mem_RegWr, wr_wsel, wr_RegWr, rs, rt
  );

endinterface

`endif //FORWARDING_UNIT_IF_VH
