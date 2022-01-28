/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 1;

  assign ccif.ramREN = (ccif.iREN | ccif.dREN) & ~ccif.dWEN;
  assign ccif.ramWEN = ccif.dWEN;
  assign ccif.ramaddr = ccif.dREN | ccif.dWEN ? ccif.daddr : ccif.iaddr;
  assign ccif.ramstore = ccif.dstore;

  assign ccif.iwait = ccif.iREN & (ccif.ramstate != ACCESS | ccif.dWEN | ccif.dREN);
  assign ccif.dwait = (ccif.dWEN | ccif.dREN) & ccif.ramstate != ACCESS;
  assign ccif.iload = ccif.ramload;
  assign ccif.dload = ccif.ramload;

endmodule
