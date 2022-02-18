`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  aluop_t   aluop;
  word_t    ra, rb, out;
  logic     negative, overflow, zero;

  // ALU ports
  modport alu (
    input   aluop, ra, rb,
    output  out, negative, overflow, zero
  );
  // ALU tb
  modport tb (
    input   out, negative, overflow, zero,
    output  aluop, ra, rb
  );
endinterface

`endif //ALU_IF_VH
